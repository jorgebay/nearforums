using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NearForums.Web.Controllers;
using NearForums.Tests.Fakes;
using System.Web.Mvc;
using NearForums.Services;
using System.Web.SessionState;
using NearForums.Web;
using NearForums.Web.Extensions;
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
			var topicService = TestHelper.Resolve<ITopicsService>();
			List<Topic> topicList = topicService.GetByForum(forum.Id, 0, 1, null);

			if (topicList.Count == 0)
			{
				Assert.Inconclusive("There is no topic in the db to perform this test.");
			}
			Topic topic = topicService.Get(topicList[0].Id);
			return topic;
		}

		[TestMethod]
		public void Topic_Add_Delete_Test()
		{
			var controller = TestHelper.Resolve<TopicsController>();
			var controllerContext = new FakeControllerContext(controller, "http://localhost", null, null, new System.Collections.Specialized.NameValueCollection(), new System.Collections.Specialized.NameValueCollection(), new System.Web.HttpCookieCollection(), ForumsControllerTest.GetSessionWithTestUser());
			controller.ControllerContext = controllerContext;
			ActionResult result = null;

			var forum = ForumsControllerTest.GetAForum();

			result = controller.Add(forum.ShortName, new Topic(), true, "admin@admin.com");
			Assert.IsFalse(result is RedirectToRouteResult); //controller should display the same page to correct error.

			//Create a valid topic
			var t = new Topic();
			t.Title = "Unit testing " + TestContext.TestName;
			t.Description = "This is a sample topic from unit testing project.";
			t.Tags = new TagList("test");
			t.ShortName = t.Title.ToUrlSegment(64);
			t.User = controller.User.ToUser();
			t.Forum = forum;

			controller = TestHelper.Resolve<TopicsController>();
			controller.ControllerContext = controllerContext;
			controller.Url = new UrlHelper(controllerContext.RequestContext);
			result = controller.Add(forum.ShortName, t, true, "admin@admin.com");
			int topicId = t.Id;

			Assert.IsTrue(topicId > 0);

			result = controller.Delete(topicId, t.ShortName, t.Forum.ShortName);

			Assert.IsTrue(result is JsonResult);

			t = TestHelper.Resolve<ITopicsService>().Get(topicId);

			Assert.IsNull(t);
			
		}

		[TestMethod]
		public void TagList_Test()
		{
			#region Create a valid topic and controller
			TopicsController controller = TestHelper.Resolve<TopicsController>();
			var controllerContext = new FakeControllerContext(controller, "http://localhost", null, null, new System.Collections.Specialized.NameValueCollection(), new System.Collections.Specialized.NameValueCollection(), new System.Web.HttpCookieCollection(), ForumsControllerTest.GetSessionWithTestUser());
			controller.ControllerContext = controllerContext;
			controller.Url = new UrlHelper(controllerContext.RequestContext);

			Forum forum = ForumsControllerTest.GetAForum();

			//Create a valid topic
			Topic t = new Topic();
			t.Title = "Unit testing " + TestContext.TestName;
			t.Description = "This is a sample topic from unit testing project.";
			t.Tags = new TagList("test");
			t.ShortName = t.Title.ToUrlSegment(64);
			t.User = controller.User.ToUser();
			t.Forum = forum; 
			#endregion

			TagListTestHelper(true, "hola mundo", 2, t, forum.ShortName, controller);
			TagListTestHelper(true, "hola	mundo", 2, t, forum.ShortName, controller);
			TagListTestHelper(true, "hola		mundo", 2, t, forum.ShortName, controller);
			TagListTestHelper(false, "NOTho}la", 1, t, forum.ShortName, controller);
			TagListTestHelper(true, " tag1 tag2 tag3 tag4 tag5 tag6", 6, t, forum.ShortName, controller);
			TagListTestHelper(true, "tabbedtag1 	tag2 	tag3 	tag4 	tag5 	tag6 	", 6, t, forum.ShortName, controller);
			TagListTestHelper(true, "tagdott tag2 tag3 asp.net tag", 5, t, forum.ShortName, controller);
			TagListTestHelper(false, "NOTtag tag tagtag3 tag4 tag5 tag6 tag7 tag8", 8, t, forum.ShortName, controller);
			TagListTestHelper(true, "repeated tag tag tag4 tag5 tagthisislong6", 5, t, forum.ShortName, controller);
			TagListTestHelper(true, "tag tag2 tagtag3 tag4 tag5 tagthis_islmiddlescore--ong6", 6, t, forum.ShortName, controller);

		}

		public void TagListTestHelper(bool valid, string tags, int tagCount, Topic t, string forumShortName, TopicsController controller)
		{
			var context = controller.ControllerContext;

			controller = TestHelper.Resolve<TopicsController>();
			controller.ControllerContext = context;
			controller.Url = new UrlHelper(context.RequestContext);
			
			t.Id = 0;
			t.Tags = new TagList(tags);

			Assert.IsTrue(t.Tags.Count == tagCount, "Tag \"" + tags + "\" count does not match expected value");

			controller.Add(forumShortName, t, true, "admin@admin.com");
			
			int topicId = t.Id;
			if (valid)
			{
				Assert.IsTrue(topicId > 0);

				controller.Delete(topicId, t.ShortName, t.Forum.ShortName);
			}
			else
			{
				Assert.IsFalse(topicId > 0);
			}
		}

		[TestMethod]
		public void EditTopic_Test()
		{
			TopicsController controller = TestHelper.Resolve<TopicsController>();
			controller.ControllerContext = new FakeControllerContext(controller, "http://localhost", null, null, new System.Collections.Specialized.NameValueCollection(), new System.Collections.Specialized.NameValueCollection(), new System.Web.HttpCookieCollection(), ForumsControllerTest.GetSessionWithTestUser());
			ActionResult result = null;

			Forum forum = ForumsControllerTest.GetAForum();
			Topic topic = TopicsControllerTest.GetATopic(forum);


			result = controller.Edit(topic.Id, topic.ShortName, forum.ShortName, topic, true, "admin@admin.com");

			Assert.IsTrue(result is RedirectToRouteResult || result is RedirectResult);
		}

		[TestMethod]
		public void Topic_OpenClose_Test()
		{
			TopicsController controller = TestHelper.Resolve<TopicsController>();
			controller.ControllerContext = new FakeControllerContext(controller, "http://localhost", null, null, new System.Collections.Specialized.NameValueCollection(), new System.Collections.Specialized.NameValueCollection(), new System.Web.HttpCookieCollection(), ForumsControllerTest.GetSessionWithTestUser());
			var topicService = TestHelper.Resolve<ITopicsService>();

			var forum = ForumsControllerTest.GetAForum();
			var topic = TopicsControllerTest.GetATopic(forum);

			controller.CloseReplies(topic.Id, topic.ShortName);

			topic = topicService.Get(topic.Id);

			Assert.IsTrue(topic.IsClosed);

			controller.OpenReplies(topic.Id, topic.ShortName);

			topic = topicService.Get(topic.Id);

			Assert.IsFalse(topic.IsClosed);
		}

		[TestMethod]
		public void Topic_LatestMessages_Test()
		{
			TopicsController controller = TestHelper.Resolve<TopicsController>();
			controller.ControllerContext = new FakeControllerContext(controller, "http://localhost", null, null, new System.Collections.Specialized.NameValueCollection(), new System.Collections.Specialized.NameValueCollection(), new System.Web.HttpCookieCollection(), ForumsControllerTest.GetSessionWithTestUser());

			Forum forum = ForumsControllerTest.GetAForum();
			Topic topic = TopicsControllerTest.GetATopic(forum);

			ActionResult result = controller.LatestMessages(topic.Id, topic.ShortName);
			Assert.IsTrue(controller.ViewData.Model is Topic);
		}
	}
}
