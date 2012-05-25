using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums.DataAccess
{
	public interface IMessagesDataAccess
	{
		void Add(Message message, string ip);
		bool ClearFlags(int topicId, int messageId);
		void Delete(int topicId, int messageId, int userId);
		bool Flag(int topicId, int messageId, string ip);
		List<NearForums.Message> GetByTopic(int topicId);
		List<NearForums.Message> GetByTopic(int topicId, int firstMsg, int lastMsg, int initIndex);
		List<NearForums.Message> GetByTopicFrom(int topicId, int firstMsg, int amount, int initIndex);
		List<NearForums.Message> GetByTopicLatest(int topicId);
		List<NearForums.Topic> ListFlagged();
	}
}
