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
		[ConfigurationProperty("value", IsRequired = true, IsKey = true)]
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
	}
}
