using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NearForums.Web.Controllers;
using NearForums.Tests.Fakes;
using System.Web.Mvc;
using NearForums.ServiceClient;
using System.Web.SessionState;
using NearForums.Web.State;

namespace NearForums.Tests.Controllers
{
	/// <summary>
	/// Summary description for TopicsControllerTest
	/// </summary>
	[TestClass]
	public class TopicsControllerTest
	{
		public TopicsControllerTest()
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

		public static Topic GetATopic(Forum forum)
		{
			List<Topic> topicList = TopicsServiceClient.GetByForum(forum.Id, 0, 1);

			if (topicList.Count == 0)
			{
				Assert.Inconclusive("There is no topic in the db to perform this test.");
			}
			Topic topic = TopicsServiceClient.Get(topicList[0].Id);
			return topic;
		}

		[TestMethod]
		public void Topic_Add_Delete_Test()
		{
			TopicsController controller = new TopicsController();
			controller.ControllerContext = new FakeControllerContext(controller, "http://localhost", null, null, new System.Collections.Specialized.NameValueCollection(), new System.Collections.Specialized.NameValueCollection(), new System.Web.HttpCookieCollection(), ForumsControllerTest.GetSessionWithTestUser());
			ActionResult result = null;

			Forum forum = ForumsControllerTest.GetAForum();

			result = controller.Add(forum.ShortName, new Topic());
			Assert.IsTrue(result is ViewResult);

			//Create a valid topic
			Topic t = new Topic();
			t.Title = "Unit testing " + TestContext.TestName;
			t.Description = "This is a sample topic from unit testing project.";
			t.Tags = new TagList("test");
			t.ShortName = Utils.ToUrlFragment(t.Title, 64);
			t.User = controller.User.ToUser();
			t.Forum = forum;

			result = controller.Add(forum.ShortName, t);
			int topicId = t.Id;

			Assert.IsTrue(topicId > 0);

			result = controller.Delete(topicId, t.ShortName, t.Forum.ShortName);

			Assert.IsTrue(result is RedirectToRouteResult);

			t = TopicsServiceClient.Get(topicId);

			Assert.IsNull(t);
			
		}

		[TestMethod]
		public void TagList_Test()
		{
			TagList tags = new TagList("hola    mundo  sin");
			Assert.IsTrue(tags.Count == 3);
		}

		[TestMethod]
		public void EditTopic_Test()
		{
			TopicsController controller = new TopicsController();
			controller.ControllerContext = new FakeControllerContext(controller, "http://localhost", null, null, new System.Collections.Specialized.NameValueCollection(), new System.Collections.Specialized.NameValueCollection(), new System.Web.HttpCookieCollection(), ForumsControllerTest.GetSessionWithTestUser());
			ActionResult result = null;

			Forum forum = ForumsControllerTest.GetAForum();
			Topic topic = TopicsControllerTest.GetATopic(forum);


			result = controller.Edit(topic.Id, topic.ShortName, forum.ShortName, topic);

			Assert.IsTrue(result is RedirectToRouteResult || result is RedirectResult);
		}

		[TestMethod]
		public void Topic_Reply_Test()
		{
			TopicsController controller = new TopicsController();
			controller.ControllerContext = new FakeControllerContext(controller, "http://localhost", null, null, new System.Collections.Specialized.NameValueCollection(), new System.Collections.Specialized.NameValueCollection(), new System.Web.HttpCookieCollection(), ForumsControllerTest.GetSessionWithTestUser());
			ActionResult result = null;

			Forum forum = ForumsControllerTest.GetAForum();
			Topic topic = TopicsControllerTest.GetATopic(forum);

			Message message = new Message()
			{
				Body = "<p>Unit testing....</p>"
			};

			result = controller.Reply(message, topic.Id, topic.ShortName, topic.Forum.ShortName);

			Assert.IsTrue(result is RedirectToRouteResult || result is RedirectResult);
		}

		[TestMethod]
		public void Topic_OpenClose_Test()
		{
			TopicsController controller = new TopicsController();
			controller.ControllerContext = new FakeControllerContext(controller, "http://localhost", null, null, new System.Collections.Specialized.NameValueCollection(), new System.Collections.Specialized.NameValueCollection(), new System.Web.HttpCookieCollection(), ForumsControllerTest.GetSessionWithTestUser());

			Forum forum = ForumsControllerTest.GetAForum();
			Topic topic = TopicsControllerTest.GetATopic(forum);

			controller.CloseReplies(topic.Id, topic.ShortName);

			topic = TopicsServiceClient.Get(topic.Id);

			Assert.IsTrue(topic.IsClosed);

			controller.OpenReplies(topic.Id, topic.ShortName);

			topic = TopicsServiceClient.Get(topic.Id);

			Assert.IsFalse(topic.IsClosed);
		}

		[TestMethod]
		public void Topic_LatestMessages_Test()
		{
			TopicsController controller = new TopicsController();
			controller.ControllerContext = new FakeControllerContext(controller, "http://localhost", null, null, new System.Collections.Specialized.NameValueCollection(), new System.Collections.Specialized.NameValueCollection(), new System.Web.HttpCookieCollection(), ForumsControllerTest.GetSessionWithTestUser());

			Forum forum = ForumsControllerTest.GetAForum();
			Topic topic = TopicsControllerTest.GetATopic(forum);

			ActionResult result = controller.LatestMessages(topic.Id, topic.ShortName);
			Assert.IsTrue(controller.ViewData.Model is Topic);
		}
	}
}
