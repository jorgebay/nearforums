using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NearForums.Web.Controllers;
using System.Web.Mvc;
using NearForums.Tests.Fakes;

namespace NearForums.Tests.Controllers
{
	/// <summary>
	/// Summary description for MessagesControllerTest
	/// </summary>
	[TestClass]
	public class MessagesControllerTest
	{
		public MessagesControllerTest()
		{

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
		public void ListFlagged_Test()
		{
			var controller = TestHelper.Resolve<MessagesController>();
			controller.ControllerContext = new FakeControllerContext(controller);
			var result = controller.ListFlagged();

			Assert.IsInstanceOfType(result, typeof(ViewResult));
			Assert.IsInstanceOfType(controller.ViewData.Model, typeof(List<Topic>));
		}

		/// <summary>
		/// Tests the reply
		/// </summary>
		[TestMethod]
		public void Topic_Reply_Subscribe_Unsubscribe_Test()
		{
			var controller = TestHelper.Resolve<MessagesController>();
			var subscriptionsController = TestHelper.Resolve<TopicsSubscriptionsController>();
			controller.ControllerContext = new FakeControllerContext(controller, "http://localhost", null, null, new System.Collections.Specialized.NameValueCollection(), new System.Collections.Specialized.NameValueCollection(), new System.Web.HttpCookieCollection(), ForumsControllerTest.GetSessionWithTestUser());
			controller.Url = new UrlHelper(controller.ControllerContext.RequestContext);
			subscriptionsController.ControllerContext = controller.ControllerContext;
			subscriptionsController.Url = controller.Url;

			ActionResult result = null;

			Forum forum = ForumsControllerTest.GetAForum();
			Topic topic = TopicsControllerTest.GetATopic(forum);

			result = controller.Add(topic.Id, topic.ShortName, null);
			Assert.IsTrue(result is ViewResult);

			var message = (Message)controller.ViewData.Model;
			message.Body = "<p>Unit testing....</p>";

			result = controller.Add(message, topic.Id, topic.ShortName, topic.Forum.ShortName, null, true, "admin@admin.com");
			Assert.IsTrue(result is RedirectToRouteResult || result is RedirectResult);

			subscriptionsController.Unsubscribe(controller.User.Id, controller.User.Guid.ToString("N"), topic.Id);

			Assert.IsNotNull(subscriptionsController.ViewData.Model);
		}
	}
}
