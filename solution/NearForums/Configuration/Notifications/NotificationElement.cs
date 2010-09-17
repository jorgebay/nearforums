using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration.Notifications
{
	public class NotificationElement : ConfigurationElement
	{
		[ConfigurationProperty("body", IsRequired = true)]
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
	}
}
