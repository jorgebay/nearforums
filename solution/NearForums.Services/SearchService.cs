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
		private static object writerLock = new object();

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
			lock (writerLock)
			{
				using (var writer = GetWriter())
				{
					var doc = topic.ToDocument(Config);
					writer.AddDocument(doc);
				}
			}
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
			lock (writerLock)
			{
				using (var writer = GetWriter())
				{
					Document doc = null;
					using (var searcher = new IndexSearcher(writer.GetReader()))
					{
						doc = searcher.SearchById(message.Topic.Id);
					}
					if (doc == null)
					{
						throw new ArgumentException("No topic found for given id (" + message.Topic.Id +")");
					}
					var dateField = doc.GetField(SearchHelper.Date);
					dateField.SetValue(DateTools.DateToString(message.Date, DateTools.Resolution.MINUTE));
					doc.RemoveField(SearchHelper.Date);
					doc.Add(dateField);
					doc.Add(message.ToField());
					writer.Update(message.Topic.Id, doc, Analyzer);
					writer.Commit();
				}
			}
		}

		/// <summary>
		/// Gets an instance of the IndexWriter with the default options
		/// </summary>
		private IndexWriter GetWriter()
		{
			var path = new DirectoryInfo(SiteConfiguration.Current.Search.IndexPath);
			var writer = new IndexWriter(Directory, Analyzer, RecreateIndex, IndexWriter.MaxFieldLength.UNLIMITED);

			return writer;
		}

		public List<Topic> Search(string value)
		{
			var results = new List<Topic>();
			if (String.IsNullOrWhiteSpace(value))
			{
				throw new ArgumentException("query can not be null, empty or only whitespace chars.");
			}
			using (var searcher = new IndexSearcher(Directory, true))
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
			throw new NotImplementedException();
		}
	}
}
