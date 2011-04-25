using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration.Notifications
{
	public class NotificationElement : ConfigurationElement, IOptionalElement
	{
		[ConfigurationProperty("body", IsRequired = false)]
		public CDataElement Body
		{
			get
			{
				return (CDataElement)this["body"];
			}
			set
			{
				this["body"] = value;
			}
		}

	
		public bool IsDefined
		{
			get
			{
				return SiteConfiguration.Current.Notifications != null && SiteConfiguration.Current.Notifications.MembershipPasswordReset !=null && (!String.IsNullOrEmpty(this.Body.ToString()));
			}
		}
	}
}
