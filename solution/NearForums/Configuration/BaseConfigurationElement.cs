﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.IO;
using System.Xml;

namespace NearForums.Configuration
{
	/// <summary>
	/// Represents a configuration element
	/// </summary>
	public abstract class BaseConfigurationElement : ConfigurationElement
	{
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

		public override bool IsReadOnly()
		{
			//Within the application, the configuration elements are not read only
			return false;
		}
	}
}
