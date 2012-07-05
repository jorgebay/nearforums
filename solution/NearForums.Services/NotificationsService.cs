using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.Configuration;
using System.Net.Mail;
using System.Configuration;

namespace NearForums.Services
{
	public class NotificationsService : INotificationsService
	{
		/// <summary>
		/// Service that handles the logging
		/// </summary>
		private readonly ILoggerService _loggerService;

		public NotificationsService(ILoggerService logger)
		{
			_loggerService = logger;
		}

		public void SendResetPassword(User user, string url)
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
			body = Utils.ReplaceBodyValues(body, SiteConfiguration.Current.AuthenticationProviders.FormsAuth, new[] { "TimeToExpireResetPasswordLink" });
			body = Utils.ReplaceBodyValues(body, new Dictionary<string, string>() { { "url", url } });
			#endregion
			message.Body = body;
			message.Subject = "Reset Password";

			SendMail(message);
		}

		public int SendToUsersSubscribed(Message topicMessage, List<User> users, string body, string url, string unsubscribeUrl, bool handleExceptions)
		{
			int sentMailsCount = 0;

			foreach (User u in users)
			{
				if ((u.EmailPolicy & EmailPolicy.SendFromSubscriptions) > 0)
				{
					try
					{
						SendEmailToSubscriptor(topicMessage, u, body, url, unsubscribeUrl);
						sentMailsCount++;
					}
					catch (Exception ex)
					{
						if (handleExceptions)
						{
							_loggerService.LogError(ex);
						}
						else
						{
							throw;
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
		private void SendEmailToSubscriptor(Message topicMessage, User user, string body, string url, string unsubscribeUrl)
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
			body = Utils.ReplaceBodyValues(body, user, new[] { "UserName" });
			body = Utils.ReplaceBodyValues(body, topicMessage.Topic, new[] { "Title", "Id" });
			body = Utils.ReplaceBodyValues(body, new Dictionary<string, string>() { { "unsubscribeUrl", unsubscribeUrl }, { "url", url } });
			body = Utils.ReplaceBodyValues(body, new Dictionary<string, string>() { { "body", message.Body } });
			#endregion
			message.Body = body;
			message.Subject = "Re: " + topicMessage.Topic.Title;

			SendMail(message);
		}

		public void SendMail(MailMessage message)
		{
			var client = new SmtpClient();
			client.Send(message);
		}
	}
}
