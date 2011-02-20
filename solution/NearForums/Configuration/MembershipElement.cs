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
	public class MembershipElement : ConfigurationElement, IOptionalElement
	{
		/// <summary>
		/// 
		/// </summary>
		[ConfigurationProperty("defined", IsRequired = false)]
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
	}
}
