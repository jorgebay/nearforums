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
		private readonly ITopicsDataAccess _dataAccess;
		/// <summary>
		/// Messages repository
		/// </summary>
		private readonly IMessagesDataAccess _messagesDataAccess;
		/// <summary>
		/// Search index service
		/// </summary>
		private readonly ISearchService _searchIndex;

		public TopicsService(ITopicsDataAccess da, IMessagesDataAccess messagesDa, ISearchService searchIndex)
		{
			_dataAccess = da;
			_messagesDataAccess = messagesDa;
			_searchIndex = searchIndex;
		}

		public List<Topic> GetByForum(int forumId, int startIndex, int length, UserRole? role)
		{
			return _dataAccess.GetByForum(forumId, startIndex, length, role);
		}

		public List<Topic> GetByTag(string tag, int forumId, UserRole? role)
		{
			return _dataAccess.GetByTag(tag, forumId, role);
		}

		public Topic Get(int topicId)
		{
			return _dataAccess.Get(topicId);
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
			topic.Related = _dataAccess.GetRelatedTopics(topic, amount);
		}

		public void Create(Topic topic, string ip)
		{
			topic.ValidateFields();
			_dataAccess.Add(topic, ip);
			_searchIndex.Add(topic);
		}

		public void Edit(Topic topic, string ip)
		{
			topic.ValidateFields();
			_dataAccess.Edit(topic, ip);
			_searchIndex.Update(topic);
		}

		public void AddVisit(int topicId)
		{
			Action<int> handler = new Action<int>(AddVisitSync);
			handler.BeginInvoke(topicId, null, null);
		}

		private void AddVisitSync(int topicId)
		{
			_dataAccess.AddVisit(topicId);
		}

		public List<Topic> GetLatest(int forumId, int startIndex, int length, UserRole? role)
		{
			return _dataAccess.GetByForumLatest(forumId, startIndex, length, role);
		}

		public List<Topic> GetLatest()
		{
			return _dataAccess.GetLatest();
		}

		public Topic Move(int id, int forumId, int userId, string ip)
		{
			_dataAccess.Move(id, forumId, userId, ip);
			return _dataAccess.Get(id);
		}

		public void Close(int id, int userId, string ip)
		{
			_dataAccess.Close(id, userId, ip);
		}

		public void Open(int id, int userId, string ip)
		{
			_dataAccess.Open(id, userId, ip);
		}

		public List<Topic> GetUnanswered(int forumId, UserRole? role)
		{
			return _dataAccess.GetUnanswered(forumId, role);
		}

		public List<Topic> GetUnanswered()
		{
			return _dataAccess.GetUnanswered();
		}

		public void Delete(int id, int userId, string ip)
		{
			_dataAccess.Delete(id, userId, ip);
		}

		public List<Topic> GetByUser(int userId, UserRole? role)
		{
			return _dataAccess.GetByUser(userId, role);
		}

		public List<Topic> GetTopicsAndMessagesByUser(int userId)
		{
			return _dataAccess.GetTopicsAndMessagesByUser(userId);
		}

		public Topic GetMessagesFrom(int topicId, int firstMsg, int amount, int initIndex)
		{
			var topic = Get(topicId);
			if (topic != null)
			{
				topic.Messages = _messagesDataAccess.GetByTopicFrom(topicId, firstMsg, amount, initIndex);
			}
			return topic;
		}

		public Topic GetMessages(int topicId, int firstMsg, int lastMsg, int initIndex)
		{
			var topic = Get(topicId);
			if (topic != null)
			{
				topic.Messages = _messagesDataAccess.GetByTopic(topicId, firstMsg, lastMsg, initIndex);
			}
			return topic;
		}
	}
}
