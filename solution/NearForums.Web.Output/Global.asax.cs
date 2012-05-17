using System.Web.Mvc;
using System.Web.Routing;
using NearForums.Configuration;
using NearForums.Configuration.Routing;
using NearForums.Web.Controllers;
using NearForums.Web.Extensions;
using Autofac;
using Autofac.Integration.Mvc;
using System.Reflection;
using System.Web;

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
			//Routes are registered using: NearForums.Web.Extensions.RoutingHelper
			//Routes are configured at: Config\Routes.config

			RoutingHelper.RegisterRoutes(RouteTable.Routes, RouteMappingConfiguration.Current);
		}

		protected void Application_Start()
		{
			DependenciesHelper.Register(new HttpContextWrapper(Context));

			AreaRegistration.RegisterAllAreas();

			RegisterGlobalFilters(GlobalFilters.Filters);
			RegisterRoutes(RouteTable.Routes);
		}
	}
}