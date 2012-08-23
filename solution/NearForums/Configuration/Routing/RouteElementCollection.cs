using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration.Routing
{
	public class RouteElementCollection : ConfigurationElementCollection<RouteElement>
	{
		/// <summary>
		/// Determines if the routes in the collection only match lower case urls (can be override on the route element).
		/// </summary>
		[ConfigurationProperty("lowerCaseOnly")]
		public bool LowerCaseOnly
		{
			get
			{
				return (bool)this["lowerCaseOnly"];
			}
			set
			{
				this["lowerCaseOnly"] = value;
			}
		}
	}
}
