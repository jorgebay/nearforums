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
		private readonly IMessagesDataAccess _dataAccess;
		/// <summary>
		/// Search index service
		/// </summary>
		private readonly ISearchService _searchIndex;

		public MessagesService(IMessagesDataAccess da, ISearchService searchIndex)
		{
			_dataAccess = da;
			_searchIndex = searchIndex;
		}

		public  List<Message> GetByTopic(int topicId)
		{
			return _dataAccess.GetByTopic(topicId); 
		}

		public  List<Message> GetByTopicLatest(int topicId)
		{
			return _dataAccess.GetByTopicLatest(topicId);
		}

		/// <summary>
		/// Gets a list of messages from firstMsg to lastMsg
		/// </summary>
		public List<Message> GetByTopic(int topicId, int firstMsg, int lastMsg, int initIndex)
		{
			return _dataAccess.GetByTopic(topicId, firstMsg, lastMsg, initIndex);
		}

		/// <summary>
		/// Gets an specific amount of messages starting from firstMsg
		/// </summary>
		/// <returns></returns>
		public List<Message> GetByTopicFrom(int topicId, int firstMsg, int amount, int initIndex)
		{
			return _dataAccess.GetByTopicFrom(topicId, firstMsg, amount, initIndex);
		}

		public  void Add(Message message, string ip)
		{
			message.ValidateFields();
			_dataAccess.Add(message, ip);
			_searchIndex.Add(message);
		}

		public  void Delete(int topicId, int messageId, int userId)
		{
			_dataAccess.Delete(topicId, messageId, userId);
		}

		public  bool Flag(int topicId, int messageId, string ip)
		{
			return _dataAccess.Flag(topicId, messageId, ip);
		}

		public  List<Topic> ListFlagged()
		{
			return _dataAccess.ListFlagged();
		}

		public  bool ClearFlags(int topicId, int messageId)
		{
			return _dataAccess.ClearFlags(topicId, messageId);
		}
	}
}
