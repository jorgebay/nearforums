using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.IO;

namespace NearForums.Configuration.Settings
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

		public void SaveSettings(SiteConfiguration config)
		{
			SaveElement(config.General, "general");
			SaveElement(config.UI, "general");
		}

		public void SaveElement(BaseConfigurationElement element, string elementName)
		{
			var builder = new StringBuilder();
			element.Serialize(builder, elementName);
		}
	}
}
