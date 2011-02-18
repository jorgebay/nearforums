using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Serialization;
using System.Configuration;

namespace NearForums.Configuration
{
	public class RedirectorUrlGroup : ConfigurationElement
	{
		[ConfigurationProperty("regex", IsRequired = true)]
		public string Regex
		{
			get
			{
				return (string)this["regex"];
			}
			set
			{
				this["regex"] = value;
			}
		}

		[ConfigurationProperty("urls", IsRequired=true)]
		public RedirectorUrlCollection Urls
		{
			get
			{
				return (RedirectorUrlCollection)this["urls"];
			}
			set
			{
				this["urls"] = value;
			}
		}

		public RedirectorUrlGroup()
		{

		}
	}
}
