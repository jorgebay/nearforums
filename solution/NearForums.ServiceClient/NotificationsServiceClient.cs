using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Mail;
using NearForums.Configuration;
using NearForums;

namespace NearForums.ServiceClient
{
	public class NotificationsServiceClient
	{

		private static void SendEmail(User user, string body, string url)
		{
			if (user.Guid == Guid.Empty)
			{
				throw new ArgumentException("User.Guid cannot be empty.");
			}
			MailMessage message = new MailMessage();
			message.To.Add(new MailAddress(user.Email, user.UserName));
			message.IsBodyHtml = true;
			#region Replace body values
			body = Utils.ReplaceBodyValues(body, user, new[] { "UserName" });
			body = Utils.ReplaceBodyValues(body, new Dictionary<string, string>() {{ "url", url } });
			#endregion
			message.Body = body;
			message.Subject = "Reset Password";

			SmtpClient client = new SmtpClient();
			client.Send(message);
		}

		public static int SendNotificationsSync(User user, string body, string url, bool handleExceptions)
		{
			int sentMailsCount = 0;
			try
			{
				SendEmail(user, body, url);
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
					throw;
				}
			}
			return sentMailsCount;
		}

	}
}
