using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Configuration;

namespace NearForums.Configuration
{
	public class RedirectorUrl : ConfigurationElement
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

		[ConfigurationProperty("replacement", IsRequired = true)]
		public string Replacement
		{
			get
			{
				return (string)this["replacement"];
			}
			set
			{
				this["replacement"] = value;
			}
		}

		[ConfigurationProperty("headerRegex", IsRequired = false)]
		public string HeaderRegex
		{
			get
			{
				return (string)this["headerRegex"];
			}
			set
			{
				this["headerRegex"] = value;
			}
		}

		[ConfigurationProperty("responseStatus", IsRequired = false)]
		public int ResponseStatus
		{
			get
			{
				return (int)this["responseStatus"];
			}
			set
			{
				this["responseStatus"] = value;
			}
		}

		public RedirectorUrl()
		{
			//Moved permanently by default
			ResponseStatus = 301;
		}

		public RedirectorUrl(string regex, string replacement) : this()
		{
			Regex = regex;
			Replacement = replacement;
		}
	}
}
