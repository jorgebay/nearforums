﻿using System;
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
using System.IO;
using System.Text.RegularExpressions;
using System.Security.AccessControl;
using NearForums.Configuration;
using NearForums.ServiceClient;
using NearForums.Web.State;

namespace NearForums.Tests.Controllers
{
	/// <summary>
	/// Summary description for AdminControllerTest
	/// </summary>
	[TestClass]
	public class AdminControllerTest
	{
		public AdminControllerTest()
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
		public void AdminController_TestFakes()
		{
			//AdminController controller = new AdminController();
			//controller.ControllerContext = new FakeControllerContext(controller, "http://localhost/forums/");
			//controller.Url = new UrlHelper(controller.ControllerContext.RequestContext);
			//controller.AddTemplate();
			//string test = controller.ViewData["SampleUrl"].ToString();
			//Assert.IsNotNull(test);
			FakeHttpContext context = new FakeHttpContext("http://localhost/forums/");
			string physicalPath = context.Server.MapPath("~/Content/Templates/Sample/Template.html");
			Assert.IsTrue(File.Exists(physicalPath));

		}

		[TestMethod]
		public void AdminController_ChopTemplate_Test()
		{
			AdminController controller = new AdminController();
			controller.ControllerContext = new FakeControllerContext(controller, "http://localhost/forums/");
			controller.Url = new UrlHelper(controller.ControllerContext.RequestContext);

			int parts = controller.ChopTemplateFile(controller.ControllerContext.HttpContext.Server.MapPath("~/Content/Templates/Sample/Template.html"));
			Assert.IsTrue(parts > 1);
		}

		[TestMethod]
		public void AdminController_TestAccessWrites()
		{
			FakeHttpContext context = new FakeHttpContext("http://localhost/");
			DirectoryInfo directory = new DirectoryInfo(context.Server.MapPath("/content/templates/"));
			//AuthorizationRuleCollection ruleCollection = directory.GetAccessControl().GetAccessRules(true, true, typeof(System.Security.Principal.SecurityIdentifier));

			//bool canWrite = false;
			//foreach (FileSystemAccessRule rule in ruleCollection)
			//{
			//    if ((rule.FileSystemRights & FileSystemRights.FullControl) == FileSystemRights.FullControl)
			//    {
			//        canWrite = true;
			//        break;
			//    }
			//}

			//Assert.IsTrue(canWrite);

			UserFileAccessRights fileAccessRights = new UserFileAccessRights(context.Server.MapPath("/content/templates/"));
			Assert.IsTrue(fileAccessRights.canWrite());
		}
	}
}