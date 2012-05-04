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
using NearForums.Configuration;
using System.Web.Security;
using NearForums.Tests.Fakes;

namespace NearForums.Tests.Controllers
{
	[TestClass]
	public class FormsAuthenticationControllerTest
	{

		[TestMethod]
		public void FormsAuthentication_ResetPassword()
		{
			FormsAuthenticationController controller = TestHelper.Resolve<FormsAuthenticationController>();
			controller.ControllerContext = new FakeControllerContext(controller, "http://localhost/forums/");
			controller.Url = new UrlHelper(controller.ControllerContext.RequestContext);

			try
			{
				#region Get a test user to reset the password
				var users = Membership.GetAllUsers();

				if (users.Count == 0)
				{
					Assert.Inconclusive("No membership data for unit testing");
					return;
				}
				var enumerator = users.GetEnumerator();
				enumerator.MoveNext();
				var u = (MembershipUser)enumerator.Current;
				#endregion

				var result = controller.ResetPassword(u.Email);
				Assert.IsTrue(controller.ModelState.IsValid);
				Assert.IsInstanceOfType(result, typeof(ViewResult));
			}
			catch (NotSupportedException)
			{
				Assert.Inconclusive();
			}
		}
	}
}
