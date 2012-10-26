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
		/// Determines if the html entered by the user should be parsed and fix html errors like unclosed elements / hierarchy / ...
		/// </summary>
		[ConfigurationProperty("fixErrors", DefaultValue=true)]
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

		/// <summary>
		///
		/// </summary>
		[ConfigurationProperty("allowedElements", DefaultValue = "b(lockquote)?|code|d(d|t|l|el)|em|h(2|3|4)|i|kbd|li|ol|p(re)?|s(ub|up|trong|trike)?|ul|a|img")]
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
	}
}
