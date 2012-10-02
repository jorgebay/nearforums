using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration.Spam
{
	/// <summary>
	/// Represents the configuration element for the spam prevention features
	/// </summary>
	public class SpamPreventionElement : BaseConfigurationElement
	{
		/// <summary>
		/// Gets or sets the configuration for flood control inside the forum
		/// </summary>
		[ConfigurationProperty("floodControl", IsRequired = false)]
		public FloodControlElement FloodControl
		{
			get
			{
				return (FloodControlElement)this["floodControl"];
			}
			set
			{
				this["floodControl"] = value;
			}
		}

		/// <summary>
		/// Rules for the html entered by the user.
		/// </summary>
		[ConfigurationProperty("htmlInput", IsRequired = false)]
		public HtmlInputElement HtmlInput
		{
			get
			{
				return (HtmlInputElement)this["htmlInput"];
			}
			set
			{
				this["htmlInput"] = value;
			}
		}
	}
}
