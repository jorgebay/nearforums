using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;
using NearForums.Configuration;

namespace NearForums.Services
{
	public class TopicsSubscriptionsService : ITopicsSubscriptionsService
	{
		/// <summary>
		/// Topic subscriptions repository
		/// </summary>
		private readonly ITopicsSubscriptionsDataAccess _dataAccess;

		/// <summary>
		/// Service to do the notifications
		/// </summary>
		private readonly INotificationsService _notificationService;

		public TopicsSubscriptionsService(ITopicsSubscriptionsDataAccess da, INotificationsService notifications)
		{
			_dataAccess = da;
			_notificationService = notifications;
		}

		public void Add(int topicId, int userId)
		{
			_dataAccess.Add(topicId, userId);
		}

		public int Remove(int topicId, int userId, Guid userGuid)
		{
			return _dataAccess.Remove(topicId, userId, userGuid);
		}

		public List<User> GetSubscribed(int topicId)
		{
			return _dataAccess.GetUsersByTopic(topicId);
		}

		public List<Topic> GetTopics(int userId)
		{
			return _dataAccess.GetTopicsByUser(userId);
		}

		public void SendNotifications(Message message, int userId, string url, string unsubscribeUrl)
		{
			var config = SiteConfiguration.Current.Notifications.Subscription;
			if (!config.IsDefined)
			{
				return;
			}
			string body = config.Body.ToString();
			var users = GetSubscribed(message.Topic.Id);
			users.RemoveAll(x => x.Id == userId || String.IsNullOrEmpty(x.Email));

			if (config.Async)
			{
				var handler = new SendNotificationsHandler(_notificationService.SendToUsersSubscribed);
				handler.BeginInvoke(message, users, body, url, unsubscribeUrl, true, null, null);
			}
			else
			{
				_notificationService.SendToUsersSubscribed(message, users, body, url, unsubscribeUrl, false);
			}
		}
	}

	public delegate int SendNotificationsHandler(Message message, List<User> users, string body, string url, string unsubscribeUrl, bool handleExceptions);
}
