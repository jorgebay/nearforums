using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	public class AuthenticationProvidersElement : ConfigurationElement
	{
		[ConfigurationProperty("facebook", IsRequired = false)]
		public KeySecretElement Facebook
		{
			get
			{
				return (KeySecretElement)this["facebook"];
			}
			set
			{
				this["facebook"] = value;
			}
		}

		[ConfigurationProperty("twitter", IsRequired = false)]
		public KeySecretElement Twitter
		{
			get
			{
				return (KeySecretElement)this["twitter"];
			}
			set
			{
				this["twitter"] = value;
			}
		}

		[ConfigurationProperty("ssoOpenid", IsRequired = false)]
		public SSOOpenIdElement SSOOpenId
		{
			get
			{
				return (SSOOpenIdElement)this["ssoOpenid"];
			}
			set
			{
				this["ssoOpenid"] = value;
			}
		}

		[ConfigurationProperty("formsAuth", IsRequired = false)]
		public FormsAuthElement FormsAuth
		{
			get
			{
				return (FormsAuthElement)this["formsAuth"];
			}
			set
			{
				this["formsAuth"] = value;
			}
		}

		[ConfigurationProperty("customDb", IsRequired = false)]
		public CustomDbAuthenticationProviderElement CustomDb
		{
			get
			{
				return (CustomDbAuthenticationProviderElement)this["customDb"];
			}
			set
			{
				this["customDb"] = value;
			}
		}

		/// <summary>
		/// Determines if a provider is faked by the application, in order to enable registration/login without real connectivity to a provider.
		/// </summary>
		[ConfigurationProperty("fakeProvider", IsRequired = false, DefaultValue = false)]
		public bool FakeProvider
		{
			get
			{
				return (bool)this["fakeProvider"];
			}
			set
			{
				this["fakeProvider"] = value;
			}
		}
	}
}
