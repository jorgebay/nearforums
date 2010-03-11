using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	public class SiteConfiguration : ConfigurationSection
	{
		#region Current
		public static SiteConfiguration Current
		{
			get
			{
				return (SiteConfiguration) ConfigurationManager.GetSection("site");
			}
		}
		#endregion

		[ConfigurationProperty("topics", IsRequired = true)]
		public TopicElement Topics
		{
			get
			{
				return (TopicElement)this["topics"];
			}
			set
			{
				this["topics"] = value;
			}
		}

		[ConfigurationProperty("forums", IsRequired = true)]
		public ForumElement Forums
		{
			get
			{
				return (ForumElement)this["forums"];
			}
			set
			{
				this["forums"] = value;
			}
		}

		[ConfigurationProperty("facebook", IsRequired = true)]
		public FacebookElement Facebook
		{
			get
			{
				return (FacebookElement)this["facebook"];
			}
			set
			{
				this["facebook"] = value;
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

		[ConfigurationProperty("replacements", IsRequired = false)]
		public ReplacementCollection Replacements
		{
			get
			{
				return (ReplacementCollection)this["replacements"];
			}
			set
			{
				this["replacements"] = value;
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

		[ConfigurationProperty("timeZoneOffset", IsRequired = false)]
		private decimal? TimeZoneOffsetHours
		{
			get
			{
				return (decimal?)this["timeZoneOffset"];
			}
			set
			{
				this["timeZoneOffset"] = value;
			}
		}

		public TimeSpan? TimeZoneOffset
		{
			get
			{
				if (this.TimeZoneOffsetHours == null)
				{
					return null;
				}
				return new TimeSpan(0, Convert.ToInt32(this.TimeZoneOffsetHours * 60), 0);
			}
		}
	}
}
