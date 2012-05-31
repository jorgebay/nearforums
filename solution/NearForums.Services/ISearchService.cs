using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums.Services
{
	public interface ISearchService
	{
		/// <summary>
		/// Determines if recreates the index the next time it writes
		/// </summary>
		bool RecreateIndex { get; set; }
		/// <summary>
		/// Queries the index
		/// </summary>
		List<Topic> Search(string query);

		/// <summary>
		/// Adds a topic to the index
		/// </summary>
		void Add(Topic topic);

		/// <summary>
		/// Adds a message to the index
		/// </summary>
		/// <param name="topic"></param>
		void Add(Message message);

		/// <summary>
		/// Updates a topic from the 
		/// </summary>
		/// <param name="topic"></param>
		void Update(Topic topic);
	}
}
