using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	public class TemplateElement : ConfigurationElement
	{
		/// <summary>
		/// Determines if the application uses templates
		/// </summary>
		[ConfigurationProperty("useTemplates", DefaultValue=true)]
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

		/// <summary>
		/// Determines if the application uses mobile templates
		/// </summary>
		[ConfigurationProperty("mobile", IsRequired = false)]
		public TemplateMobileElement Mobile
		{
			get
			{
				return (TemplateMobileElement)this["mobile"];
			}
			set
			{
				this["mobile"] = value;
			}
		}
	}
}
