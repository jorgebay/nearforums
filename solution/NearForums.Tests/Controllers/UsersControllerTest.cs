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

			UsersController controller = TestHelper.Resolve<UsersController>();
			ActionResult result = controller.Detail(userState.Id);

			User user = (User)controller.ViewData.Model;
			Assert.IsNotNull(user);
		}

		[TestMethod]
		public void User_Get_MessagesByUser()
		{
			SessionStateItemCollection session = ForumsControllerTest.GetSessionWithTestUser();
			UserState userState = (UserState)session["User"];

			UsersController controller = TestHelper.Resolve<UsersController>();
			ActionResult result = controller.MessagesByUser(userState.Id);

			IList topics = (IList)controller.ViewData.Model;
			Assert.IsNotNull(topics);
		}
	}
}
