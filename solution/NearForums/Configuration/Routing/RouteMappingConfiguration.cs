using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration.Routing
{
	public class RouteMappingConfiguration : ConfigurationSection
	{
		public static RouteMappingConfiguration Current
		{
			get
			{
				return (RouteMappingConfiguration)ConfigurationManager.GetSection("routeMapping");
			}
		}

		#region Props
		[ConfigurationProperty("routes", IsRequired = true)]
		public RouteElementCollection Routes
		{
			get
			{
				return (RouteElementCollection)this["routes"];
			}
			set
			{
				this["routes"] = value;
			}
		}

		[ConfigurationProperty("ignoreRoutes", IsRequired = true)]
		public RouteElementCollection IgnoreRoutes
		{
			get
			{
				return (RouteElementCollection)this["ignoreRoutes"];
			}
			set
			{
				this["ignoreRoutes"] = value;
			}
		} 
		#endregion
	}
}
