using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	/// <summary>
	/// Represents a configuration element for an authentication provider based on Key and Secret
	/// </summary>
	public class KeySecretElement : ConfigurationElement, IOptionalElement
	{
		[ConfigurationProperty("apiKey", IsRequired = true)]
		public string ApiKey
		{
			get
			{
				return (string)this["apiKey"];
			}
			set
			{
				this["apiKey"] = value;
			}
		}

		[ConfigurationProperty("secretKey", IsRequired = true)]
		public string SecretKey
		{
			get
			{
				return (string)this["secretKey"];
			}
			set
			{
				this["secretKey"] = value;
			}
		}

		/// <summary>
		/// Determines if the provider required data has been defined.
		/// </summary>
		public bool IsDefined
		{
			get
			{
				return (!String.IsNullOrEmpty(this.ApiKey)) && (!String.IsNullOrEmpty(this.SecretKey));
			}
		}
	}
}
