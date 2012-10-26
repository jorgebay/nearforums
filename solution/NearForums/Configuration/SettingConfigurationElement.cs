using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.IO;
using System.Xml;
using NearForums.Validation;

namespace NearForums.Configuration
{
	/// <summary>
	/// Represents a configuration element
	/// </summary>
	public abstract class SettingConfigurationElement : ConfigurationElement, IEnsureValidation
	{
		public SettingConfigurationElement()
		{

		}

		public void Deserialize(StringBuilder input)
		{
			using (var xmlReader = XmlTextReader.Create(new StringReader(input.ToString())))
			{
				//enter the first element
				xmlReader.Read();
				base.DeserializeElement(xmlReader, false);
			}
		}

		/// <summary>
		/// Serialize the instance into text
		/// </summary>
		/// <param name="stream">The stream to output the text</param>
		public void Serialize(StringBuilder output, string elementName)
		{
			var writerSettings = new XmlWriterSettings()
			{
				ConformanceLevel = ConformanceLevel.Fragment,
				Encoding = Encoding.UTF8,
				Indent = true
			};
			using (var writer = XmlTextWriter.Create(output, writerSettings))
			{
				base.SerializeToXmlElement(writer, elementName);
			}
		}

		/// <summary>
		/// Gets an editable copy of the object
		/// </summary>
		/// <returns></returns>
		public T GetEditable<T>() where T : SettingConfigurationElement, new()
		{
			var builder = new StringBuilder();

			var writerSettings = new XmlWriterSettings()
			{
				ConformanceLevel = ConformanceLevel.Fragment,
				Encoding = Encoding.UTF8,
			};
			using (var writer = XmlTextWriter.Create(builder, writerSettings))
			{
				base.SerializeToXmlElement(writer, "setting");
			}
			
			var editableObject = new T();
			if (builder.Length > 0)
			{
				using (var xmlReader = XmlTextReader.Create(new StringReader(builder.ToString())))
				{
					//enter the first element
					xmlReader.Read();
					editableObject.DeserializeElement(xmlReader, false);
				}
			}
			return editableObject;
		}

		public override bool IsReadOnly()
		{
			//Within the application, the configuration elements are not read only
			return false;
		}

		public abstract void ValidateFields();
	}
}
