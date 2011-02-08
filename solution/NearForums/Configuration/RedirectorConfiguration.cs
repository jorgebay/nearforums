using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Xml.Serialization;
using System.Configuration;

namespace NearForums.Configuration
{
	public class RedirectorConfiguration : ConfigurationSection
	{
		[ConfigurationProperty("urlGroups", IsRequired = true)]
		public RedirectorUrlGroupCollection UrlGroups
		{
			get
			{
				return (RedirectorUrlGroupCollection)this["urlGroups"];
			}
			set
			{
				this["urlGroups"] = value;
			}
		}

		[ConfigurationProperty("ignoreRegex", IsRequired=false)]
		public string IgnoreRegex
		{
			get
			{
				return (string)this["ignoreRegex"];
			}
			set
			{
				this["ignoreRegex"] = value;
			}
		} 

		public RedirectorConfiguration()
		{

		}

		public static RedirectorConfiguration Current
		{
			get
			{
				return (RedirectorConfiguration)ConfigurationManager.GetSection("redirector");
			}
		}
	}


}
