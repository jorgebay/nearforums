using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.Security;
using NearForums.Configuration;
using NearForums.Web.Controllers.Helpers;
using NearForums.Web.Modules;
using NearForums.Configuration.Routing;
using NearForums.Web.Controllers;
using NearForums.Web.Extensions;

namespace NearForums.Web.Output
{
	// Note: For instructions on enabling IIS6 or IIS7 classic mode, 
	// visit http://go.microsoft.com/?LinkId=9394801

	public class MvcApplication : System.Web.HttpApplication
	{
		public static void RegisterGlobalFilters(GlobalFilterCollection filters)
		{
			filters.Add(new HandleErrorAttribute());
		}

		public static void RegisterRoutes(RouteCollection routes)
		{
			//Routes are not registered on the Global.asax.cs file
			//Routes are registered at: NearForums.Web.Extensions.RoutingHelper
			//Routes are configured at: Config\Routes.config

			RoutingHelper.RegisterRoutes(RouteTable.Routes, RouteMappingConfiguration.Current);
		}

		protected void Application_Start()
		{
			AreaRegistration.RegisterAllAreas();

			RegisterGlobalFilters(GlobalFilters.Filters);
			RegisterRoutes(RouteTable.Routes);

			SiteConfiguration.Current.AuthorizationProviders.FormsAuth.IsFormsAuthDefined = WebConfigHelper.IsFormsAuthenticationEnabled;
		}

		protected void Application_AuthenticateRequest()
		{
			if (SiteConfiguration.Current.AuthorizationProviders.FormsAuth.IsDefined == true && HttpContext.Current.User != null)
			{
				Membership.GetUser(true);
			}
		}
	}
}