using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.Configuration.Routing;
using System.Web.Routing;
using NearForums.Web.Routing;
using System.Web.Mvc;

namespace NearForums.Web.Extensions
{
	public static class RoutingHelper
	{
		#region Register routes
		/// <summary>
		/// Registers routes specified in current routemapping configuration
		/// </summary>
		public static void RegisterRoutes(RouteCollection routes)
		{
			var config = RouteMappingConfiguration.Current;
			RegisterRoutes(routes, config);
		}

		/// <summary>
		/// Register all routes defined in the RouteMappingConfiguration
		/// </summary>
		/// <param name="routes">RouteCollection to add routes</param>
		/// <param name="config">Routes to register</param>
		public static void RegisterRoutes(RouteCollection routes, RouteMappingConfiguration config)
		{
			if (config == null)
			{
				throw new NullReferenceException("Route mapping configuration not defined.");
			}
			using (routes.GetWriteLock())
			{
				foreach (RouteElement ignoreItem in config.IgnoreRoutes)
				{
					routes.IgnoreRoute(ignoreItem.Url);
				}

				foreach (RouteElement item in config.Routes)
				{
					var lowerCaseOnly = item.LowerCaseOnly == null ? config.Routes.LowerCaseOnly : item.LowerCaseOnly.Value;

					var route = new StrictRoute(item.Url, new MvcRouteHandler(), lowerCaseOnly);
					route.Defaults = new RouteValueDictionary();
					route.Defaults.Add("Controller", item.Controller);
					route.Defaults.Add("Action", item.Action);
					if (item.Defaults != null)
					{
						foreach (string key in item.Defaults.AllKeys)
						{
							route.Defaults.Add(key, item.Defaults[key].Value);
						}
					}
					if (item.Constraints != null)
					{
						route.Constraints = new RouteValueDictionary();
						foreach (string key in item.Constraints.AllKeys)
						{
							route.Constraints.Add(key, new RegexConstraint(item.Constraints[key].Value));
						}
					}
					if (item.Namespace != null)
					{
						if (route.DataTokens == null)
						{
							route.DataTokens = new RouteValueDictionary();
						}
						route.DataTokens["Namespaces"] = new string[] { item.Namespace };

					}
					routes.Add(route);
				}
			}
		}
		#endregion
	}
}
