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

		/// <summary>
		/// Gets the current master name.
		/// </summary>
		public string Master
		{
			get
			{
				return this.UseTemplates ? "Templated" : "Site";
			}
		}

		/// <summary>
		/// Determines if the application uses templates
		/// </summary>
		[ConfigurationProperty("useTemplates", IsRequired = true)]
		public bool UseTemplates
		{
			get
			{
				return (bool)this["useTemplates"];
			}
			set
			{
				this["useTemplates"] = value;
			}
		}
	}
}
