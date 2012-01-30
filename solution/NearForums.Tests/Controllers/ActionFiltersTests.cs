using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NearForums.Web.Controllers.Filters;
using System.Web.Mvc;
using NearForums.Tests.Fakes;
using NearForums.Web.Controllers;
using NearForums.Web.Routing;
using System.Reflection;
using NearForums.Web.State;

namespace NearForums.Tests.Controllers
{
	/// <summary>
	/// Summary description for ActionFiltersTests
	/// </summary>
	[TestClass]
	public class ActionFiltersTests
	{
		public ActionFiltersTests()
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

		[TestMethod]
		public void AuthorizationAttribute_Test()
		{
			var sessionItems = new System.Web.SessionState.SessionStateItemCollection();
			var controllerContext = new FakeControllerContext(new TopicsController(), "http://localhost", null, null, new System.Collections.Specialized.NameValueCollection(), new System.Collections.Specialized.NameValueCollection(), new System.Web.HttpCookieCollection(), sessionItems);
			var context = new AuthorizationContext(controllerContext, new FakeActionDescriptor());
			var att = new RequireAuthorizationAttribute(UserRole.Member);
			att.Routes.Add(new StrictRoute("login", new MvcRouteHandler())
			{
				Url = "login",
				Defaults = new System.Web.Routing.RouteValueDictionary(new
				{
					controller = "Authentication",
					action = "Login"
				})
			});
			context.Result = null;
			att.OnAuthorization(context);
			Assert.IsInstanceOfType(context.Result, typeof(RedirectResult));

			//Test with user
			User user = ServicesTests.GetTestUser();
			sessionItems["User"] = new UserState(user, AuthenticationProvider.Facebook);
			context.Result = null;
			att.OnAuthorization(context);
			Assert.IsNull(context.Result);
		}

		[TestMethod]
		public void ValidateReadAccessAttribute_Test()
		{
			var controller = new TopicsController();
			var controllerContext = new FakeControllerContext(controller, "http://localhost");
			var filterContext = new ActionExecutedContext(controllerContext, new FakeActionDescriptor(), false, null);
			var att = new ValidateReadAccessAttribute();

			filterContext.Result = new ViewResult();
			controller.ViewData.Model = new Topic();
			att.OnActionExecuted(filterContext);
			//The user should see the content
			Assert.IsTrue(filterContext.Result is ViewResult);

			filterContext.Result = new ViewResult();
			controller.ViewData.Model = new Topic() { ReadAccessRole = UserRole.Moderator};
			att.OnActionExecuted(filterContext);
			//The user should be redirected
			Assert.IsTrue(filterContext.Result is RedirectToRouteResult);
		}
	}
}
