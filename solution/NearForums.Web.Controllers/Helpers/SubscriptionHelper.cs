using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Services;
using NearForums.Configuration;
using NearForums.Web.State;

namespace NearForums.Web.Controllers.Helpers
{
	public static class SubscriptionHelper
	{
		public static void SendNotifications(BaseController controller, Topic topic, SiteConfiguration config, ITopicsSubscriptionsService service)
		{
			if (!config.Notifications.Subscription.IsDefined)
			{
				return;
			}
			string threadUrl = controller.Domain + controller.Url.RouteUrl(new
			{
				controller = "Topics",
				action = "ShortUrl",
				id = topic.Id
			});
			//Build a generic url that can be replaced with the real values
			string unsubscribeUrl = controller.Domain + controller.Url.RouteUrl(new
			{
				controller = "TopicsSubscriptions",
				action = "Unsubscribe",
				uid = Int32.MaxValue,
				tid = topic.Id,
				guid = Int64.MaxValue.ToString()
			});
			unsubscribeUrl = unsubscribeUrl.Replace(Int32.MaxValue.ToString(), "{0}");
			unsubscribeUrl = unsubscribeUrl.Replace(Int64.MaxValue.ToString(), "{1}");
			service.SendNotifications(topic, controller.User.Id, threadUrl, unsubscribeUrl);
		}

		/// <summary>
		/// Subscribes or unsubscribes a user to a topic
		/// </summary>
		public static void Manage(bool subscribe, int topicId, int userId, Guid userGuid, SiteConfiguration config, ITopicsSubscriptionsService service)
		{
			if (!config.Notifications.Subscription.IsDefined)
			{
				return;
			}
			if (subscribe)
			{
				service.Add(topicId, userId);
			}
			else
			{
				service.Remove(topicId, userId, userGuid);
			}
		}

		/// <summary>
		/// Ensure that an email is set if the user wants notifications.
		/// </summary>
		/// <param name="email"></param>
		/// <param name="session"></param>
		/// <exception cref="ValidationException"></exception>
		public static void SetNotificationEmail(bool notify, string email, SessionWrapper session, SiteConfiguration config, IUsersService service)
		{
			if (notify && config.Notifications.Subscription.IsDefined)
			{
				if (session.User.Email == null)
				{
					service.AddEmail(session.User.Id, email, EmailPolicy.SendFromSubscriptions);
					session.User.Email = email;
				}
			}
		}

		/// <summary>
		/// Determines if a user is subscribed to a topic
		/// </summary>
		/// <param name="topicId"></param>
		/// <param name="userId"></param>
		/// <param name="config"></param>
		public static bool IsUserSubscribed(int topicId, int userId, SiteConfiguration config, ITopicsSubscriptionsService service)
		{
			if (!config.Notifications.Subscription.IsDefined)
			{
				return false;
			}
			var usersSubscribed = service.GetSubscribed(topicId);
			return usersSubscribed.Any(x => x.Id == userId);
		}
	}
}
