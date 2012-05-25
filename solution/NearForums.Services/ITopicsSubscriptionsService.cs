using System;
using System.Collections.Generic;
namespace NearForums.Services
{
	public interface ITopicsSubscriptionsService
	{
		/// <summary>
		/// Subscribes a user to a topic. If the user is already subscribed it does nothing.
		/// </summary>
		void Add(int topicId, int userId);
		/// <summary>
		/// Gets users subscribed to a topic
		/// </summary>
		List<User> GetSubscribed(int topicId);
		/// <summary>
		/// Gets the topics to which the user subscribed to
		/// </summary>
		List<Topic> GetTopics(int userId);
		/// <summary>
		/// Unsubscribes a user to a topic. If the user is not subscribed it does nothing. Returns the records affected.
		/// </summary>
		/// <param name="userGuid">User global uid</param>
		int Remove(int topicId, int userId, Guid userGuid);
		/// <summary>
		/// Gets all users subscribed to a topic and sends a notification to each.
		/// </summary>
		/// <param name="topic"></param>
		/// <param name="userId"></param>
		/// <param name="url"></param>
		/// <param name="unsubscribeUrl"></param>
		void SendNotifications(Topic topic, int userId, string url, string unsubscribeUrl);
	}
}
