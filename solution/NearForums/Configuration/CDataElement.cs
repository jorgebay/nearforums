using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration.Notifications
{
	/// <summary>
	/// CData configuration element. Represents an elements that xml/html values. Use ToString() method or Value property to get the value.
	/// </summary>
	public class CDataElement
		: CDataConfigurationElement
	{
		[ConfigurationProperty("value", IsRequired = true)]
		[CDataConfigurationProperty]
		public string Value
		{
			get
			{
				return (string)(base["value"]);
			}
			set
			{
				base["value"] = value;
			}
		}

		/// <summary>
		/// Returns the value of the cdata
		/// </summary>
		/// <returns></returns>
		public override string ToString()
		{
			return this.Value;
		}

		protected override bool SerializeElement(System.Xml.XmlWriter writer, bool serializeCollectionKey)
		{
			return base.SerializeElement(writer, serializeCollectionKey);
		}

		protected override void PreSerialize(System.Xml.XmlWriter writer)
		{
			base.PreSerialize(writer);
		}

		protected override bool SerializeToXmlElement(System.Xml.XmlWriter writer, string elementName)
		{
			return base.SerializeToXmlElement(writer, elementName);
		}

		public override bool IsReadOnly()
		{
			return false;
		}
	}
}
