using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Web.Routing;
using NearForums.Web.UI;
using System.Web.Mvc;
using NearForums.Tests.Fakes;
using NearForums.Web.Routing;
using System.Web;
using NearForums.Web.Controllers;

namespace NearForums.Tests.Routing
{
	/// <summary>
	/// Summary description for StrictRoute
	/// </summary>
	[TestClass]
	public class StrictRouteTest
	{
		public StrictRouteTest()
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
		public void StrictRouteMapping_Test1()
		{
			RouteCollection collection = GetTestCollection();
			//Test home
			Assert.IsTrue(MapsTo("http://localhost", collection, "Home", "Index"));

			//Test about
			Assert.IsTrue(MapsTo("http://localhost/about", collection, "Home", "About"));
			//Casing
			//Assert.IsFalse(MapsTo("http://localhost/About", collection, "Home", "About"));
			Assert.IsFalse(MapsTo("http://localhost/about/", collection, "Home", "About"));

			//Test contact
			Assert.IsTrue(MapsTo("http://localhost/contact/", collection, "Feedback", "Contact"));
			Assert.IsFalse(MapsTo("http://localhost/contact", collection, "Feedback", "Contact"));

			//Test categories detail page
			Assert.IsTrue(MapsTo("http://localhost/category/technology/1", collection, "Categories", "Detail"));
			Assert.IsTrue(MapsTo("http://localhost/category/technology/", collection, "Categories", "Detail"));
			Assert.IsFalse(MapsTo("http://localhost/category/technology", collection, "Categories", "Detail"));
			Assert.IsFalse(MapsTo("http://localhost/category/technology/1/", collection, "Categories", "Detail"));
			//Assert.IsFalse(MapsTo("http://localhost/Category/technology/1", collection, "Categories", "Detail"));
			
		}

		[TestMethod]
		public void StrictRouteVirtualPath_Test()
		{
			RequestContext requestContext = new RequestContext(new FakeHttpContext("http://localhost"), new RouteData());
			RouteCollection collection = GetTestCollection();

			//Home
			Assert.AreEqual("/", collection.GetVirtualPath(requestContext, new RouteValueDictionary(new
			{
				controller = "Home",
				action = "Index"
			})).VirtualPath);
			//About
			Assert.AreEqual("/about", collection.GetVirtualPath(requestContext, new RouteValueDictionary(new
			{
				controller = "Home",
				action = "About"
			})).VirtualPath);
			////Categories
			Assert.AreEqual("/category/technology/1", collection.GetVirtualPath(requestContext, new RouteValueDictionary(new
			{
				controller = "Categories",
				action = "Detail",
				category = "technology",
				page = 1

			})).VirtualPath);
			Assert.AreEqual("/category/technology/", collection.GetVirtualPath(requestContext, new RouteValueDictionary(new
			{
				controller = "Categories",
				action = "Detail",
				category = "technology",
				page = 0

			})).VirtualPath);
			//Contact
			Assert.AreEqual("/contact/", collection.GetVirtualPath(requestContext, new RouteValueDictionary(new
			{
				controller = "Feedback",
				action = "Contact"

			})).VirtualPath);

		}

		private bool MapsTo(string url, RouteCollection collection, string controller, string action)
		{
			FakeHttpContext context = new FakeHttpContext(url);

			RouteData data = collection.GetRouteData(context);
			if (data != null)
			{
				if (data.Values["Controller"].ToString().ToLower() == controller.ToLower() && data.Values["Action"].ToString().ToLower() == action.ToLower())
				{
					return true;
				}
			}

			return false;
		}

		#region Build test collection
		private RouteCollection GetTestCollection()
		{

			StrictRoute route1 = new StrictRoute("", new MvcRouteHandler());
			route1.Defaults = new RouteValueDictionary();
			route1.Defaults.Add("controller", "Home");
			route1.Defaults.Add("action", "Index");

			StrictRoute route2 = new StrictRoute("about", new MvcRouteHandler());
			route2.Defaults = new RouteValueDictionary();
			route2.Defaults.Add("controller", "Home");
			route2.Defaults.Add("action", "About");

			StrictRoute route3 = new StrictRoute("category/{category}/{page}", new MvcRouteHandler());
			route3.Defaults = new RouteValueDictionary();
			route3.Defaults.Add("controller", "Categories");
			route3.Defaults.Add("action", "Detail");
			route3.Defaults.Add("page", 0);
			route3.Constraints = new RouteValueDictionary();
			route3.Constraints.Add("page", @"\d+");

			StrictRoute route4 = new StrictRoute("contact/", new MvcRouteHandler());
			route4.Defaults = new RouteValueDictionary();
			route4.Defaults.Add("controller", "Feedback");
			route4.Defaults.Add("action", "Contact");

			//Build the route Collection
			RouteCollection collection = new RouteCollection()
			{
				route1, route2, route3, route4
			};

			return collection;
		} 
		#endregion
	}
}
