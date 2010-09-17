using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using NearForums.Configuration.Notifications;

namespace NearForums.Configuration
{
	public class SiteConfiguration : ConfigurationSection
	{
		#region Current
		public static SiteConfiguration Current
		{
			get
			{
				SiteConfiguration config = (SiteConfiguration)ConfigurationManager.GetSection("site");
				if (config == null)
				{
					throw new System.Configuration.ConfigurationErrorsException("Siteconfiguration not set.");
				}
				return config;
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

		[ConfigurationProperty("authorizationProviders", IsRequired = true)]
		public AuthorizationProvidersElement AuthorizationProviders
		{
			get
			{
				return (AuthorizationProvidersElement)this["authorizationProviders"];
			}
			set
			{
				this["authorizationProviders"] = value;
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

		[ConfigurationProperty("dataAccess", IsRequired = true)]
		public DataAccessElement DataAccess
		{
			get
			{
				return (DataAccessElement)this["dataAccess"];
			}
			set
			{
				this["dataAccess"] = value;
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

		[ConfigurationProperty("notifications", IsRequired = false)]
		public NotificationsContainerElement Notifications
		{
			get
			{
				return (NotificationsContainerElement)this["notifications"];
			}
			set
			{
				this["notifications"] = value;
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
