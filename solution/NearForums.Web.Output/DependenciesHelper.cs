using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using NearForums.Configuration;
using Autofac;
using System.Reflection;
using NearForums.Web.Controllers;
using Autofac.Integration.Mvc;
using System.Web.Mvc;
using NearForums.Web.Controllers.Filters;
using NearForums.Web.Integration;
using NearForums.Configuration.Integration;

namespace NearForums.Web.Output
{
	public static class DependenciesHelper
	{
		/// <summary>
		/// Registers all types and sets the resolver for the dependencies
		/// </summary>
		/// <param name="context"></param>
		public static void Register(HttpContextBase context)
		{
			//Inject as a dependency
			SiteConfiguration.Current.PathResolver = context.Server.MapPath;

			//Set Autofac as dependency resolver
			var builder = new ContainerBuilder();
			builder.RegisterIntegrationServices();
			builder.RegisterAssemblyTypes(Assembly.Load("NearForums.DataAccess"))
				.Where(t => t.Name.EndsWith("DataAccess"))
				.AsImplementedInterfaces()
				.InstancePerDependency();
			builder.RegisterAssemblyTypes(Assembly.Load("NearForums.Services"))
				.Where(t => t.Name.EndsWith("Service"))
				.AsImplementedInterfaces()
				.PropertiesAutowired()
				.InstancePerDependency();
			builder.RegisterNearforumsFilterProvider();
			builder.RegisterControllers(typeof(BaseController).Assembly)
				.PropertiesAutowired();
			var container = builder.Build();
			DependencyResolver.SetResolver(new AutofacDependencyResolver(container));
		}

		/// <summary>
		/// Registers the <see cref="NearForumsFilterProvider"/>.
		/// </summary>
		/// <param name="builder">current container builder</param>
		public static void RegisterNearforumsFilterProvider(this ContainerBuilder builder)
		{
			if (builder == null)
			{ 
				throw new ArgumentNullException("builder"); 
			}
			foreach (var provider in FilterProviders.Providers.OfType<FilterAttributeFilterProvider>().ToArray())
			{
				FilterProviders.Providers.Remove(provider);
			}
			builder.RegisterType<NearForumsFilterProvider>()
				.As<IFilterProvider>()
				.SingleInstance();
		}

		/// <summary>
		/// Registers all the services defined on the integration (NearForums extensions) configuration
		/// </summary>
		/// <param name="builder"></param>
		public static void RegisterIntegrationServices(this ContainerBuilder builder)
		{
			foreach (var service in IntegrationConfiguration.Current.Services)
			{
				var registration = builder.RegisterType(service.Type)
					.PropertiesAutowired()
					.InstancePerDependency();
				if (service.As != null)
				{
					//Configure the services that the component will provide
					registration.As(service.As);
				}
			}
		}
	}
}