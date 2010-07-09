using System;
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
	}
}
