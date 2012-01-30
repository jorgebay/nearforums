using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;

namespace NearForums.ServiceClient
{
	public static class TopicsServiceClient
	{
		/// <summary>
		/// Gets a list of topics of a forum ordered by views
		/// </summary>
		public static List<Topic> GetByForum(int forumId, int startIndex, int length)
		{
			TopicsDataAccess da = new TopicsDataAccess();
			return da.GetByForum(forumId, startIndex, length);
		}

		/// <summary>
		/// Gets the topics tagged in a certain forum
		/// </summary>
		/// <returns></returns>
		public static List<Topic> GetByTag(string tag, int forumId)
		{
			TopicsDataAccess da = new TopicsDataAccess();
			return da.GetByTag(tag, forumId);
		}

		/// <summary>
		/// Gets a topic by id
		/// </summary>
		/// <param name="topicId"></param>
		/// <returns></returns>
		public static Topic Get(int topicId)
		{
			var da = new TopicsDataAccess();
			return da.Get(topicId);
		}
		
		/// <summary>
		/// Gets a topic by id, validating that the shortName matches
		/// </summary>
		public static Topic Get(int id, string shortName)
		{
			var topic = Get(id);
			if (topic != null && topic.ShortName.ToUpper() != shortName.ToUpper())
			{
				topic = null;
			}
			return topic;
		}

		public static void LoadRelatedTopics(Topic topic, int amount)
		{
			TopicsDataAccess da = new TopicsDataAccess();
			topic.Related = da.GetRelatedTopics(topic, amount);
		}

		/// <summary>
		/// Adds a new message to the topic
		/// </summary>
		/// <exception cref="ValidationException">If the model is not valid</exception>
		public static void AddReply(Message message, string ip)
		{
			message.ValidateFields();
			MessagesServiceClient.Add(message, ip);
		}

		/// <exception cref="ValidationException"></exception>
		public static void Create(Topic topic, string ip)
		{
			topic.ValidateFields();
			TopicsDataAccess da = new TopicsDataAccess();
			da.Add(topic, ip);
		}

		/// <summary>
		/// Edits a topic
		/// </summary>
		/// <exception cref="ValidationException"></exception>
		public static void Edit(Topic topic, string ip)
		{
			topic.ValidateFields();
			TopicsDataAccess da = new TopicsDataAccess();
			da.Edit(topic, ip);
		}

		public static void AddVisit(int topicId)
		{
			Action<int> handler = new Action<int>(AddVisitSync);
			handler.BeginInvoke(topicId, null, null);
		}

		private static void AddVisitSync(int topicId)
		{
			TopicsDataAccess da = new TopicsDataAccess();
			da.AddVisit(topicId);
		}

		public static List<Topic> GetLatest(int forumId, int startIndex, int length)
		{
			TopicsDataAccess da = new TopicsDataAccess();
			return da.GetByForumLatest(forumId, startIndex, length);
		}

		public static List<Topic> GetLatest()
		{
			TopicsDataAccess da = new TopicsDataAccess();
			return da.GetLatest();
		}

		/// <summary>
		/// Moves a topic from a forum to another.
		/// </summary>
		public static Topic Move(int id, int forumId, int userId, string ip)
		{
			TopicsDataAccess da = new TopicsDataAccess();
			da.Move(id, forumId, userId, ip);
			return da.Get(id);
		}

		/// <summary>
		/// Closes a topic to disallow further replies.
		/// </summary>
		public static void Close(int id, int userId, string ip)
		{
			TopicsDataAccess da = new TopicsDataAccess();
			da.Close(id, userId, ip);
		}

		/// <summary>
		/// Opens a topic to allow replies.
		/// </summary>
		public static void Open(int id, int userId, string ip)
		{
			TopicsDataAccess da = new TopicsDataAccess();
			da.Open(id, userId, ip);
		}

		/// <summary>
		/// Gets a list of unanswered topics
		/// </summary>
		/// <param name="p"></param>
		/// <returns></returns>
		public static List<Topic> GetUnanswered(int forumId)
		{
			TopicsDataAccess da = new TopicsDataAccess();
			return da.GetUnanswered(forumId);
		}

		/// <summary>
		/// Gets a list of unanswered topics from all forums
		/// </summary>
		/// <returns></returns>
		public static List<Topic> GetUnanswered()
		{
			TopicsDataAccess da = new TopicsDataAccess();
			return da.GetUnanswered();
		}

		/// <summary>
		/// Deletes (inactive) a user from the application
		/// </summary>
		public static void Delete(int id, int userId, string ip)
		{
			TopicsDataAccess da = new TopicsDataAccess();
			da.Delete(id, userId, ip);
		}

		/// <summary>
		/// Gets a list of topics posted by the user
		/// </summary>
		public static List<Topic> GetByUser(int userId)
		{
			TopicsDataAccess da = new TopicsDataAccess();
			return da.GetByUser(userId);
		}

		/// <summary>
		/// Gets a list of topics with the messages posted by the user
		/// </summary>
		public static List<Topic> GetTopicsAndMessagesByUser(int userId)
		{
			var da = new TopicsDataAccess();
			return da.GetTopicsAndMessagesByUser(userId);
		}

		/// <summary>
		/// Get a topic containing an specific amount of messages starting from firstMsg
		/// </summary>
		public static Topic GetMessagesFrom(int topicId, int firstMsg, int amount, int initIndex)
		{
			var topic = Get(topicId);
			if (topic != null)
			{
				topic.Messages = MessagesServiceClient.GetByTopicFrom(topicId, firstMsg, amount, initIndex);
			}
			return topic;
		}
		
		/// <summary>
		/// Gets a topic containing messages from firstMsg to lastMsg
		/// </summary>
		public static Topic GetMessages(int topicId, int firstMsg, int lastMsg, int initIndex)
		{
			var topic = Get(topicId);
			if (topic != null)
			{
				topic.Messages = MessagesServiceClient.GetByTopic(topicId, firstMsg, lastMsg, initIndex);
			}
			return topic;
		}
	}
}
