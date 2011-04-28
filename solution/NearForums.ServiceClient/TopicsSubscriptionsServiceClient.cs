using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;
using System.Net.Mail;
using NearForums.Configuration;
using System.Configuration;

namespace NearForums.ServiceClient
{
	public static class TopicsSubscriptionsServiceClient
	{
		/// <summary>
		/// Subscribes a user to a topic. If the user is already subscribed it does nothing.
		/// </summary>
		public static void Add(int topicId, int userId)
		{
			TopicsSubscriptionsDataAccess da = new TopicsSubscriptionsDataAccess();
			da.Add(topicId, userId);
		}

		/// <summary>
		/// Unsubscribes a user to a topic. If the user is not subscribed it does nothing. Returns the records affected.
		/// </summary>
		/// <param name="userGuid">User global uid</param>
		public static int Remove(int topicId, int userId, Guid userGuid)
		{
			TopicsSubscriptionsDataAccess da = new TopicsSubscriptionsDataAccess();
			return da.Remove(topicId, userId, userGuid);
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

		public static void SendNotifications(Topic topic, int userId, string url, string unsubscribeUrl)
		{
			if (SiteConfiguration.Current.Notifications != null && SiteConfiguration.Current.Notifications.Subscription != null)
			{
				string body = SiteConfiguration.Current.Notifications.Subscription.Body.ToString();
				SendNotificationsHandler handler = new SendNotificationsHandler(NotificationsServiceClient.SendToUsersSubscribed);
				var users = GetSubscribed(topic.Id);
				users.RemoveAll(x => x.Id == userId || String.IsNullOrEmpty(x.Email));

				handler.BeginInvoke(topic, users, body, url, unsubscribeUrl, true, null, null);
			}
		}
	}

	public delegate int SendNotificationsHandler(Topic topic, List<User> users, string body, string url, string unsubscribeUrl, bool handleExceptions);
}
