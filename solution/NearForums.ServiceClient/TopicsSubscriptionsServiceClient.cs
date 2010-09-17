using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;
using System.Net.Mail;
using NearForums.Configuration;

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
		/// Unsubscribes a user to a topic. If the user is not subscribed it does nothing.
		/// </summary>
		/// <param name="topicId"></param>
		/// <param name="userId"></param>
		public static void Remove(int topicId, int userId)
		{
			TopicsSubscriptionsDataAccess da = new TopicsSubscriptionsDataAccess();
			da.Remove(topicId, userId);
		}

		/// <summary>
		/// Subscribes or unsubscribes a user to a topic
		/// </summary>
		public static void Manage(bool subscribe, int topicId, int userId)
		{
			if (subscribe)
			{
				Add(topicId, userId);
			}
			else
			{
				Remove(topicId, userId);
			}
		}

		/// <summary>
		/// Gets users subscribed to a topic
		/// </summary>
		internal static List<User> GetSubscribed(int topicId)
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
				SendNotificationsHandler handler = new SendNotificationsHandler(SendNotificationsSync);
				handler.BeginInvoke(topic, userId, body, url, unsubscribeUrl, true, null, null);
			}
		}

		/// <summary>
		/// Sync Sends a notification to every user subscribed to a topic, except the one provided in the userId
		/// </summary>
		/// <param name="topic"></param>
		/// <param name="userId">userId of the last poster</param>
		internal static int SendNotificationsSync(Topic topic, int userId, string body, string url, string unsubscribeUrl, bool handleExceptions)
		{
			int sentMailsCount = 0;
			var users = GetSubscribed(topic.Id);
			users.RemoveAll(x => x.Id == userId || String.IsNullOrEmpty(x.Email));

			foreach (User u in users)
			{
				if ((u.EmailPolicy & EmailPolicy.SendFromSubscriptions) > 0)
				{
					try
					{
						SendEmail(topic, u, body, url, unsubscribeUrl);
						sentMailsCount++;
					}
					catch (Exception ex)
					{
						if (!handleExceptions)
						{
							LoggerServiceClient.LogError(ex);
						}
						else
						{
							throw ex;
						}
					}
				}
			}
			return sentMailsCount;
		}

		private static void SendEmail(Topic topic, User user, string body, string url, string unsubscribeUrl)
		{
			MailMessage message = new MailMessage();
			message.To.Add(new MailAddress(user.Email, user.UserName));
			message.IsBodyHtml = true;
			#region Replace body values
			body = Utils.ReplaceBodyValues(body, user, new[] { "UserName"});
			body = Utils.ReplaceBodyValues(body, topic, new[] { "Title", "Id" });
			body = Utils.ReplaceBodyValues(body, new Dictionary<string, string>(){{"unsubscribeUrl", unsubscribeUrl}, {"url", url}});
			#endregion
			message.Body = body;
			message.Subject = "Re: " + topic.Title;

			SmtpClient client = new SmtpClient();
			client.Send(message);
		}
	}

	public delegate int SendNotificationsHandler(Topic topic, int userId, string body, string url, string unsubscribeUrl, bool handleExceptions);
}
