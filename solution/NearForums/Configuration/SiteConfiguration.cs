using System;
using System.Configuration;
using NearForums.Configuration.Notifications;
using NearForums.Configuration.Settings;
using NearForums.Configuration.Spam;
using System.IO;

namespace NearForums.Configuration
{
	public class SiteConfiguration : ConfigurationSection
	{
		#region Static members
		private static object _lockCurrentLoad = new object();
		private static SiteConfiguration _config;
		/// <summary>
		/// Gets the site configuration from the configuration section "site". If applies overrides configuration with admin settings.
		/// </summary>
		public static SiteConfiguration Current
		{
			get
			{
				if (_config == null)
				{
					lock (_lockCurrentLoad)
					{
						_config = (SiteConfiguration)ConfigurationManager.GetSection("site");
						if (_config == null)
						{
							throw new System.Configuration.ConfigurationErrorsException("Siteconfiguration not set.");
						}
						if (_config.UseSettings && SettingsRepository != null)
						{
							_config.LoadSettings();
						}
					}
				}
				return _config;
			}
			set
			{
				_config = value;
			}
		}
		private static Func<string, string> _pathResolver;
		/// <summary>
		/// Converts the virtual path into physical file path
		/// </summary>
		public static Func<string, string> PathResolver
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

		private static ISettingsRepository _settingsRepository;
		/// <summary>
		/// Gets or sets the repository used to load and save settings
		/// </summary>
		public static ISettingsRepository SettingsRepository
		{
			get
			{
				return _settingsRepository;
			}
			set
			{
				_settingsRepository = value;
			}
		}

		#endregion

		/// <summary>
		/// Defines the authentication providers for the site
		/// </summary>
		[ConfigurationProperty("authenticationProviders")]
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

		/// <summary>
		/// Defines the data access for the site
		/// </summary>
		[ConfigurationProperty("dataAccess")]
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

		/// <summary>
		/// Gets or sets the general configuration for the site
		/// </summary>
		[ConfigurationProperty("general")]
		public GeneralElement General
		{
			get
			{
				return (GeneralElement)this["general"];
			}
			set
			{
				this["general"] = value;
			}
		}

		/// <summary>
		/// Gets or sets the notification configuration for the site
		/// </summary>
		[ConfigurationProperty("notifications")]
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

		/// <summary>
		/// Gets or sets the replacements
		/// </summary>
		[ConfigurationProperty("replacements")]
		public ConfigurationElementCollection<ReplacementItem> Replacements
		{
			get
			{
				return (ConfigurationElementCollection<ReplacementItem>)this["replacements"];
			}
			set
			{
				this["replacements"] = value;
			}
		}

		/// <summary>
		/// Gets or sets the search configuration
		/// </summary>
		[ConfigurationProperty("search")]
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
		
		/// <summary>
		/// Gets or sets the configuration for the spam prevention features
		/// </summary>
		[ConfigurationProperty("spamPrevention")]
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

		/// <summary>
		/// Defines the user interface configuration for the site
		/// </summary>
		[ConfigurationProperty("ui")]
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

		/// <summary>
		/// Determines if the application should store and retrieve admin settings, apart from the site configuration
		/// </summary>
		[ConfigurationProperty("useSettings", IsRequired = false, DefaultValue=true)]
		public bool UseSettings
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
		public virtual void LoadSettings()
		{
			if (_settingsRepository == null)
			{
				throw new NullReferenceException("settings repository can not be null");
			}
			_settingsRepository.LoadSettings(this);
		}
		#endregion

		#region Save settings
		/// <summary>
		/// Saves current settings.
		/// </summary>
		/// <exception cref="ValidationException"></exception>
		public virtual void SaveSetting(SettingConfigurationElement element)
		{
			if (!UseSettings)
			{
				throw new ConfigurationErrorsException("Saving settings is not possible when is not enabled by configuration (useSettings)");
			}
			if (_settingsRepository == null)
			{
				throw new NullReferenceException("settings repository can not be null");
			}
			_settingsRepository.SaveSetting(element);


			if (element is GeneralElement)
			{
				General = (GeneralElement) element;
			}
			else if (element is UIElement)
			{
				UI = (UIElement)element;
			}
			else if (element is SpamPreventionElement)
			{
				SpamPrevention = (SpamPreventionElement)element;
			}
			else if (element is SearchElement)
			{
				Search = (SearchElement)element;
			}
			else
			{
				throw new NotSupportedException("Element of type " + element.GetType().Name + " is not supported.");
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