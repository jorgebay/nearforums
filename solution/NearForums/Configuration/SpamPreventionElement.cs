using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	public class SpamPreventionElement : ConfigurationElement
	{
		/// <summary>
		/// Time (in minutes) required to pass between postings
		/// </summary>
		[ConfigurationProperty("timeToRepost", IsRequired = false)]
		public int TimeToRepost
		{
			get
			{
				return (int)this["timeToRepost"];
			}
			set
			{
				this["timeToRepost"] = value;
			}
		}

		//Probably this class will hold Html Sanitizer whitelists...
	}
}
