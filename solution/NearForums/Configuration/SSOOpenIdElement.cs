using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	/// <summary>
	/// Represents a configuration element for Open Id relying party
	/// </summary>
	public class SSOOpenIdElement : ConfigurationElement
	{
		/// <summary>
		/// Use this property for fixed identifiers for custom sso like login.yoursite.com
		/// </summary>
		[ConfigurationProperty("identifier", IsRequired = false)]
		public string Identifier
		{
			get
			{
				return (string)this["identifier"];
			}
			set
			{
				this["identifier"] = value;
			}
		}

		/// <summary>
		/// Determines if the provider required data has been defined.
		/// </summary>
		public bool IsDefined
		{
			get
			{
				return !String.IsNullOrEmpty(this.Identifier);
			}
		}
	}
}
