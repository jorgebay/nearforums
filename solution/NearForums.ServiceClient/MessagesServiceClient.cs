using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;

namespace NearForums.ServiceClient
{
	public static class MessagesServiceClient
	{
		public static List<Message> GetByTopic(int topicId)
		{
			MessagesDataAccess da = new MessagesDataAccess();
			return da.GetByTopic(topicId); 
		}

		/// <summary>
		/// Gets top latest message of a topic
		/// </summary>
		public static List<Message> GetByTopicLatest(int topicId)
		{
			MessagesDataAccess da = new MessagesDataAccess();
			return da.GetByTopicLatest(topicId);
		}

		public static List<Message> GetByTopic(int topicId, int firstMsg, int lastMsg, int initIndex)
		{
			MessagesDataAccess da = new MessagesDataAccess();
			return da.GetByTopic(topicId, firstMsg, lastMsg, initIndex);
		}

		public static List<Message> GetByTopicFrom(int topicId, int firstMsg, int amount, int initIndex)
		{
			MessagesDataAccess da = new MessagesDataAccess();
			return da.GetByTopicFrom(topicId, firstMsg, amount, initIndex);
		}

		internal static void Add(Message message, string ip)
		{
			MessagesDataAccess da = new MessagesDataAccess();
			da.Add(message, ip);
		}

		public static void Delete(int messageId, int userId)
		{
			MessagesDataAccess da = new MessagesDataAccess();
			da.Delete(messageId, userId);
		}
	}
}
