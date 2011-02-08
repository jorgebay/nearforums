using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Routing;
using NearForums.Configuration;
using System.Web.Mvc;
using NearForums.Web.Routing;

namespace NearForums.Web.Modules
{
	public class RouteMappingModule : IHttpModule
	{
		#region IHttpModule Members
		public void Dispose()
		{

		}

		static object lockObject = new object();
		static bool initialized = false;

		public void Init(HttpApplication context)
		{
			//prevent init calls in multiple HttpApplications
			if (!initialized)
			{
				lock (lockObject)
				{
					if (!initialized)
					{
						initialized = true;

						RouteMappingConfiguration config = RouteMappingConfiguration.Current;
						using (RouteTable.Routes.GetWriteLock())
						{
							RegisterRoutes(RouteTable.Routes, config);
						}
					}
				}
			}
		}
		#endregion

		#region Register routes
		public static void RegisterRoutes(RouteCollection routes, RouteMappingConfiguration config)
		{
			if (config == null) 
			{
				throw new NullReferenceException("Route mapping configuration not defined.");
			}

			foreach (RouteElement ignoreItem in config.IgnoreRoutes)
			{
				routes.IgnoreRoute(ignoreItem.Url);
			}

			foreach (RouteElement item in config.Routes)
			{
				StrictRoute route = new StrictRoute(item.Url, new MvcRouteHandler());
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
						route.Constraints.Add(key, item.Constraints[key].Value);
					}
				}
				if (item.Namespace != null)
				{
					if (route.DataTokens == null)
					{
						route.DataTokens = new RouteValueDictionary();
					}
					route.DataTokens["Namespaces"] = new string[]{item.Namespace};

				}
				routes.Add(route);
			}
		}
		#endregion
	}
}
