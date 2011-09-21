using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using NearForums.Configuration.Notifications;
using System.IO;

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

		[ConfigurationProperty("ui", IsRequired = true)]
		public UIElement UI
		{
			get
			{
				return (UIElement)this["ui"];
			}
			set
			{
				this["ui"] = value;
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

		[ConfigurationProperty("dataAccess", IsRequired = false)]
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

		[ConfigurationProperty("spamPrevention", IsRequired = true)]
		public SpamPreventionElement SpamPrevention
		{
			get
			{
				return (SpamPreventionElement)this["spamPrevention"];
			}
			set
			{
				this["spamPrevention"] = value;
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

		/// <summary>
		/// Combines the current application configuration path with the fileName given
		/// </summary>
		/// <param name="fileName"></param>
		/// <returns></returns>
		public string CombinePath(string fileName)
		{
			return Path.Combine(Path.GetDirectoryName(AppDomain.CurrentDomain.SetupInformation.ConfigurationFile), fileName);
		}

		protected override void PostDeserialize()
		{
			ProcessMissingElements(this);
			base.PostDeserialize();
		}

		private void ProcessMissingElements(ConfigurationElement element)
		{

			foreach (PropertyInformation propertyInformation in element.ElementInformation.Properties)
			{

				var complexProperty = propertyInformation.Value as ConfigurationElement;

				if (complexProperty != null)
				{
					if (propertyInformation.IsRequired && !complexProperty.ElementInformation.IsPresent)
					{
						throw new ConfigurationErrorsException("Configuration element: [" + propertyInformation.Name + "] is required but not present");
					}
					else
					{
						ProcessMissingElements(complexProperty);
					}
				}
			}
		}
	}
}
