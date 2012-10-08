using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	public class ResourcesElement : ConfigurationElement
	{
		[ConfigurationProperty("jqueryUrl", DefaultValue="~/scripts/jquery-1.7.1.min.js")]
		public string JQueryUrl
		{
			get
			{
				return (string)this["jqueryUrl"];
			}
			set
			{
				this["jqueryUrl"] = value;
			}
		}
	}
}
