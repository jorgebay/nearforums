using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	public class UIElement : ConfigurationElement
	{
		/// <summary>
		/// Determines the amount of messages per page are shown on the topic detail page
		/// </summary>
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

		/// <summary>
		/// Determines the amount of topics per page are shown on the forum detail page
		/// </summary>
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

		[ConfigurationProperty("dateFormat", IsRequired = false)]
		public string DateFormat
		{
			get
			{
				return (string)this["dateFormat"];
			}
			set
			{
				this["dateFormat"] = value;
			}
		}

		[ConfigurationProperty("template", IsRequired = true)]
		public TemplateElement Template
		{
			get
			{
				return (TemplateElement)this["template"];
			}
			set
			{
				this["template"] = value;
			}
		}

		/// <summary>
		/// Determines if user details (image, member since, ...) are shown on topic detail page
		/// </summary>
		[ConfigurationProperty("showUserDetailsOnList", IsRequired = false)]
		public bool ShowUserDetailsOnList
		{
			get
			{
				return (bool)this["showUserDetailsOnList"];
			}
			set
			{
				this["showUserDetailsOnList"] = value;
			}
		}
	}
}
