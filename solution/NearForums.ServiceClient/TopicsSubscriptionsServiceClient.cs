using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;

namespace NearForums.ServiceClient
{
	public static class TopicsSubscriptionsServiceClient
	{
		public static void Add(int topicId, int userId)
		{
			TopicsSubscriptionsDataAccess da = new TopicsSubscriptionsDataAccess();
			da.Add(topicId, userId);
		}

		public static void Remove(int topicId, int userId)
		{
			TopicsSubscriptionsDataAccess da = new TopicsSubscriptionsDataAccess();
			da.Remove(topicId, userId);
		}

		/// <summary>
		/// Gets users subscribed to a topic
		/// </summary>
		public static List<User> GetSubscribed(int topicId)
		{
			TopicsSubscriptionsDataAccess da = new TopicsSubscriptionsDataAccess();
			return da.GetUsersByTopic(topicId);
		}

		/// <summary>
		/// Gets the topics to which the user subscribed to
		/// </summary>
		public static List<Topic> GetTopics(int userId)
		{
			TopicsSubscriptionsDataAccess da = new TopicsSubscriptionsDataAccess();
			return da.GetTopicsByUser(userId);
		}
	}
}
