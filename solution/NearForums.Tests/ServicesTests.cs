using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NearForums.ServiceClient;
using NearForums.Tests.Controllers;

namespace NearForums.Tests
{
	[TestClass]
	public class ServicesTests
	{
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
		public void UsersServiceClient_Add_Get_Delete()
		{
			User user = new User(0, "UNITTEST USERNAME EMPTY");
			user.Group = UserGroup.Level1;
			string providerId = "00" + new Random().Next(int.MaxValue / 2, int.MaxValue).ToString();

			UsersServiceClient.Add(user, AuthenticationProvider.Twitter, providerId);

			user = UsersServiceClient.GetByProviderId(AuthenticationProvider.Twitter, providerId);
			Assert.IsTrue(user.Id > 0);

			UsersServiceClient.Delete(user.Id);

			user = UsersServiceClient.GetByProviderId(AuthenticationProvider.Twitter, providerId);

			Assert.IsNull(user);

			//Perform the same test but with all properties populated.
			user = new User(0, "UNITTEST USERNAME FULL");
			user.Group = UserGroup.Level1;
			user.BirthDate = new DateTime(1960, 12, 31);
			user.ExternalProfileUrl = "http://twitter.com/jorgebg";
			user.Photo = "http://twitter.com/jorgebg.png";
			user.Profile = "Hello world1";
			user.Signature = "Hello world2";
			user.TimeZone = new TimeSpan(2, 0, 0);
			user.Website = "http://twitter.com/jorgebg/";

			providerId = "00" + new Random().Next(int.MaxValue / 2, int.MaxValue).ToString();

			UsersServiceClient.Add(user, AuthenticationProvider.Twitter, providerId);

			user = UsersServiceClient.GetByProviderId(AuthenticationProvider.Twitter, providerId);
			Assert.IsTrue(user.Id > 0);

			UsersServiceClient.Delete(user.Id);

			user = UsersServiceClient.GetByProviderId(AuthenticationProvider.Twitter, providerId);
			Assert.IsNull(user);
		}

		[TestMethod]
		public void TopicsSubscriptions_Add_Get_Delete_Test()
		{
			//Controllers.TopicsControllerTest.GetATopic
			var user = GetTestUser();
			var forum = ForumsControllerTest.GetAForum();
			var topic = TopicsControllerTest.GetATopic(forum);

			TopicsSubscriptionsServiceClient.Add(topic.Id, user.Id);

			var subscribedUsers = TopicsSubscriptionsServiceClient.GetSubscribed(topic.Id);
			var subscribedTopics = TopicsSubscriptionsServiceClient.GetTopics(user.Id);

			Assert.IsTrue(subscribedUsers.Count > 0);
			Assert.IsTrue(subscribedTopics.Count > 0);

			//Check that the topic recently subscribed is present.
			Assert.IsTrue(subscribedTopics.Any(x => x.Id == topic.Id));

			TopicsSubscriptionsServiceClient.SendNotificationsSync(topic, -1, "Unit test email from " + TestContext.TestName, "http://url", "http://unsubscribeUrl", false);

			TopicsSubscriptionsServiceClient.Remove(topic.Id, user.Id);

			subscribedTopics = TopicsSubscriptionsServiceClient.GetTopics(user.Id);

			//Check that the topic recently unsubscribed is NOT present.
			Assert.IsFalse(subscribedTopics.Any(x => x.Id == topic.Id));
		}

		public static User GetTestUser()
		{
			User user = UsersServiceClient.GetTestUser();
			if (user == null)
			{
				Assert.Inconclusive("There is no user in the db.");
			}
			return user;
		}
	}
}
