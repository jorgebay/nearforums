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

namespace NearForums.Services
{
	public class SearchService : ISearchService
	{
		private static object writerLock = new object();

		public List<SearchResult> Search(string query)
		{
			throw new NotImplementedException();
		}

		public void IndexTopic(Topic topic)
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
		/// Gets the IndexWriter with the default options
		/// </summary>
		/// <returns></returns>
		private IndexWriter GetWriter()
		{
			var indexPath = SiteConfiguration.Current.Search.IndexPath;
			//TODO: Make sure that the directory exist / create if not
			var directory = FSDirectory.Open(new DirectoryInfo(indexPath));

			var writer = new IndexWriter(directory, new StandardAnalyzer(Lucene.Net.Util.Version.LUCENE_29), false, IndexWriter.MaxFieldLength.UNLIMITED);

			return writer;
		}
	}
}
