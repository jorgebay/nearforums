using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums.Services
{
	public interface ISearchService
	{
		/// <summary>
		/// Adds a message to the index
		/// </summary>
		/// <param name="topic"></param>
		void Add(Message message);

		/// <summary>
		/// Adds a topic to the index
		/// </summary>
		void Add(Topic topic);

		/// <summary>
		/// Adds a list of topics to the index
		/// </summary>
		void Add(IEnumerable<Topic> topicList);

		/// <summary>
		/// Creates or recreates the index.
		/// Delete all previous index data.
		/// </summary>
		void CreateIndex();

		/// <summary>
		/// Removes a message from the search index
		/// </summary>
		/// <param name="messageId">Identifier of the message</param>
		void DeleteMessage(int topicId, int messageId);

		/// <summary>
		/// Removes a topic from the search index
		/// </summary>
		/// <param name="id">identifier of the topic</param>
		void DeleteTopic(int id);

		/// <summary>
		/// Gets the total documents currently indexed
		/// </summary>
		int DocumentCount { get; }

		/// <summary>
		/// Queries the index
		/// </summary>
		/// <param name="index">Current page index, zero based.</param>
		PagedList<Topic> Search(string query, int index);

		/// <summary>
		/// Updates a topic from the 
		/// </summary>
		/// <param name="topic"></param>
		void Update(Topic topic);
	}
}
