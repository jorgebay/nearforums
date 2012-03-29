﻿using System;
using System.Collections.Generic;
using System.Net.Mail;

namespace NearForums.Services
{
	public interface INotificationsService
	{
		void SendMail(MailMessage message);
		/// <summary>
		/// Sends the mail to reset the password to a user
		/// </summary>
		/// <param name="user"></param>
		/// <param name="url"></param>
		void SendResetPassword(User user, string url);
		/// <summary>
		/// Sync Sends a notification to every user subscribed to a topic
		/// </summary>
		/// <param name="topic"></param>
		/// <param name="userId">userId of the last poster</param>
		int SendToUsersSubscribed(Topic topic, List<User> users, string body, string url, string unsubscribeUrl, bool handleExceptions);
	}
}
