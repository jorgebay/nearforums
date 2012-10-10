using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.IO;
using NearForums.Validation;

namespace NearForums.Configuration
{
	/// <summary>
	/// Contains the general configuration properties for the site
	/// </summary>
	public class GeneralElement : SettingConfigurationElement
	{
		/// <summary>
		/// Determines the path of localization files, relative to executing path. 
		/// Example: content\localization\
		/// </summary>
		[ConfigurationProperty("cultureName", DefaultValue = "en-US")]
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
		[ConfigurationProperty("timeZoneOffset", DefaultValue="-5")]
		public decimal? TimeZoneOffsetHours
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
			set
			{
				if (value == null)
				{
					TimeZoneOffsetHours = null;
				}
				else
				{
					TimeZoneOffsetHours = (decimal) value.Value.TotalHours;
				}
			}
		}

		/// <summary>
		/// Determines the path of content files (localization,templates,...), relative to executing path. Example: ~/content/
		/// </summary>
		[ConfigurationProperty("contentPath", DefaultValue = @"~/content/")]
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
				return SiteConfiguration.PathResolver(ContentPath);
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
			return SiteConfiguration.PathResolver(TemplateFolderPath(templateKey));
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

		public override void ValidateFields()
		{
			var errors = new List<ValidationError>();
			if (TimeZoneOffsetHours.HasValue && (TimeZoneOffsetHours.Value > 14 || TimeZoneOffsetHours.Value < -12))
			{
				errors.Add(new ValidationError("TimeZoneOffsetHours", ValidationErrorType.Range));
			}
			if (!Directory.Exists(ContentPathFull))
			{
				errors.Add(new ValidationError("ContentPath", ValidationErrorType.CompareNotMatch));
			}
			else if (!File.Exists(LocalizationFilePath(CultureName)))
			{
				errors.Add(new ValidationError("CultureName", ValidationErrorType.CompareNotMatch));
			}

			if (errors.Count > 0)
			{
				throw new ValidationException(errors);
			}
		}
	}
}
