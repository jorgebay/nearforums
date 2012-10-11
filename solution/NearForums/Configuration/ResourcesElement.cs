using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	public class ResourcesElement : ConfigurationElement
	{
		/// <summary>
		/// JQuery library Url. Can be either a virtual path (starting with ~/) or an absolute url, like Google CDNS. 
		/// </summary>
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
