using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NearForums.Web.Extensions;
using NearForums.Configuration;
using NearForums.Configuration.Routing;
using System.Web;
using System.Text.RegularExpressions;
using NearForums.Web.Output;
using System.Web.Routing;
using NearForums.Tests.Fakes;

namespace NearForums.Tests.Routing
{
	[TestClass]
	public class RoutingHelperTest
	{
		[TestMethod]
		public void RoutingHelper_Basic_Test()
		{
			var routes = new RouteCollection();
			var routesConfig = RouteMappingConfiguration.Current;

			RoutingHelper.RegisterRoutes(routes, routesConfig);

			TestHelper.AssertIsRouteOf(routes, "/some-forum/", new
			{
				controller = "Forums",
				action = "Detail"
			});
			TestHelper.AssertIsRouteOf(routes, "/some-forum/1", new
			{
				controller = "Forums",
				action = "Detail"
			});
			TestHelper.AssertIsNotRouteOf(routes, "/some-forum/1?some=value", new
			{
				controller = "What",
				action = "TheF"
			});
		}

		[TestMethod]
		public void RoutingHelper_NonAscii_Test()
		{
			var routes = new RouteCollection();
			var routesConfig = RouteMappingConfiguration.Current;

			RoutingHelper.RegisterRoutes(routes, routesConfig);

			TestHelper.AssertIsRouteOf(routes, "/forum-detail/whatever/", new
			{
				controller = "Forums",
				action = "DetailNotConstrained"
			});
			TestHelper.AssertIsRouteOf(routes, "/forum-detail/" + "เที่ยวไทย".ToUrlSegment(32) + "/", new
			{
				controller = "Forums",
				action = "DetailNotConstrained"
			});
		}
	}
}
