using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	public class TemplateElement : ConfigurationElement
	{
		[ConfigurationProperty("path", IsRequired = false)]
		public string Path
		{
			get
			{
				return (string)this["path"];
			}
			set
			{
				this["path"] = value;
			}
		}

		[ConfigurationProperty("master", IsRequired = true)]
		public string Master
		{
			get
			{
				return (string)this["master"];
			}
			set
			{
				this["master"] = value;
			}
		}
	}
}
