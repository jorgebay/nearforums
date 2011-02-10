using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	public class SpamPreventionElement : ConfigurationElement
	{
		/// <summary>
		/// Time (in minutes) required to pass between postings
		/// </summary>
		[ConfigurationProperty("timeToRepost", IsRequired = false)]
		public int TimeToRepost
		{
			get
			{
				return (int)this["timeToRepost"];
			}
			set
			{
				this["timeToRepost"] = value;
			}
		}

		/// <summary>
		/// Rules for the html entered by the user.
		/// </summary>
		[ConfigurationProperty("htmlInput", IsRequired = false)]
		public HtmlInputElement HtmlInput
		{
			get
			{
				return (HtmlInputElement)this["htmlInput"];
			}
			set
			{
				this["htmlInput"] = value;
			}
		}
	}
}
