using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;

namespace NearForums.Services
{
	public class TopicsService : ITopicsService
	{
		/// <summary>
		/// Topics repository
		/// </summary>
		private readonly ITopicsDataAccess dataAccess;
		/// <summary>
		/// Messages repository
		/// </summary>
		private readonly IMessagesDataAccess messagesDataAccess;

		public TopicsService(ITopicsDataAccess da, IMessagesDataAccess messagesDa)
		{
			dataAccess = da;
			messagesDataAccess = messagesDa;
		}

		public List<Topic> GetByForum(int forumId, int startIndex, int length, UserRole? role)
		{
			return dataAccess.GetByForum(forumId, startIndex, length, role);
		}

		public List<Topic> GetByTag(string tag, int forumId, UserRole? role)
		{
			return dataAccess.GetByTag(tag, forumId, role);
		}

		public Topic Get(int topicId)
		{
			return dataAccess.Get(topicId);
		}

		public Topic Get(int id, string shortName)
		{
			var topic = Get(id);
			if (topic != null && topic.ShortName.ToUpper() != shortName.ToUpper())
			{
				topic = null;
			}
			return topic;
		}

		public void LoadRelatedTopics(Topic topic, int amount)
		{
			topic.Related = dataAccess.GetRelatedTopics(topic, amount);
		}

		public void Create(Topic topic, string ip)
		{
			topic.ValidateFields();
			dataAccess.Add(topic, ip);
		}

		public void Edit(Topic topic, string ip)
		{
			topic.ValidateFields();
			dataAccess.Edit(topic, ip);
		}

		public void AddVisit(int topicId)
		{
			Action<int> handler = new Action<int>(AddVisitSync);
			handler.BeginInvoke(topicId, null, null);
		}

		private void AddVisitSync(int topicId)
		{
			dataAccess.AddVisit(topicId);
		}

		public List<Topic> GetLatest(int forumId, int startIndex, int length, UserRole? role)
		{
			return dataAccess.GetByForumLatest(forumId, startIndex, length, role);
		}

		public List<Topic> GetLatest()
		{
			return dataAccess.GetLatest();
		}

		public Topic Move(int id, int forumId, int userId, string ip)
		{
			dataAccess.Move(id, forumId, userId, ip);
			return dataAccess.Get(id);
		}

		public void Close(int id, int userId, string ip)
		{
			dataAccess.Close(id, userId, ip);
		}

		public void Open(int id, int userId, string ip)
		{
			dataAccess.Open(id, userId, ip);
		}

		public List<Topic> GetUnanswered(int forumId, UserRole? role)
		{
			return dataAccess.GetUnanswered(forumId, role);
		}

		public List<Topic> GetUnanswered()
		{
			return dataAccess.GetUnanswered();
		}

		public void Delete(int id, int userId, string ip)
		{
			dataAccess.Delete(id, userId, ip);
		}

		public List<Topic> GetByUser(int userId, UserRole? role)
		{
			return dataAccess.GetByUser(userId, role);
		}

		public List<Topic> GetTopicsAndMessagesByUser(int userId)
		{
			return dataAccess.GetTopicsAndMessagesByUser(userId);
		}

		public Topic GetMessagesFrom(int topicId, int firstMsg, int amount, int initIndex)
		{
			var topic = Get(topicId);
			if (topic != null)
			{
				topic.Messages = messagesDataAccess.GetByTopicFrom(topicId, firstMsg, amount, initIndex);
			}
			return topic;
		}

		public Topic GetMessages(int topicId, int firstMsg, int lastMsg, int initIndex)
		{
			var topic = Get(topicId);
			if (topic != null)
			{
				topic.Messages = messagesDataAccess.GetByTopic(topicId, firstMsg, lastMsg, initIndex);
			}
			return topic;
		}
	}
}
