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
using System.Web;

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
			var controllerContext = new FakeControllerContext(TestHelper.Resolve<TopicsController>(), "http://localhost", null, null, new System.Collections.Specialized.NameValueCollection(), new System.Collections.Specialized.NameValueCollection(), new System.Web.HttpCookieCollection(), sessionItems);
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
			var controller = TestHelper.Resolve<TopicsController>();
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

		[TestMethod]
		public void PreventFloodAttribute_Time_Test()
		{
			//set up context
			var controller = TestHelper.Resolve<MessagesController>();
			var controllerContext = new FakeControllerContext(controller, "http://localhost");
			var executingFilterContext = new ActionExecutingContext(controllerContext, new FakeActionDescriptor(), new Dictionary<string, object>());
			var executedfilterContext = new ActionExecutedContext(controllerContext, new FakeActionDescriptor(), false, null);
			var httpContext = (FakeHttpContext)controllerContext.HttpContext;
			httpContext.CleanCache();

			//set up attr
			var attr = new PreventFloodAttribute(typeof(EmptyResult));
			attr.Config.SpamPrevention.FloodControl.TimeBetweenPosts = 5;
			attr.Config.SpamPrevention.FloodControl.IgnoreForRole = (UserRole) Int16.MaxValue; //do not ignore

			//first execution
			attr.OnActionExecuting(executingFilterContext);
			Assert.AreNotEqual<bool?>(true, (bool?)controller.ViewBag.ShowCaptcha);
			attr.OnActionExecuted(executedfilterContext);

			//second execution: must be considered as flooding
			attr.OnActionExecuting(executingFilterContext);
			Assert.AreEqual<bool?>(true, (bool?)controller.ViewBag.ShowCaptcha);
			attr.OnActionExecuted(executedfilterContext);
		}

		[TestMethod]
		public void PreventFloodAttribute_Role_Test()
		{
			//set up context
			var controller = TestHelper.Resolve<TopicsController>();
			var controllerContext = new FakeControllerContext(controller, "http://localhost");
			var executingFilterContext = new ActionExecutingContext(controllerContext, new FakeActionDescriptor(), new Dictionary<string, object>());
			var executedfilterContext = new ActionExecutedContext(controllerContext, new FakeActionDescriptor(), false, null);
			var httpContext = (FakeHttpContext) controllerContext.HttpContext;
			httpContext.CleanCache();

			//set up attr
			var attr = new PreventFloodAttribute(typeof(EmptyResult));
			attr.Config.SpamPrevention.FloodControl.TimeBetweenPosts = 5;
			attr.Config.SpamPrevention.FloodControl.IgnoreForRole = UserRole.Moderator; //ignore for moderator or admin

			var session = new SessionWrapper(httpContext);
			session.SetUser(new User() { Role = UserRole.Moderator }, AuthenticationProvider.CustomDb);

			//first execution
			attr.OnActionExecuting(executingFilterContext);
			Assert.AreNotEqual<bool?>(true, (bool?)controller.ViewBag.ShowCaptcha);
			attr.OnActionExecuted(executedfilterContext);

			//second execution: must NOT be considered as flooding
			attr.OnActionExecuting(executingFilterContext);
			Assert.AreNotEqual<bool?>(true, (bool?)controller.ViewBag.ShowCaptcha);
			attr.OnActionExecuted(executedfilterContext);
		}
	}
}
