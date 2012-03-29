using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;

namespace NearForums.Services
{
	public class MessagesService : IMessagesService
	{
		/// <summary>
		/// messages repository
		/// </summary>
		private readonly IMessagesDataAccess dataAccess;

		public MessagesService(IMessagesDataAccess da)
		{
			dataAccess = da;
		}

		public  List<Message> GetByTopic(int topicId)
		{
			return dataAccess.GetByTopic(topicId); 
		}

		public  List<Message> GetByTopicLatest(int topicId)
		{
			return dataAccess.GetByTopicLatest(topicId);
		}

		/// <summary>
		/// Gets a list of messages from firstMsg to lastMsg
		/// </summary>
		public List<Message> GetByTopic(int topicId, int firstMsg, int lastMsg, int initIndex)
		{
			return dataAccess.GetByTopic(topicId, firstMsg, lastMsg, initIndex);
		}

		/// <summary>
		/// Gets an specific amount of messages starting from firstMsg
		/// </summary>
		/// <returns></returns>
		public List<Message> GetByTopicFrom(int topicId, int firstMsg, int amount, int initIndex)
		{
			return dataAccess.GetByTopicFrom(topicId, firstMsg, amount, initIndex);
		}

		public  void Add(Message message, string ip)
		{
			message.ValidateFields();
			dataAccess.Add(message, ip);
		}

		public  void Delete(int topicId, int messageId, int userId)
		{
			dataAccess.Delete(topicId, messageId, userId);
		}

		public  bool Flag(int topicId, int messageId, string ip)
		{
			return dataAccess.Flag(topicId, messageId, ip);
		}

		public  List<Topic> ListFlagged()
		{
			return dataAccess.ListFlagged();
		}

		public  bool ClearFlags(int topicId, int messageId)
		{
			return dataAccess.ClearFlags(topicId, messageId);
		}
	}
}
