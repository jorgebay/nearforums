using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	public class RouteElement : ConfigurationElement
	{
		//Url
		[ConfigurationProperty("url", IsRequired = true)]
		public string Url
		{
			get
			{
				return (string)this["url"];
			}
			set
			{
				this["url"] = value;
			}
		}
		//Controller
		[ConfigurationProperty("controller", IsRequired = true)]
		public string Controller
		{
			get
			{
				return (string)this["controller"];
			}
			set
			{
				this["controller"] = value;
			}
		}
		//Action
		[ConfigurationProperty("action", IsRequired = true)]
		public string Action
		{
			get
			{
				return (string)this["action"];
			}
			set
			{
				this["action"] = value;
			}
		}

		[ConfigurationProperty("defaults", IsRequired = false)]
		public KeyValueConfigurationCollection Defaults
		{
			get
			{
				return (KeyValueConfigurationCollection)this["defaults"];
			}
			set
			{
				this["defaults"] = value;
			}
		}

		[ConfigurationProperty("constraints", IsRequired = false)]
		public KeyValueConfigurationCollection Constraints
		{
			get
			{
				return (KeyValueConfigurationCollection)this["constraints"];
			}
			set
			{
				this["constraints"] = value;
			}
		}
	}
}
