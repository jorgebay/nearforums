using System;
using System.Reflection;
using System.Web.Mvc;
using NearForums.Services;
using NearForums.Web.Controllers.Filters;

namespace NearForums.Web.Controllers
{
	public class AdminController : BaseController
	{
		public AdminController()
		{

		}

		#region Dashboard
		[RequireAuthorization(UserRole.Moderator)]
		public ActionResult Dashboard()
		{
			//Get the assembly file version
			var attrs = Assembly.GetExecutingAssembly().GetCustomAttributes(typeof(AssemblyFileVersionAttribute), true);
			ViewBag.Version = "0";
			if (attrs.Length > 0 && attrs[0] as AssemblyFileVersionAttribute != null)
			{
				ViewBag.Version = ((AssemblyFileVersionAttribute)attrs[0]).Version;
			}
			return View();
		}
		#endregion
	}
}
