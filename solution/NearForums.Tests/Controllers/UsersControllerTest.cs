using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Web.SessionState;
using NearForums.Web.State;
using NearForums.Web.Controllers;
using System.Web.Mvc;
using System.Collections;
using NearForums.Tests.Fakes;
using NearForums.Services;

namespace NearForums.Tests.Controllers
{
	/// <summary>
	/// Summary description for UsersControllerTest
	/// </summary>
	[TestClass]
	public class UsersControllerTest
	{
		public UsersControllerTest()
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
		public void User_Get_Test()
		{
			SessionStateItemCollection session = ForumsControllerTest.GetSessionWithTestUser();
			UserState userState = (UserState)session["User"];

			var controller = TestHelper.Resolve<UsersController>();
			controller.ControllerContext = new FakeControllerContext(controller);
			ActionResult result = controller.Detail(userState.Id);

			User user = (User)controller.ViewData.Model;
			Assert.IsNotNull(user);
		}

		[TestMethod]
		public void User_Get_MessagesByUser()
		{
			SessionStateItemCollection session = ForumsControllerTest.GetSessionWithTestUser();
			UserState userState = (UserState)session["User"];

			var controller = TestHelper.Resolve<UsersController>();
			controller.ControllerContext = new FakeControllerContext(controller);
			ActionResult result = controller.MessagesByUser(userState.Id);

			IList topics = (IList)controller.ViewData.Model;
			Assert.IsNotNull(topics);
		}

		[TestMethod]
		public void User_Ban_Test()
		{
			var controller = TestHelper.Resolve<UsersController>();
			var context = new FakeControllerContext(controller);
			var sessionWrapper = new SessionWrapper(context.HttpContext);
			sessionWrapper.SetUser(ServicesTests.GetTestUser(), AuthenticationProvider.CustomDb);
			controller.ControllerContext = context;
			controller.Ban(0, ModeratorReason.Spamming, null);
			Assert.IsFalse((bool)controller.ViewData.Model);
		}

		[TestMethod]
		public void User_Manage_Access_Test()
		{
			var controller = TestHelper.Resolve<UsersController>();
			var context = new FakeControllerContext(controller);
			var sessionWrapper = new SessionWrapper(context.HttpContext);
			sessionWrapper.SetUser(new User() { Role = UserRole.Member }, AuthenticationProvider.CustomDb);
			controller.ControllerContext = context;
			try
			{
				controller.Ban(0, ModeratorReason.Spamming, null);
				Assert.Fail("The user banning is not a moderator or admin");
			}
			catch (System.Security.SecurityException)
			{
				
			}
		}

		[TestMethod]
		public void User_Suspend_Test()
		{
			var controller = TestHelper.Resolve<UsersController>();
			var context = new FakeControllerContext(controller);
			var sessionWrapper = new SessionWrapper(context.HttpContext);
			sessionWrapper.SetUser(ServicesTests.GetTestUser(), AuthenticationProvider.CustomDb);
			controller.ControllerContext = context;
			controller.Suspend(0, ModeratorReason.Spamming, null);
			Assert.IsFalse((bool)controller.ViewData.Model);
		}

		[TestMethod]
		public void User_Warn_Test()
		{
			var controller = TestHelper.Resolve<UsersController>();
			var context = new FakeControllerContext(controller);
			var sessionWrapper = new SessionWrapper(context.HttpContext);
			sessionWrapper.SetUser(ServicesTests.GetTestUser(), AuthenticationProvider.CustomDb);
			controller.ControllerContext = context;
			controller.Warn(0, ModeratorReason.Spamming, null);

			//False if no record was affected.
			Assert.IsFalse((bool)controller.ViewData.Model);
		}

		[TestMethod]
		public void User_Warn_Dismiss_Test()
		{
			var controller = TestHelper.Resolve<UsersController>();
			var context = new FakeControllerContext(controller);
			var sessionWrapper = new SessionWrapper(context.HttpContext);
			sessionWrapper.SetUser(ServicesTests.GetTestUser(), AuthenticationProvider.CustomDb);
			controller.ControllerContext = context;
			controller.WarnDismiss();

			//True if a record was affected.
			Assert.IsTrue((bool)controller.ViewData.Model);
		}
	}
}
