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
using System.Web.Mvc;

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
			//Case sensitivity
			TestHelper.AssertIsNotRouteOf(routes, "/some-Forum/", new
			{
				controller = "Forums",
				action = "Detail"
			});
			//Case sensitivity
			TestHelper.AssertIsRouteOf(routes, "/some-forum/", new
			{
				controller = "Forums",
				action = "Detail",
				forum = "Some Forum".ToUrlSegment()
			});
			//Complete with ascii
			TestHelper.AssertIsRouteOf(routes, "/awesome-job-my-man/", new
			{
				controller = "Forums",
				action = "Detail",
				forum = "AWESOME Job     my    man!!!!!!!!".ToUrlSegment()
			});
		}

		[TestMethod]
		public void RoutingHelper_NonAscii_Test()
		{
			var routes = new RouteCollection();
			var routesConfig = RouteMappingConfiguration.Current; //Load from app.config

			RoutingHelper.RegisterRoutes(routes, routesConfig);

			TestHelper.AssertIsRouteOf(routes, "/forum-detail/whatever/", new
			{
				controller = "Forums",
				action = "DetailNotConstrained"
			});
			TestHelper.AssertVirtualPathNotNull(routes, new
			{
				controller = "Forums",
				action = "DetailNotConstrained",
				forum = "whatever"
			});

			//back and fw
			string url = TestHelper.AssertVirtualPathNotNull(routes, new
			{
				controller = "Forums",
				action = "DetailNotConstrained",
				forum = "เที่ยวไทย".ToUrlSegment(32)
			});
			TestHelper.AssertIsRouteOf(routes, url, new
			{
				controller = "Forums",
				action = "DetailNotConstrained"
			});
		}

		[TestMethod]
		public void RoutingHelper_Segment_Tests()
		{
			Assert.AreEqual("yeah", "YEAH!!!!!".ToUrlSegment());
			Assert.AreEqual("oh-yeah", "OH YEAH".ToUrlSegment());
		}
	}
}
