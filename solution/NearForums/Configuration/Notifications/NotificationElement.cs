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
		/// <summary>
		/// Determines the way (synchronous or asynchronous) the email notifications are sent by default
		/// </summary>
		[ConfigurationProperty("async", IsRequired = false, DefaultValue = false)]
		public bool Async
		{
			get
			{
				return (bool)this["async"];
			}
			set
			{
				this["async"] = value;
			}
		}

	
		public bool IsDefined
		{
			get
			{
				return (!String.IsNullOrEmpty(this.Body.ToString()));
			}
		}
	}
}
