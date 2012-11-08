using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.IO;
using NearForums.Configuration.Settings;
using NearForums.Configuration;
using System.Data.Common;
using System.Configuration;
using NearForums.Configuration.Spam;

namespace NearForums.DataAccess
{
	public class DatabaseSettingsRepository : BaseDataAccess, ISettingsRepository
	{
		/// <summary>
		/// Forums config db connection string, if not set it returns the default connection string
		/// </summary>
		protected override ConnectionStringSettings ConnectionString
		{
			get
			{
				var conn = ConfigurationManager.ConnectionStrings["ForumsConfig"];
				if (conn == null)
				{
					conn = base.ConnectionString;
				}
				return EnsureProvider(conn);
			}
		}

		public virtual string KeyPrefix
		{
			get;
			set;
		}

		/// <summary>
		/// Gets a value from setting db
		/// </summary>
		/// <param name="value"></param>
		/// <param name="elementName"></param>
		/// <returns></returns>
		protected virtual StringBuilder GetFromDb(string elementName)
		{
			StringBuilder value = null;
			var comm = GetCommand("SPSettingsGet");
			comm.AddParameter<string>(Factory, "SettingKey", GetSettingKey(elementName));
			var dr = GetFirstRow(comm);
			if (dr != null)
			{
				value = new StringBuilder(dr.GetString("SettingValue"));
			}
			return value;
		}

		/// <summary>
		/// Gets the key for a setting element
		/// </summary>
		/// <param name="elementName"></param>
		/// <returns></returns>
		protected virtual string GetSettingKey(string elementName)
		{
			return KeyPrefix + "setting." + elementName.ToLower();
		}

		protected virtual void LoadElement(SettingConfigurationElement element, string elementName)
		{
			var serializedValue = GetFromDb(elementName);
			if (serializedValue != null && serializedValue.Length > 0)
			{
				element.Deserialize(serializedValue);
			}
		}

		public SiteConfiguration LoadSettings(SiteConfiguration config)
		{
			LoadElement(config.General, "general");
			LoadElement(config.UI, "ui");
			return config;
		}

		/// <summary>
		/// Serializes an element and stores into the database
		/// </summary>
		/// <param name="element"></param>
		/// <param name="elementName"></param>
		/// <exception cref="ValidationException"></exception>
		protected virtual void SaveElement(SettingConfigurationElement element, string elementName)
		{
			var builder = new StringBuilder();
			element.Serialize(builder, elementName);
			SaveToDb(builder, elementName);
		}

		/// <summary>
		/// Saves the settings in the db
		/// </summary>
		/// <param name="config"></param>
		public void SaveSetting(SettingConfigurationElement element)
		{
			string elementName = null;
			if (element is GeneralElement)
			{
				elementName = "general";
			}
			else if (element is UIElement)
			{
				elementName = "ui";
			}
			else if (element is SpamPreventionElement)
			{
				elementName = "spamPrevention";
			}
			else if (element is SearchElement)
			{
				elementName = "search";
			}
			else
			{
				throw new NotSupportedException("Element of type " + element.GetType().Name + " is not supported.");
			}
			element.ValidateFields();
			SaveElement(element, elementName);
		}

		/// <summary>
		/// Inserts or update the value on settings db
		/// </summary>
		/// <param name="value"></param>
		/// <param name="elementName"></param>
		protected virtual void SaveToDb(StringBuilder value, string elementName)
		{
			var comm = GetCommand("SPSettingsSet");
			comm.AddParameter<string>(Factory, "SettingKey", GetSettingKey(elementName));
			comm.AddParameter<string>(Factory, "SettingValue", value.ToString());
			comm.SafeExecuteNonQuery();
		}
	}
}
