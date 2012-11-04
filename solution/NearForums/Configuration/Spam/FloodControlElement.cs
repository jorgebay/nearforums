using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration.Spam
{
	/// <summary>
	/// Represents the configuration element for the flood control features
	/// </summary>
	public class FloodControlElement : ConfigurationElement
	{
		/// <summary>
		/// Time (in minutes) required to pass between postings
		/// </summary>
		[ConfigurationProperty("timeBetweenPosts", DefaultValue = 5D)]
		public double TimeBetweenPosts
		{
			get
			{
				return (double)this["timeBetweenPosts"];
			}
			set
			{
				this["timeBetweenPosts"] = value;
			}
		}

		/// <summary>
		/// Determines the role for which the flood control rules are ignored
		/// </summary>
		[ConfigurationProperty("ignoreForRole", DefaultValue=UserRole.Admin)]
		public UserRole IgnoreForRole
		{
			get
			{
				return (UserRole)this["ignoreForRole"];
			}
			set
			{
				this["ignoreForRole"] = value;
			}
		}

		public override bool IsReadOnly()
		{
			return false;
		}
	}
}
