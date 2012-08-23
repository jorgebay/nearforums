using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Serialization;
using System.Configuration;

namespace NearForums.Configuration.Redirector
{
	/// <summary>
	/// Represents a group of urls that should be captured to redirect
	/// </summary>
	public class RedirectorUrlGroup : ConfigurationElement, IUniqueConfigurationElement
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

		/// <summary>
		/// A collection of specific urls that must be captured within the group
		/// </summary>
		[ConfigurationProperty("urls", IsRequired=true)]
		public ConfigurationElementCollection<RedirectorUrl> Urls
		{
			get
			{
				return (ConfigurationElementCollection<RedirectorUrl>)this["urls"];
			}
			set
			{
				this["urls"] = value;
			}
		}

		#region IUniqueConfigurationElement Members
		public string Key
		{
			get 
			{
				//The url regex to capture must be unique
				return Regex;
			}
		}
		#endregion
	}
}
