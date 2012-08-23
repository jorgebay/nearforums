using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Xml.Serialization;
using System.Configuration;

namespace NearForums.Configuration.Redirector
{
	public class RedirectorConfiguration : ConfigurationSection
	{
		[ConfigurationProperty("urlGroups", IsRequired = true)]
		public ConfigurationElementCollection<RedirectorUrlGroup> UrlGroups
		{
			get
			{
				return (ConfigurationElementCollection<RedirectorUrlGroup>) this["urlGroups"];
			}
			set
			{
				this["urlGroups"] = value;
			}
		}

		/// <summary>
		/// Regular expression, if matches the url will be ignored.
		/// </summary>
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

		public static RedirectorConfiguration Current
		{
			get
			{
				return (RedirectorConfiguration)ConfigurationManager.GetSection("redirector");
			}
		}
	}


}
