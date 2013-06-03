using System;
using System.Collections;
using System.Web.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NearForums.Tests.Fakes;
using NearForums.Web.Controllers;


namespace NearForums.Tests.Controllers
{
	/// <summary>
	/// Summary description for CodedUITest1
	/// </summary>
	[TestClass]
	public class PageContentsControllerTest
	{
		public PageContentsControllerTest()
		{
		}

		#region Additional test attributes

		// You can use the following additional attributes as you write your tests:

		////Use TestInitialize to run code before running each test 
		//[TestInitialize()]
		//public void MyTestInitialize()
		//{        
		//    // To generate code for this test, select "Generate Code for Coded UI Test" from the shortcut menu and select one of the menu items.
		//    // For more information on generated code, see http://go.microsoft.com/fwlink/?LinkId=179463
		//}

		////Use TestCleanup to run code after each test has run
		//[TestCleanup()]
		//public void MyTestCleanup()
		//{        
		//    // To generate code for this test, select "Generate Code for Coded UI Test" from the shortcut menu and select one of the menu items.
		//    // For more information on generated code, see http://go.microsoft.com/fwlink/?LinkId=179463
		//}

		#endregion

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
		private TestContext testContextInstance;


		[TestMethod]
		public void PageContent_Add_Edit_List_Detail_Delete_Test()
		{
			var controller = TestHelper.Resolve<PageContentsController>();
			controller.ControllerContext = new FakeControllerContext(controller);

			var content = new PageContent()
			{
				Title = "Dummy Test Content"
				,Body = "<p>Hello world</p>"
			};
			PageContent contentFail = new PageContent();
			#region Add
			var result = controller.Add(content);
			Assert.IsInstanceOfType(result, typeof(RedirectToRouteResult));
			Assert.IsNotNull(content.ShortName);

			controller = TestHelper.Resolve<PageContentsController>();
			controller.ControllerContext = new FakeControllerContext(controller);
			result = controller.Add(contentFail);
			//Must return to the view
			Assert.IsInstanceOfType(result, typeof(ViewResult));
			#endregion

			#region Edit
			content.Title += " (Edited)";
			controller = TestHelper.Resolve<PageContentsController>();
			controller.ControllerContext = new FakeControllerContext(controller);
			result = controller.Edit(content.ShortName, content);
			Assert.IsInstanceOfType(result, typeof(RedirectToRouteResult));

			controller = TestHelper.Resolve<PageContentsController>();
			controller.ControllerContext = new FakeControllerContext(controller);
			result = controller.Edit(content.ShortName, contentFail);
			//Must return to the view
			Assert.IsInstanceOfType(result, typeof(ViewResult));
			#endregion

			#region List and Detail
			result = controller.Detail(content.ShortName);
			Assert.IsInstanceOfType(result, typeof(ViewResult));
			Assert.IsNotNull(controller.ViewData.Model);
			//List
			result = controller.List();
			Assert.IsInstanceOfType(result, typeof(ViewResult));
			Assert.IsTrue(((IList)controller.ViewData.Model).Count > 0);
			#endregion

			#region Delete
			result = controller.Delete(content.ShortName);
			Assert.IsInstanceOfType(result, typeof(JsonResult));
			#endregion
		}
	}
}
