using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums.Configuration.Settings
{
	/// <summary>
	/// Defines the methods using for storing and retrieving settings
	/// </summary>
	public interface ISettingsRepository
	{
		/// <summary>
		/// Loads the settings from the repository
		/// </summary>
		/// <param name="config"></param>
		SiteConfiguration LoadSettings(SiteConfiguration config);

		/// <summary>
		/// Stores the settings for persistance
		/// </summary>
		/// <param name="config"></param>
		void SaveSetting(SettingConfigurationElement element);
	}
}
