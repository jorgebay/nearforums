using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NearForums.Web.Controllers;
using System.Web.Mvc;
using System.Web.SessionState;
using NearForums.Tests.Fakes;
using NearForums.ServiceClient;
using NearForums.Web.State;
using System.Web.Routing;
using NearForums.Configuration.Routing;
using NearForums.Web.Extensions;
using NearForums.Services;

namespace NearForums.Tests
{
	/// <summary>
	/// Summary description for ForumsControllerTest
	/// </summary>
	[TestClass]
	public class ForumsControllerTest
	{
		public ForumsControllerTest()
		{
			//
			// TODO: Add constructor logic here
			//
		}

		private TestContext testContextInstance;

		/// <summary>
		///Gets or sets the test context which provides
		///information about and functionality for the current test run.
		///</summary>
		public TestContext TestContext
		{
			get
			{
				return testContextInstance;
			}
			set
			{
				testContextInstance = value;
			}
		}

		#region Additional test attributes
		//
		// You can use the following additional attributes as you write your tests:
		//
		// Use ClassInitialize to run code before running the first test in the class
		// [ClassInitialize()]
		// public static void MyClassInitialize(TestContext testContext) { }
		//
		// Use ClassCleanup to run code after all tests in a class have run
		// [ClassCleanup()]
		// public static void MyClassCleanup() { }
		//
		// Use TestInitialize to run code before running each test 
		// [TestInitialize()]
		// public void MyTestInitialize() { }
		//
		// Use TestCleanup to run code after each test has run
		// [TestCleanup()]
		// public void MyTestCleanup() { }
		//
		#endregion

		public static Forum GetAForum()
		{
			Forum forum = null;
			var controller = TestHelper.Resolve<ForumsController>();
			controller.ControllerContext = new FakeControllerContext(controller, "http://localhost");

			controller.List();
			List<ForumCategory> forumCategoryList = (List<ForumCategory>)controller.ViewData.Model;

			if (forumCategoryList.Count == 0)
			{
				Assert.Inconclusive("There are no forum categories to perform this test.");
			}

			foreach (ForumCategory category in forumCategoryList)
			{
				foreach (Forum f in category.Forums)
				{
					forum = f;
					break;
				}
				if (forum != null)
				{
					break;
				}
			}
			if (forum == null)
			{
				Assert.Inconclusive("There are no forums to perform this test.");
			}

			return forum;
		}


		public static ForumCategory GetACategory()
		{
			var categories = ForumsServiceClient.GetCategories();
			if (categories.Count == 0)
			{
				Assert.Inconclusive("There are no forum categories to perform this test.");
			}
			return categories[0];
		}

		public static SessionStateItemCollection GetSessionWithTestUser()
		{
			SessionStateItemCollection sessionItems = new SessionStateItemCollection();
			User user = ServicesTests.GetTestUser();
			sessionItems["User"] = new UserState(user, AuthenticationProvider.Facebook);
			return sessionItems;
		}

		[TestMethod]
		public void Forums_List_Detail()
		{
			var controller = TestHelper.Resolve<ForumsController>();
			controller.ControllerContext = new FakeControllerContext(controller);
			Forum forum = GetAForum();

			controller.ViewData = new ViewDataDictionary();

			controller.Detail(forum.ShortName, 0);

			forum = (Forum)controller.ViewData.Model;

			Assert.IsNotNull(forum);
		}

		[TestMethod]
		public void Forums_Unanswered()
		{
			ForumsController controller = TestHelper.Resolve<ForumsController>();
			controller.ViewData = new ViewDataDictionary();

			Forum forum = GetAForum();

			controller.ListAllUnansweredTopics();
			Assert.IsNotNull(controller.ViewData.Model);

			controller.ListUnansweredTopics(forum.ShortName);
			Assert.IsNotNull(controller.ViewData.Model);
		}
		
		[TestMethod]
		public void Forum_LatestAllTopics()
		{
			var controller = TestHelper.Resolve<ForumsController>();
			controller.ControllerContext = new FakeControllerContext(controller);
			var result = controller.LatestAllTopics();

			Assert.IsInstanceOfType(result, typeof(ViewResult));
		}

		[TestMethod]
		public void Forum_Edit()
		{
			Forum forum = GetAForum();
			ForumsController controller = TestHelper.Resolve<ForumsController>();

			controller.ControllerContext = new FakeControllerContext(controller, "http://localhost", null, null, new System.Collections.Specialized.NameValueCollection(), new System.Collections.Specialized.NameValueCollection(), new System.Web.HttpCookieCollection(), ForumsControllerTest.GetSessionWithTestUser());

			controller.Edit(forum.ShortName);
			forum = (Forum)controller.ViewData.Model;

			ActionResult result = controller.Edit(forum.ShortName, forum);
			Assert.IsTrue(result is RedirectToRouteResult);
		}

		[TestMethod]
		public void Forum_Add_Delete_English()
		{
			Forum forum = new Forum();
			ForumsController controller = TestHelper.Resolve<ForumsController>();
			controller.ControllerContext = new FakeControllerContext(controller, "http://localhost", null, null, new System.Collections.Specialized.NameValueCollection(), new System.Collections.Specialized.NameValueCollection(), new System.Web.HttpCookieCollection(), ForumsControllerTest.GetSessionWithTestUser());

			forum.Name = "Unit test forum";
			forum.Description = forum.Name + "... description.";
			forum.Category = GetACategory();

			var result = controller.Add(forum);
			Assert.IsTrue(result is RedirectToRouteResult);

			result = controller.Delete(forum.ShortName);
			Assert.IsTrue(result is RedirectToRouteResult);
		}

		[TestMethod]
		public void Forum_Add_Delete_Thai()
		{
			Forum forum = new Forum();
			ForumsController controller = TestHelper.Resolve<ForumsController>();
			controller.ControllerContext = new FakeControllerContext(controller, "http://localhost", null, null, new System.Collections.Specialized.NameValueCollection(), new System.Collections.Specialized.NameValueCollection(), new System.Web.HttpCookieCollection(), ForumsControllerTest.GetSessionWithTestUser());

			forum.Name = "ถ้า";
			forum.Description = forum.Name + "... description.";
			forum.Category = GetACategory();

			var result = controller.Add(forum);
			Assert.IsTrue(result is RedirectToRouteResult);

			result = controller.Delete(forum.ShortName);
			Assert.IsTrue(result is RedirectToRouteResult);

			#region Test routing with the forum in Thai
			var routes = new RouteCollection();
			var routesConfig = RouteMappingConfiguration.Current;

			RoutingHelper.RegisterRoutes(routes, routesConfig);


			TestHelper.AssertVirtualPathNotNull(routes, new
			{
				controller = "Forums",
				action = "DetailNotConstrained",
				forum = forum.ShortName
			}); 
			#endregion

		}

	}
}
