using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Windows.Input;
using System.Windows.Forms;
using System.Drawing;
using Microsoft.VisualStudio.TestTools.UITesting;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.VisualStudio.TestTools.UITest.Extension;
using Keyboard = Microsoft.VisualStudio.TestTools.UITesting.Keyboard;
using NearForums.Web.Controllers;
using System.Web.Mvc;
using System.Collections;


namespace NearForums.Tests.Controllers
{
	/// <summary>
	/// Summary description for CodedUITest1
	/// </summary>
	[CodedUITest]
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
			PageContentsController controller = new PageContentsController();

			PageContent content = new PageContent()
			{
				Title = "Dummy Test Content"
				,Body = "<p>Hello world</p>"
			};
			#region Add
			var result = controller.Add(content);
			Assert.IsInstanceOfType(result, typeof(RedirectToRouteResult));
			Assert.IsNotNull(content.ShortName); 
			#endregion

			#region Edit
			content.Title += " (Edited)";
			result = controller.Edit(content.ShortName, content);
			Assert.IsInstanceOfType(result, typeof(RedirectToRouteResult)); 
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
