using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	public class RouteElement : ConfigurationElement
	{

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

		[ConfigurationProperty("namespace", IsRequired = false)]
		public string Namespace
		{
			get
			{
				return (string)this["namespace"];
			}
			set
			{
				this["namespace"] = value; 
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
