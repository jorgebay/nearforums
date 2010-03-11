using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	public class ForumElement : ConfigurationElement
	{
		[ConfigurationProperty("topicsPerPage", IsRequired = true)]
		public int TopicsPerPage
		{
			get
			{
				return (int)this["topicsPerPage"];
			}
			set
			{
				this["topicsPerPage"] = value;
			}
		}
		/// <summary>
		/// Amount of tags in the tag cloud
		/// </summary>
		[ConfigurationProperty("tagsCloudCount", IsRequired = true)]
		public int TagsCloudCount
		{
			get
			{
				return (int)this["tagsCloudCount"];
			}
			set
			{
				this["tagsCloudCount"] = value;
			}
		}
	}
}
