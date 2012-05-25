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
		bool ClearFlags(int topicId, int messageId);
		void Delete(int topicId, int messageId, int userId);
		/// <summary>
		/// Flags / Creates a mark on a message of a topic. The ip of flagger is stored.
		/// </summary>
		/// <param name="ip">Ip of the user creating the flag</param>
		bool Flag(int topicId, int messageId, string ip);
		List<Message> GetByTopic(int topicId);
		/// <summary>
		/// Gets top latest message of a topic
		/// </summary>
		List<Message> GetByTopicLatest(int topicId);
		/// <summary>
		/// Gets a list of flagged messages grouped by topic
		/// </summary>
		List<Topic> ListFlagged();
		/// <summary>
		/// Gets a list of messages from firstMsg to lastMsg
		/// </summary>
		List<Message> GetByTopic(int topicId, int firstMsg, int lastMsg, int initIndex);

		/// <summary>
		/// Gets an specific amount of messages starting from firstMsg
		/// </summary>
		/// <returns></returns>
		List<Message> GetByTopicFrom(int topicId, int firstMsg, int amount, int initIndex);
	}
}
