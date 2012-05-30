using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums.Services
{
	public interface ISearchService
	{
		/// <summary>
		/// Queries the index
		/// </summary>
		List<SearchResult> Search(string query);

		/// <summary>
		/// Adds a topic to the index
		/// </summary>
		void IndexTopic(Topic topic);
	}
}
