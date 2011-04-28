using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Mail;
using NearForums.Configuration;
using NearForums;
using System.Configuration;

namespace NearForums.ServiceClient
{
	public class NotificationsServiceClient
	{
		public static void SendResetPassword(User user, string url)
		{
			if (!SiteConfiguration.Current.Notifications.MembershipPasswordReset.IsDefined)
			{
				throw new ConfigurationErrorsException("Notifications/MembershipPasswordReset configuration element is not defined");
			}
			if (user.Guid == Guid.Empty)
			{
				throw new ArgumentException("User.Guid cannot be empty.");
			}
			string body = SiteConfiguration.Current.Notifications.MembershipPasswordReset.Body.ToString();

			MailMessage message = new MailMessage();
			message.To.Add(new MailAddress(user.Email, user.UserName));
			message.IsBodyHtml = true;
			#region Replace body values
			body = Utils.ReplaceBodyValues(body, user, new[] { "UserName" });
			body = Utils.ReplaceBodyValues(body, new Dictionary<string, string>() {{ "url", url } });
			#endregion
			message.Body = body;
			message.Subject = "Reset Password";

			SendMail(message);
		}

		#region Subscriptions
		/// <summary>
		/// Sync Sends a notification to every user subscribed to a topic, except the one provided in the userId
		/// </summary>
		/// <param name="topic"></param>
		/// <param name="userId">userId of the last poster</param>
		public static int SendToUsersSubscribed(Topic topic, List<User> users, string body, string url, string unsubscribeUrl, bool handleExceptions)
		{
			int sentMailsCount = 0;

			foreach (User u in users)
			{
				if ((u.EmailPolicy & EmailPolicy.SendFromSubscriptions) > 0)
				{
					try
					{
						SendEmailToSubscriptor(topic, u, body, url, unsubscribeUrl);
						sentMailsCount++;
					}
					catch (Exception ex)
					{
						if (handleExceptions)
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

		/// <summary>
		/// Prepares the body (by replacing the param values) and sends an email to the user subscribed to a topic
		/// </summary>
		/// <param name="body">Base body of the email.</param>
		private static void SendEmailToSubscriptor(Topic topic, User user, string body, string url, string unsubscribeUrl)
		{
			if (user.Guid == Guid.Empty)
			{
				throw new ArgumentException("User.Guid cannot be empty.");
			}
			unsubscribeUrl = String.Format(unsubscribeUrl, user.Id, user.Guid.ToString("N"));
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

			SendMail(message);
		}
		#endregion

		/// <summary>
		/// Sends an email based on the application configuration.
		/// Use configuration/system.net/mailSettings element to set the smtp parameters (method/host/port/etc).
		/// </summary>
		public static void SendMail(MailMessage message)
		{
			SmtpClient client = new SmtpClient();
			client.Send(message);
		}
	}
}
