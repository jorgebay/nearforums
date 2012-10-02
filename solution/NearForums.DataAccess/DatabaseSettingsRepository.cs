using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.IO;
using NearForums.Configuration.Settings;
using NearForums.Configuration;

namespace NearForums.DataAccess
{
	public class DatabaseSettingsRepository : ISettingsRepository
	{
		public SiteConfiguration LoadSettings(SiteConfiguration config)
		{
			//try
			//{
			//    using (var settingsFile = File.Open(SettingsFilePath, FileMode.Open, FileAccess.Read))
			//    {
			//        using (var reader = new XmlTextReader(settingsFile))
			//        {
			//            reader.Read();
			//            DeserializeElement(reader, false);
			//        }
			//    }
			//}
			//catch (DirectoryNotFoundException) { }
			//catch (FileNotFoundException) { }
			////Its OK if there isn't settings
			throw new NotImplementedException();
		}

		/// <summary>
		/// Serializes an element and stores into the database
		/// </summary>
		/// <param name="element"></param>
		/// <param name="elementName"></param>
		protected virtual void SaveElement(BaseConfigurationElement element, string elementName)
		{
			var builder = new StringBuilder();
			element.Serialize(builder, elementName);
		}

		/// <summary>
		/// Saves the settings in the db
		/// </summary>
		/// <param name="config"></param>
		public void SaveSettings(SiteConfiguration config)
		{
			SaveElement(config.General, "general");
			SaveElement(config.UI, "general");
		}

		protected virtual void SaveToDb(StringBuilder value, string elementName)
		{

		}
	}
}
