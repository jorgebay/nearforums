using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Configuration;
using NearForums.Configuration;
using System.ComponentModel;

namespace NearForums
{
	public class CDataConfigurationElement
	: ConfigurationElement
	{
		private readonly string _cDataConfigurationPropertyName;

		public CDataConfigurationElement()
		{
			PropertyInfo[] properties = GetType().GetProperties();
			int cDataConfigurationPropertyCount = 0;
			int configurationElementPropertyCount = 0;
			for (int i = 0; i < properties.Length; i++)
			{
				PropertyInfo property = properties[i];
				ConfigurationPropertyAttribute[] configurationPropertyAttributes =
					getAttributes<ConfigurationPropertyAttribute>(property);
				CDataConfigurationPropertyAttribute[] cDataConfigurationPropertyAttribute =
					getAttributes<CDataConfigurationPropertyAttribute>(property);

				bool hasConfigurationPropertyAttribute =
					configurationPropertyAttributes.Length != 0;
				bool hasCDataConfigurationPropertyAttribute =
					cDataConfigurationPropertyAttribute.Length != 0;

				if (hasConfigurationPropertyAttribute &&
					property.PropertyType.IsSubclassOf(
						typeof(ConfigurationElement)))
				{
					configurationElementPropertyCount++;
				}

				if (hasCDataConfigurationPropertyAttribute)
				{
					cDataConfigurationPropertyCount++;
					throwIf(
						cDataConfigurationPropertyCount > 1,
						"TOO MANY CDATA CONFIGURATION ELEMENTS");

					throwIf(
						!hasConfigurationPropertyAttribute,
						"MISSING CONFIGURATION PROPERTY ATTRIBUTE",
						property.Name);

					throwIf(
						!property.PropertyType.Equals(typeof(string)),
						"CDATA CONFIGURATION PROPERTY MUST BE STRING",
						property.Name);

					_cDataConfigurationPropertyName =
						configurationPropertyAttributes[0].Name;
				}
			}

			throwIf(
				configurationElementPropertyCount > 0 &&
					cDataConfigurationPropertyCount > 0,
				"CLASS CONTAINS CONFIGURATION PROPERTY",
				GetType().FullName);
		}

		private T[] getAttributes<T>(PropertyInfo property)
			where T : Attribute
		{
			object[] objectAttributes = property.GetCustomAttributes(
					typeof(T),
					true);
			return Array.ConvertAll<object, T>(
					objectAttributes,
					delegate(object o)
					{
						return o as T;
					});
		}

		private void throwIf(
			bool condition,
			string formatString,
			params object[] values)
		{
			if (condition)
			{
				if (values.Length > 0)
				{
					formatString = string.Format(formatString, values);
				}

				throw new ConfigurationErrorsException(
					formatString);
			}
		}

		protected override bool SerializeElement(
			System.Xml.XmlWriter writer,
			bool serializeCollectionKey)
		{
			if (writer == null)
			{
				return true;
			}
			bool returnValue;
			if (string.IsNullOrEmpty(
				_cDataConfigurationPropertyName))
			{
				returnValue = base.SerializeElement(
					writer, serializeCollectionKey);
			}
			else
			{
				foreach (ConfigurationProperty configurationProperty in
					Properties)
				{
					string name = configurationProperty.Name;
					TypeConverter converter = configurationProperty.Converter;
					string propertyValue = converter.ConvertToString(
							base[name]);

					if (name == _cDataConfigurationPropertyName)
					{
						writer.WriteCData(propertyValue);
					}
					else
					{
						writer.WriteAttributeString("name", propertyValue);
					}
				}
				returnValue = true;
			}
			return returnValue;
		}

		protected override void DeserializeElement(
			System.Xml.XmlReader reader,
			bool serializeCollectionKey)
		{
			if (string.IsNullOrEmpty(
				_cDataConfigurationPropertyName))
			{
				base.DeserializeElement(
					reader, serializeCollectionKey);
			}
			else
			{
				foreach (ConfigurationProperty configurationProperty in
					Properties)
				{
					string name = configurationProperty.Name;
					if (name == _cDataConfigurationPropertyName)
					{
						string contentString = reader.ReadString();
						base[name] = contentString.Trim();
					}
					else
					{
						string attributeValue = reader.GetAttribute(name);
						base[name] = attributeValue;
					}
				}
				reader.ReadEndElement();
			}
		}
	}
}
