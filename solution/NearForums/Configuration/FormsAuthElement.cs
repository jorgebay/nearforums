using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	/// <summary>
	/// Represents a configuration element for Forms Authentication
	/// </summary>
	public class FormsAuthElement : ConfigurationElement, IOptionalElement
	{
		[ConfigurationProperty("defined", IsRequired = true)]
		public bool Identifier
		{
			get
			{
				return (bool)this["defined"];
			}
			set
			{
				this["defined"] = value;
			}
		}

		/// <summary>
		/// Determines if the provider required data has been defined.
		/// </summary>
		public bool IsDefined
		{
			get
			{
				return this.Identifier;
			}
		}

		/// <summary>
		/// Determines the expiration time out (in hours) of the reset password link.
		/// </summary>
		[ConfigurationProperty("timeToExpireResetPasswordLink", DefaultValue=24)]
		public int TimeToExpireResetPasswordLink
		{
			get
			{
				return (int)this["timeToExpireResetPasswordLink"];
			}
			set
			{
				this["timeToExpireResetPasswordLink"] = value;
			}
		}
	}
}
