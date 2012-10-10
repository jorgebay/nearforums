using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NearForums.Configuration;
using NearForums.DataAccess;

namespace NearForums.Tests
{
	[TestClass]
	public class ConfigurationSettingsTests
	{
		[TestMethod]
		public void Configuration_Basic_Test()
		{
			var configFilePath = AppDomain.CurrentDomain.SetupInformation.ConfigurationFile;

			Assert.IsTrue(configFilePath.ToUpper().EndsWith(".DLL.CONFIG"));

			Assert.IsNotNull(SiteConfiguration.Current);

			Assert.IsNotNull(SiteConfiguration.Current.DataAccess.ParameterPrefix);

			Assert.IsNotNull(SiteConfiguration.Current.DataAccess.ConnectionString);

			Assert.IsTrue(!String.IsNullOrEmpty(SiteConfiguration.Current.DataAccess.ConnectionString.ProviderName));

			//Open connection to db
			var da = new UsersDataAccess();
			var conn = da.GetConnection();
			conn.Open();
			conn.Close();
		}

		[TestMethod]
		public void Configuration_Settings_Write_Test()
		{
			var builder = new StringBuilder();

			builder.Clear();
			var generalSettings = SiteConfiguration.Current.General;
			generalSettings.CultureName = "es-ES";
			generalSettings.Serialize(builder, "general");
			Assert.IsTrue(builder.ToString().Contains("cultureName"));

			builder.Clear();
			var uiSettings = SiteConfiguration.Current.UI;
			uiSettings.DateFormat = "D";
			uiSettings.Serialize(builder, "ui");
			Assert.IsTrue(builder.ToString().Contains("dateFormat"));
		}

		[TestMethod]
		public void Configuration_Settings_Load_Save_Test()
		{
			SiteConfiguration.SettingsRepository = new DatabaseSettingsRepository() { KeyPrefix = "tests."};
			var config = SiteConfiguration.Current;
			config.UseSettings = true;
			config.LoadSettings();

			var dateFormatOriginalValue = config.UI.DateFormat;
			var dateFormatNew = "d '" + new Random().Next().ToString() + "'";
			config.UI.DateFormat = dateFormatNew;

			config.SaveSetting(config.UI);
			config.LoadSettings();

			Assert.AreEqual(dateFormatNew, config.UI.DateFormat);

			config.UI.DateFormat = dateFormatOriginalValue;
			config.SaveSetting(config.UI);

		}

		[TestMethod]
		public void NotificationsConfiguration_Test()
		{
			string value = SiteConfiguration.Current.Notifications.Subscription.Body.Value;
		}
	}
}
