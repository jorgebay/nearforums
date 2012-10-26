using System;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Mvc;
using Autofac;
using Autofac.Integration.Mvc;
using NearForums.Configuration;
using NearForums.Configuration.Integration;
using NearForums.Configuration.Settings;
using NearForums.DataAccess;
using NearForums.Web.Controllers;
using NearForums.Web.Integration;

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
			builder.RegisterType<DatabaseSettingsRepository>()
				.As<ISettingsRepository>()
				.InstancePerDependency();
			var container = builder.Build();
			DependencyResolver.SetResolver(new AutofacDependencyResolver(container));

			//Inject configuration dependencies
			SiteConfiguration.SettingsRepository = container.Resolve<ISettingsRepository>();
			SiteConfiguration.PathResolver = context.Server.MapPath;
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