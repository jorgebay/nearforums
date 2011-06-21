using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Routing;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Web;
using NearForums.Tests.Fakes;

namespace NearForums.Tests
{
	public static class TestHelper
	{
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
	}
}
