﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	public class AuthorizationProvidersElement : ConfigurationElement
	{
		[ConfigurationProperty("facebook", IsRequired = false)]
		public AuthorizationProviderDetailElement Facebook
		{
			get
			{
				return (AuthorizationProviderDetailElement)this["facebook"];
			}
			set
			{
				this["facebook"] = value;
			}
		}

		/// <summary>
		/// Determines if a provider is faked by the application, in order to enable registration/login without real connectivity to a provider.
		/// </summary>
		[ConfigurationProperty("fakeProvider", IsRequired = false, DefaultValue=false)]
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