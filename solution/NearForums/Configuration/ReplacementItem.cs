using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.Text.RegularExpressions;

namespace NearForums.Configuration
{
	public class ReplacementItem : ConfigurationElement, IReplacement, IUniqueConfigurationElement
	{
		[ConfigurationProperty("pattern", IsRequired = true)]
		public string Pattern
		{
			get
			{
				return (string)this["pattern"];
			}
			set
			{
				this["pattern"] = value;
			}
		}

		[ConfigurationProperty("replacement", IsRequired = false)]
		public string Replacement
		{
			get
			{
				return (string)this["replacement"];
			}
			set
			{
				this["replacement"] = value;
			}
		}

		/// <summary>
		/// Determines if the regex should be executed in ignoreCase mode
		/// </summary>
		[ConfigurationProperty("ignoreCase", IsRequired = false)]
		public bool IgnoreCase
		{
			get
			{
				return (bool)this["ignoreCase"];
			}
			set
			{
				this["ignoreCase"] = value;
			}
		}

		/// <summary>
		/// Determines if the regex should be executed in multiline mode
		/// </summary>
		[ConfigurationProperty("multiline", IsRequired = false)]
		public bool Multiline
		{
			get
			{
				return (bool)this["multiline"];
			}
			set
			{
				this["multiline"] = value;
			}
		}

		public RegexOptions RegexOptions
		{
			get
			{
				RegexOptions options = this.IgnoreCase ? RegexOptions.IgnoreCase : RegexOptions.None;
				options = options | (this.Multiline ? RegexOptions.Singleline : RegexOptions.None);
				return options;
			}
		}

		#region IUniqueConfigurationElement Members
		public string Key
		{
			get 
			{ 
				return Pattern; 
			}
		}
		#endregion
	}
}
