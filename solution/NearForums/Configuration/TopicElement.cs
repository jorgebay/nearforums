using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	public class TopicElement : ConfigurationElement
	{
		[ConfigurationProperty("messagesPerPage", IsRequired = true)]
		public int MessagesPerPage
		{
			get
			{
				return (int)this["messagesPerPage"];
			}
			set
			{
				this["messagesPerPage"] = value;
			}
		}
	}
}
