using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Routing;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Web;
using NearForums.Tests.Fakes;
using Autofac;
using System.Reflection;
using NearForums.Web.Controllers;

namespace NearForums.Tests
{
	public static class TestHelper
	{
		private static IContainer _container;
		public static IContainer Container
		{
			get
			{
				if (_container == null)
				{
					var builder = new ContainerBuilder();
					builder.RegisterAssemblyTypes(Assembly.Load("NearForums.DataAccess"))
						.Where(t => t.Name.EndsWith("DataAccess"))
						.AsImplementedInterfaces()
						.InstancePerDependency();
					builder.RegisterAssemblyTypes(Assembly.Load("NearForums.Services"))
						.Where(t => t.Name.EndsWith("Service"))
						.AsImplementedInterfaces()
						.InstancePerDependency();
					builder.RegisterAssemblyTypes(typeof(BaseController).Assembly)
						.Where(t => t.Name.EndsWith("Controller"))
						.InstancePerDependency();
					var container = builder.Build();
					_container = container;
				}
				return _container;
			}
		}

		public static T Resolve<T>()
		{
			return Container.Resolve<T>();
		}

		public static void AssertIsRouteOf(RouteCollection routes, string url, object expectations)
		{
			var httpContext = new FakeHttpContext("http://localhost");
			((FakeHttpRequest)httpContext.Request).SetUri(new Uri(new Uri("http://localhost"), url).ToString());
			RouteData routeData = routes.GetRouteData(httpContext);
			Assert.IsNotNull(routeData, "Route not found");

			foreach (KeyValuePair<string, object> property in new RouteValueDictionary(expectations))
			{
				Assert.IsTrue(string.Equals(property.Value.ToString(),
					routeData.Values[property.Key].ToString(),
					StringComparison.OrdinalIgnoreCase)
					, string.Format("Expected '{0}', not '{1}' for '{2}'.",
					property.Value, routeData.Values[property.Key], property.Key));
			}
		}

		public static void AssertIsNotRouteOf(RouteCollection routes, string url, object expectations)
		{
			var httpContext = new FakeHttpContext("http://localhost");
			((FakeHttpRequest)httpContext.Request).SetUri(new Uri(new Uri("http://localhost"), url).ToString());
			RouteData routeData = routes.GetRouteData(httpContext);
			if (routeData != null)
			{
				foreach (KeyValuePair<string, object> property in new RouteValueDictionary(expectations))
				{
					Assert.IsFalse(string.Equals(property.Value.ToString(),
						routeData.Values[property.Key].ToString(),
						StringComparison.OrdinalIgnoreCase)
						, string.Format("Expected '{0}' not to match '{1}' for '{2}'.",
						property.Value, routeData.Values[property.Key], property.Key));
				}
			}
		}

		public static string AssertVirtualPathNotNull(RouteCollection routes, object routeValues)
		{
			var httpContext = new FakeHttpContext("http://localhost");
			((FakeHttpRequest)httpContext.Request).SetUri(new Uri(new Uri("http://localhost"), "/").ToString());

			var virtualPath = routes.GetVirtualPath(new RequestContext(httpContext, new RouteData()), new RouteValueDictionary(routeValues));

			Assert.IsNotNull(virtualPath);
			return virtualPath.VirtualPath;
		}
	}
}
