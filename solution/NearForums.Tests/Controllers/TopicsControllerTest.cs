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

		[TestMethod]
		public void TagList_Test()
		{
			TagList tags = new TagList("hola    mundo  sin");
		}

		[TestMethod]
		public void AddTopic_Test()
		{
			TopicsController controller = new TopicsController();
			SessionStateItemCollection sessionItems = new SessionStateItemCollection();
			controller.ControllerContext = new FakeControllerContext(controller, "http://localhost", null, null, new System.Collections.Specialized.NameValueCollection(), new System.Collections.Specialized.NameValueCollection(), new System.Web.HttpCookieCollection(), sessionItems);
			ActionResult result = null;

			#region Get necessary data
			List<ForumCategory> forumList = ForumsServiceClient.GetList();
			User user = UsersServiceClient.GetTestUser();

			if (forumList.Count == 0 || user == null)
			{
				Assert.Inconclusive("No necessary data in the db to execute this test.");
			}
			Forum forum = forumList[0].Forums[0];
			sessionItems["User"] = new UserState(user);
			#endregion

			result = controller.Add(forum.ShortName, new Topic());
			Assert.IsTrue(result is ViewResult);

			//Create a valid topic
			Topic t = new Topic();
			t.Title = "Unit testing " + TestContext.TestName;
			t.Description = "This is a sample topic from unit testing project.";
			t.Tags = new TagList("test");
			t.ShortName = Utils.ToUrlFragment(t.Title, 64);
			t.User = user;
			t.Forum = forum;

			result = controller.Add(forum.ShortName, t);
			Assert.IsTrue(t.Id > 0);
		}

		[TestMethod]
		public void EditTopic_Test()
		{
			TopicsController controller = new TopicsController();
			SessionStateItemCollection sessionItems = new SessionStateItemCollection();
			controller.ControllerContext = new FakeControllerContext(controller, "http://localhost", null, null, new System.Collections.Specialized.NameValueCollection(), new System.Collections.Specialized.NameValueCollection(), new System.Web.HttpCookieCollection(), sessionItems);
			ActionResult result = null;

			#region Get necessary data
			List<ForumCategory> forumList = ForumsServiceClient.GetList();
			User user = UsersServiceClient.GetTestUser();

			if (forumList.Count == 0 || user == null)
			{
				Assert.Inconclusive("No necessary data in the db to execute this test.");
			}
			Forum forum = forumList[0].Forums[0];
			List<Topic> topicList = TopicsServiceClient.GetByForum(forum.Id, 0, 1);

			if (topicList.Count == 0)
			{
				Assert.Inconclusive("No necessary data in the db to execute this test.");
			}
			Topic topic = TopicsServiceClient.Get(topicList[0].Id);
			sessionItems["User"] = new UserState(user);
			#endregion

			result = controller.Edit(topic.Id, topic.ShortName, forum.ShortName, topic);

			Assert.IsTrue(result is RedirectToRouteResult || result is RedirectResult);
		}

		[TestMethod]
		public void Topic_Reply_Test()
		{
			TopicsController controller = new TopicsController();
			SessionStateItemCollection sessionItems = new SessionStateItemCollection();
			controller.ControllerContext = new FakeControllerContext(controller, "http://localhost", null, null, new System.Collections.Specialized.NameValueCollection(), new System.Collections.Specialized.NameValueCollection(), new System.Web.HttpCookieCollection(), sessionItems);
			ActionResult result = null;

			#region Get necessary data
			List<ForumCategory> forumList = ForumsServiceClient.GetList();
			User user = UsersServiceClient.GetTestUser();

			if (forumList.Count == 0 || user == null)
			{
				Assert.Inconclusive("No necessary data in the db to execute this test.");
			}
			Forum forum = forumList[0].Forums[0];
			List<Topic> topicList = TopicsServiceClient.GetByForum(forum.Id, 0, 1);

			if (topicList.Count == 0)
			{
				Assert.Inconclusive("No necessary data in the db to execute this test.");
			}
			Topic topic = TopicsServiceClient.Get(topicList[0].Id);
			sessionItems["User"] = new UserState(user);
			#endregion

			Message message = new Message()
			{
				Body = "<p>Unit testing....</p>"
			};

			result = controller.Reply(message, topic.Id, topic.ShortName, topic.Forum.ShortName);

			Assert.IsTrue(result is RedirectToRouteResult || result is RedirectResult);
		}

		[TestMethod]
		public void Topic_OpenClose()
		{
			TopicsController controller = new TopicsController();
			SessionStateItemCollection sessionItems = new SessionStateItemCollection();
			controller.ControllerContext = new FakeControllerContext(controller, "http://localhost", null, null, new System.Collections.Specialized.NameValueCollection(), new System.Collections.Specialized.NameValueCollection(), new System.Web.HttpCookieCollection(), sessionItems);

			#region Get necessary data
			List<ForumCategory> forumList = ForumsServiceClient.GetList();
			User user = UsersServiceClient.GetTestUser();

			if (forumList.Count == 0 || user == null)
			{
				Assert.Inconclusive("No necessary data in the db to execute this test.");
			}
			Forum forum = forumList[0].Forums[0];
			List<Topic> topicList = TopicsServiceClient.GetByForum(forum.Id, 0, 1);

			if (topicList.Count == 0)
			{
				Assert.Inconclusive("No necessary data in the db to execute this test.");
			}
			Topic topic = TopicsServiceClient.Get(topicList[0].Id);
			sessionItems["User"] = new UserState(user);
			#endregion

			controller.CloseReplies(topic.Id, topic.ShortName);

			topic = TopicsServiceClient.Get(topic.Id);

			Assert.IsTrue(topic.IsClosed);

			controller.OpenReplies(topic.Id, topic.ShortName);

			topic = TopicsServiceClient.Get(topic.Id);

			Assert.IsFalse(topic.IsClosed);
		}
	}
}
