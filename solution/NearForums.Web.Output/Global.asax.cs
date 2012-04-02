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
using Autofac;
using Autofac.Integration.Mvc;
using System.Reflection;

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
			AreaRegistration.RegisterAllAreas();

			RegisterGlobalFilters(GlobalFilters.Filters);
			RegisterRoutes(RouteTable.Routes);

			//Inject as a dependency
			SiteConfiguration.Current.PathResolver = Server.MapPath;

			//Set Autofac as dependency resolver
			var builder = new ContainerBuilder();
			builder.RegisterAssemblyTypes(Assembly.Load("NearForums.DataAccess"))
				.Where(t => t.Name.EndsWith("DataAccess"))
				.AsImplementedInterfaces()
				.InstancePerDependency();
			builder.RegisterAssemblyTypes(Assembly.Load("NearForums.Services"))
				.Where(t => t.Name.EndsWith("Service"))
				.AsImplementedInterfaces()
				.InstancePerDependency();
			builder.RegisterControllers(typeof(BaseController).Assembly);
			var container = builder.Build();
			DependencyResolver.SetResolver(new AutofacDependencyResolver(container));
		}
	}
}