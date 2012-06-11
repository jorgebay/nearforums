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

		/// <summary>
		/// Determines if recreates the index the next time it writes
		/// </summary>
		public bool RecreateIndex { get; set; }

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
			var writer = GetWriter();
			var doc = topic.ToDocument(Config);
			writer.AddDocument(doc);
			writer.Commit();
		}

		/// <summary>
		/// Adds the message as document (topic) field
		/// </summary>
		/// <param name="topic"></param>
		public void Add(Message message)
		{
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
				throw new ArgumentException("No topic found for given id (" + message.Topic.Id +")");
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
		/// Removes the message field from the document
		/// </summary>
		public void Delete(Message message)
		{
			throw new NotImplementedException();
		}

		/// <summary>
		/// Removes the document that represents the topic
		/// </summary>
		public void Delete(Topic topic)
		{
			throw new NotImplementedException();
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
					_writer = new IndexWriter(Directory, Analyzer, RecreateIndex, IndexWriter.MaxFieldLength.UNLIMITED);
				}
			}
			return _writer;
		}

		public List<Topic> Search(string value)
		{
			var results = new List<Topic>();
			if (String.IsNullOrWhiteSpace(value))
			{
				throw new ArgumentException("query can not be null, empty or only whitespace chars.");
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
			return results;
		}

		/// <summary>
		/// Updates the document fields 
		/// </summary>
		public void Update(Topic topic)
		{
			var writer = GetWriter();
			Document doc = null;
			using (var searcher = new IndexSearcher(writer.GetReader()))
			{
				doc = searcher.SearchById(topic.Id);
			}
			if (doc == null)
			{
				throw new ArgumentException("No topic found for given id (" + topic.Id + ")");
			}

			doc.GetDescriptionField().SetValue(topic.Description);
			doc.GetTitleField().SetValue(topic.Title);
			doc.GetTagsField().SetValue(topic.Tags.ToString());
			writer.Update(topic.Id, doc, Analyzer, Config);
			writer.Commit();
		}
	}
}
