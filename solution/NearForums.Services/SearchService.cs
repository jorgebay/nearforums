using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Lucene.Net.Index;
using Lucene.Net.Analysis.Standard;
using NearForums.Configuration;
using Lucene.Net.Store;
using System.IO;
using Lucene.Net.Documents;
using Lucene.Net.Search;
using Lucene.Net.QueryParsers;
using NearForums.Services.Helpers;
using Lucene.Net.Analysis;

namespace NearForums.Services
{
	public class SearchService : ISearchService
	{
		/// <summary>
		/// Used to lock the search index writer 
		/// </summary>
		private static object _writerLock = new object();
		private static IndexWriter _writer;
		private readonly ILoggerService _logger;

		public SearchService(ILoggerService logger)
		{
			_logger = logger;
		}

		/// <summary>
		/// Gets the directory where the index is located
		/// </summary>
		private FSDirectory Directory
		{
			get
			{
				//TODO: Make sure that the directory exist / create if not
				return FSDirectory.Open(new DirectoryInfo(Config.IndexPath));
			}
		}

		private SearchElement _config;
		/// <summary>
		/// Gets or sets the search configuration
		/// </summary>
		public SearchElement Config
		{
			get
			{
				if (_config == null)
				{
					_config = SiteConfiguration.Current.Search;
				}
				return _config;
			}
			set
			{
				_config = value;
			}
		}

		private Analyzer _analyzer;
		/// <summary>
		/// Gets or set the analyzer used by the SearchEngine
		/// </summary>
		public Analyzer Analyzer
		{
			get
			{
				if (_analyzer == null)
				{
					_analyzer = new StandardAnalyzer(Lucene.Net.Util.Version.LUCENE_29);
				}
				return _analyzer;
			}
			set
			{
				_analyzer = value;
			}
		}

		/// <summary>
		/// Adds a new topic to the index
		/// </summary>
		/// <param name="topic"></param>
		public void Add(Topic topic)
		{
			Add(new Topic[] { topic});
		}

		/// <summary>
		/// Adds a new topic to the index
		/// </summary>
		/// <param name="topic"></param>
		public void Add(IEnumerable<Topic> topicList)
		{
			if (!Config.Enabled)
			{
				return;
			}
			var writer = GetWriter();
			foreach (var topic in topicList)
			{
				var doc = topic.ToDocument(Config);
				writer.AddDocument(doc);
			}
			writer.Commit();
		}

		/// <summary>
		/// Adds the message as document (topic) field
		/// </summary>
		/// <param name="topic"></param>
		public void Add(Message message)
		{
			if (!Config.Enabled)
			{
				return;
			}
			if (message.Id > Config.MaxMessages)
			{
				return;
			}
			var writer = GetWriter();
			Document doc = null;
			using (var searcher = new IndexSearcher(writer.GetReader()))
			{
				doc = searcher.SearchById(message.Topic.Id);
			}
			if (doc == null)
			{
				return;
			}
			var dateField = doc.GetDateField();
			dateField.SetValue(DateTools.DateToString(message.Date, DateTools.Resolution.MINUTE));
			doc.Add(message.ToField());
			writer.Update(message.Topic.Id, doc, Analyzer, Config);
			writer.Commit();
		}

		/// <summary>
		/// Releases all the resources, optimices the index and closes all files of the search index.
		/// Note: This method should be executed when the application is shutting down, but it is not required for mantaining a healthy search index.
		/// </summary>
		public static void CloseIndex()
		{
			if (!SiteConfiguration.Current.Search.Enabled)
			{
				return;
			}
			if (_writer != null)
			{
				lock (_writerLock)
				{
					_writer.Close();
					_writer = null;
				}
			}
		}

		/// <summary>
		/// Creates or recreates the search index by opening a new IndexWriter with create flag
		/// </summary>
		public void CreateIndex()
		{
			if (!Config.Enabled)
			{
				throw new NotSupportedException("Creating a search index is not supported when indexing is disabled by configuration.");
			}
			lock (_writerLock)
			{
				if (_writer != null)
				{
						_writer.Close();
						_writer = null;
				}
				if (IndexWriter.IsLocked(Directory))
				{
					IndexWriter.Unlock(Directory);
				}
				//open a new writer with the create flag
				using (var writer = new IndexWriter(Directory, Analyzer, true, IndexWriter.MaxFieldLength.UNLIMITED))
				{
					//dispose: close it
				}
			}
		}

		/// <summary>
		/// Removes the message field from the document
		/// </summary>
		public void DeleteMessage(int topicId, int messageId)
		{
			if (!Config.Enabled)
			{
				return;
			}
			var writer = GetWriter();
			Document doc = null;
			using (var searcher = new IndexSearcher(writer.GetReader()))
			{
				doc = searcher.SearchById(topicId);
			}
			if (doc == null)
			{
				return;
			}
			doc.RemoveMessage(messageId);
			writer.Update(topicId, doc, Analyzer, Config);
			writer.Commit();
		}

		/// <summary>
		/// Removes the document that represents the topic
		/// </summary>
		public void DeleteTopic(int id)
		{
			if (!Config.Enabled)
			{
				return;
			}
			var writer = GetWriter();
			writer.Delete(id);
			writer.Commit();
		}

		public int DocumentCount
		{
			get
			{
				if (!Config.Enabled)
				{
					return 0;
				}
				var writer = GetWriter();
				return writer.NumDocs();
			}
		}

		/// <summary>
		/// Gets an instance of the IndexWriter with the default options
		/// </summary>
		private IndexWriter GetWriter()
		{
			lock (_writerLock)
			{
				if (_writer == null)
				{
					if (IndexWriter.IsLocked(Directory))
					{
						_logger.LogError("Search index is write locked. Trying to unlock.");
						IndexWriter.Unlock(Directory);
						_logger.LogError("Search index is unlocked.");
					}
					_writer = new IndexWriter(Directory, Analyzer, false, IndexWriter.MaxFieldLength.UNLIMITED);
				}
			}
			return _writer;
		}

		public PagedList<Topic> Search(string value, int index)
		{
			if (!Config.Enabled)
			{
				throw new NotSupportedException("Searching the index is not supported when indexing is disabled by configuration.");
			}
			var results = new List<Topic>();
			if (String.IsNullOrWhiteSpace(value))
			{
				return new PagedList<Topic>(results, 0, 1);
			}
			using (var searcher = new IndexSearcher(GetWriter().GetReader()))
			{
				var hitsLimit = Config.MaxResults;
				var query = value.ToQuery(Analyzer);
				var hits = searcher.Search(query, hitsLimit).ScoreDocs;
				foreach (var h in hits)
				{
					var doc = searcher.Doc(h.doc);
					if (doc != null)
					{
						results.Add(doc.ToTopic());
					}
				}
			}
			return new PagedList<Topic>(results, index, Config.ResultsPageSize);
		}

		/// <summary>
		/// Updates the document fields 
		/// </summary>
		public void Update(Topic topic)
		{
			if (!Config.Enabled)
			{
				return;
			}
			var writer = GetWriter();
			Document doc = null;
			using (var searcher = new IndexSearcher(writer.GetReader()))
			{
				doc = searcher.SearchById(topic.Id);
			}
			if (doc == null)
			{
				return;
			}

			doc.GetDescriptionField().SetValue(topic.Description);
			doc.GetTitleField().SetValue(topic.Title);
			doc.GetTagsField().SetValue(topic.Tags.ToString());
			writer.Update(topic.Id, doc, Analyzer, Config);
			writer.Commit();
		}
	}
}
