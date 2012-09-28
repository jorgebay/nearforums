using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.IO;

namespace NearForums.Configuration
{
	/// <summary>
	/// Contains the general configuration properties for the site
	/// </summary>
	public class GeneralElement : ConfigurationElement
	{
		/// <summary>
		/// Determines the path of localization files, relative to executing path. 
		/// Example: content\localization\
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

		/// <summary>
		/// Timezone expressed in hours
		/// </summary>
		[ConfigurationProperty("timeZoneOffset", IsRequired = false, DefaultValue="-5")]
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

		/// <summary>
		/// Timezone expressed in TimeSpan.
		/// </summary>
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

		private Func<string, string> _pathResolver;
		/// <summary>
		/// Converts the virtual path into physical file path
		/// </summary>
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
	}
}
