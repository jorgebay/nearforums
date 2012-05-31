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

namespace NearForums.Services
{
	public class SearchService : ISearchService
	{
		private static object writerLock = new object();
		private static FSDirectory Directory
		{
			get
			{
				//TODO: Make sure that the directory exist / create if not
				return FSDirectory.Open(new DirectoryInfo(SiteConfiguration.Current.Search.IndexPath));
			}
		}

		public List<SearchResult> Search(string value)
		{
			var results = new List<SearchResult>();
			if (String.IsNullOrWhiteSpace(value))
			{
				throw new ArgumentException("query can not be null, empty or only whitespace chars.");
			}
			using (var searcher = new IndexSearcher(Directory, false))
			{
				var hitsLimit = 1000; //TODO: Move to config
				var query = value.ToQuery();
				var docs = searcher.Search(query, hitsLimit).ScoreDocs;

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
			
			var writer = new IndexWriter(Directory, new StandardAnalyzer(Lucene.Net.Util.Version.LUCENE_29), false, IndexWriter.MaxFieldLength.UNLIMITED);

			return writer;
		}
	}
}
