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
				return FSDirectory.Open(new DirectoryInfo(SiteConfiguration.Current.Search.IndexPath));
			}
		}

		/// <summary>
		/// Determines if recreates the index the next time it writes
		/// </summary>
		public bool RecreateIndex { get; set; }

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

		public List<Topic> Search(string value)
		{
			var results = new List<Topic>();
			if (String.IsNullOrWhiteSpace(value))
			{
				throw new ArgumentException("query can not be null, empty or only whitespace chars.");
			}
			using (var searcher = new IndexSearcher(Directory, true))
			{
				var hitsLimit = 1000; //TODO: Move to config
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
		/// Adds a new topic to the index
		/// </summary>
		/// <param name="topic"></param>
		public void Add(Topic topic)
		{
			lock (writerLock)
			{
				using (var writer = GetWriter())
				{
					var doc = topic.ToDocument();
					writer.AddDocument(doc);
				}
			}
		}

		/// <summary>
		/// Adds the message as document (topic) field
		/// </summary>
		/// <param name="topic"></param>
		public void Add(Message topic)
		{
			lock (writerLock)
			{
				using (var writer = GetWriter())
				{
					var document = new Document();
				}
			}
		}

		/// <summary>
		/// Updates the document fields 
		/// </summary>
		public void Update(Topic topic)
		{

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
	}
}
