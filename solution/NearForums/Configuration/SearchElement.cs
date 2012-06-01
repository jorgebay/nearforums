using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.IO;

namespace NearForums.Configuration
{
	public class SearchElement : ConfigurationElement
	{
		public SiteConfiguration ParentElement
		{
			get;
			set;
		}

		/// <summary>
		/// Gets the index file path.
		/// </summary>
		public string IndexPath
		{
			get
			{
				return Path.Combine(ParentElement.ContentPathFull, "search-index");
			}
		}

		/// <summary>
		/// Determines the max amount of messages to be indexed per topic
		/// </summary>
		[ConfigurationProperty("maxMessages", IsRequired = false, DefaultValue=20)]
		public int MaxMessages
		{
			get
			{
				return (int)this["maxMessages"];
			}
			set
			{
				this["maxMessages"] = value;
			}
		}
	}
}
