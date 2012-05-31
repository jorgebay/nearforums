using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using NearForums.Configuration.Notifications;
using System.IO;
using System.Xml;

namespace NearForums.Configuration
{
	public class SiteConfiguration : ConfigurationSection
	{
		#region Current
		private static object lockCurrentLoad = new object();
		private static SiteConfiguration config;
		/// <summary>
		/// Gets the site configuration from the configuration section "site". If applies overrides configuration with admin settings.
		/// </summary>
		public static SiteConfiguration Current
		{
			get
			{
				if (config == null)
				{
					lock (lockCurrentLoad)
					{
						config = (SiteConfiguration)ConfigurationManager.GetSection("site");
						if (config == null)
						{
							throw new System.Configuration.ConfigurationErrorsException("Siteconfiguration not set.");
						}
						if (config.UseSettings)
						{
							config.LoadSettings();
						}
					}
				}
				return config;
			}
			set
			{
				config = value;
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

		[ConfigurationProperty("authenticationProviders", IsRequired = true)]
		public AuthenticationProvidersElement AuthenticationProviders
		{
			get
			{
				return (AuthenticationProvidersElement)this["authenticationProviders"];
			}
			set
			{
				this["authenticationProviders"] = value;
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

		[ConfigurationProperty("search", IsRequired = false)]
		public SearchElement Search
		{
			get
			{
				return (SearchElement)this["search"];
			}
			set
			{
				this["search"] = value;
				if (value != null)
				{
					value.ParentElement = this;
				}
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

		#region Timezone
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
		#endregion

		/// <summary>
		/// Determines if the application should store and retrieve admin settings, apart from the site configuration
		/// </summary>
		[ConfigurationProperty("useSettings", IsRequired = false, DefaultValue=false)]
		private bool UseSettings
		{
			get
			{
				return (bool)this["useSettings"];
			}
			set
			{
				this["useSettings"] = value;
			}
		}

		#region Paths
		/// <summary>
		/// Determines the path of content files (localization,templates,...), relative to executing path. Example: ~/content/
		/// </summary>
		[ConfigurationProperty("contentPath", IsRequired = false, DefaultValue = @"~/content/")]
		public string ContentPath
		{
			get
			{
				return (string)this["contentPath"];
			}
			set
			{
				this["contentPath"] = value;
			}
		}

		/// <summary>
		/// Gets the full path of the Content folder
		/// </summary>
		public string ContentPathFull
		{
			get
			{
				return PathResolver(ContentPath);
			}
		}

		/// <summary>
		/// Gets the path on disk of the settings file. Example: c:\whatever\content\settings\main.xml
		/// </summary>
		public string SettingsFilePath
		{
			get
			{
				return Path.Combine(ContentPathFull, "settings\\main.xml");
			}
		}

		/// <summary>
		/// Gets the path on disk of the localization file. Example: c:\whatever\content\localization\en-us.po
		/// </summary>
		public string LocalizationFilePath(string cultureName)
		{
			if (cultureName == null)
			{
				throw new ArgumentNullException("cultureName");
			}
			return Path.Combine(ContentPathFull, "localization\\" + cultureName.ToLower() + ".po");
		}

		/// <summary>
		/// Gets the path on disk of the template folder. Example: c:\whatever\content\templates\template-key
		/// </summary>
		public string TemplateFolderPathFull(string templateKey)
		{
			return PathResolver(TemplateFolderPath(templateKey));
		}

		/// <summary>
		/// Gets the virtual path of the template folder. Example: ~/content/templates/template-key
		/// </summary>
		public string TemplateFolderPath(string templateKey)
		{
			if (templateKey == null)
			{
				throw new ArgumentNullException("templateKey");
			}
			return ContentPath + "templates/" + templateKey.ToLower();
		} 
		#endregion

		/// <summary>
		/// Determines the path of localization files, relative to executing path. Example: content\localization\
		/// </summary>
		[ConfigurationProperty("cultureName", IsRequired = false, DefaultValue = "en-US")]
		public string CultureName
		{
			get
			{
				var cultureName = (string)this["cultureName"];
				if (String.IsNullOrWhiteSpace(cultureName))
				{
					cultureName = System.Globalization.CultureInfo.CurrentCulture.Name;
				}
				return cultureName;
			}
			set
			{
				this["cultureName"] = value;
			}
		}

		public override bool IsReadOnly()
		{
			return false;
		}

		protected override void PostDeserialize()
		{
			base.PostDeserialize();

			ProcessMissingElements(this);

			Search.ParentElement = this;
		}

		#region Load settings
		/// <summary>
		/// Loads settings by overriding configuration with admin settings.
		/// </summary>
		protected virtual void LoadSettings()
		{
			try
			{
				using (var settingsFile = File.Open(SettingsFilePath, FileMode.Open, FileAccess.Read))
				{
					using (var reader = new XmlTextReader(settingsFile))
					{
						reader.Read();
						DeserializeElement(reader, false);
					}
				}
			}
			catch (DirectoryNotFoundException) { }
			catch (FileNotFoundException) { }
			//Its OK if there isn't settings
		}

		private Func<string, string> _pathResolver;
		public Func<string, string> PathResolver
		{
			get
			{
				if (_pathResolver == null)
				{
					_pathResolver = path => Path.Combine(Path.GetDirectoryName(AppDomain.CurrentDomain.SetupInformation.ConfigurationFile), path);
				}
				return _pathResolver;
			}
			set
			{
				_pathResolver = value;
			}
		}
		#endregion

		#region Save settings
		/// <summary>
		/// Saves current settings.
		/// </summary>
		public void SaveSettings()
		{
			var writer = XmlTextWriter.Create(SettingsFilePath, new XmlWriterSettings() 
			{ 
				ConformanceLevel = ConformanceLevel.Fragment, 
				Encoding = Encoding.UTF8,
				Indent = true
			});
			writer.WriteStartElement("site");
			try
			{
				SerializeElement(writer, false);
				writer.WriteEndElement();
			}
			finally
			{
				writer.Close();
			}
		}
		#endregion

		#region Handle missing elements
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
		#endregion
	}
}