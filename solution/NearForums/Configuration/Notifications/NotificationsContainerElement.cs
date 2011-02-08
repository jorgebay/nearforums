using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration.Notifications
{
	public class NotificationsContainerElement : ConfigurationElement
	{
		[ConfigurationProperty("subscription", IsRequired = false)]
		public NotificationElement Subscription
		{
			get
			{
				return (NotificationElement)this["subscription"];
			}
			set
			{
				this["subscription"] = value;
			}
		}
	}
}
