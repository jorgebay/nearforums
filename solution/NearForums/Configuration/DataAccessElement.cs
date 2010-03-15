using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	public class DataAccessElement : ConfigurationElement
	{
		[ConfigurationProperty("parameterPrefix", IsRequired = false)]
		public string ParameterPrefix
		{
			get
			{
				return (string)this["parameterPrefix"];
			}
			set
			{
				this["parameterPrefix"] = value;
			}
		}
	}
}
