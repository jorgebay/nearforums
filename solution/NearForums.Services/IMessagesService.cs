using System;
using System.Collections.Generic;
namespace NearForums.Services
{
	public interface IMessagesService
	{
		/// <summary>
		/// Adds a new message to the topic
		/// </summary>
		/// <exception cref="ValidationException">If the model is not valid</exception>
		void Add(Message message, string ip);
		/// <summary>
		/// Removes the flags/marks on a message
		/// </summary>
		/// <param name="topicId"></param>
		/// <param name="messageId"></param>
		/// <returns></returns>
		bool ClearFlags(int topicId, int messageId);
		/// <summary>
		/// Deletes/Hides a message
		/// </summary>
		/// <param name="topicId"></param>
		/// <param name="messageId"></param>
		/// <param name="userId">identifier of the user deleting the message</param>
		void Delete(int topicId, int messageId, int userId);
		/// <summary>
		/// Flags / Creates a mark on a message of a topic. The ip of flagger is stored.
		/// </summary>
		/// <param name="ip">Ip of the user creating the flag</param>
		bool Flag(int topicId, int messageId, string ip);
		/// <summary>
		/// Gets a list of flagged messages grouped by topic
		/// </summary>
		List<Topic> ListFlagged();
	}
}
