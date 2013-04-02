using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration.Spam
{
	public class HtmlInputElement : ConfigurationElement
	{
		/// <summary>
		/// A regex of a allowed elements for the user to input, for example: p|ul|li|strong|em
		/// </summary>
		[ConfigurationProperty("allowedElements", DefaultValue = "b(lockquote)?|code|d(d|t|l|el)|em|h(2|3|4)|i|kbd|li|ol|p(re)?|s(ub|up|trong|trike)?|ul")]
		public string AllowedElements
		{
			get
			{
				return (string)this["allowedElements"];
			}
			set
			{
				this["allowedElements"] = value;
			}
		}

		/// <summary>
		/// Determine for which role (or higher) the system does not perform html validation
		/// </summary>
		[ConfigurationProperty("avoidValidationForRole", DefaultValue = null)]
		public UserRole? AvoidValidationForRole
		{
			get
			{
				return (UserRole?)this["avoidValidationForRole"];
			}
			set
			{
				this["avoidValidationForRole"] = value;
			}
		}

		[ConfigurationProperty("fixErrors", DefaultValue = true)]
		public bool FixErrors
		{
			get
			{
				return (bool)this["fixErrors"];
			}
			set
			{
				this["fixErrors"] = value;
			}
		}
	}
}
