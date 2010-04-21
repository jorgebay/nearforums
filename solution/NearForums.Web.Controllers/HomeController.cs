using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NearForums.Web.Controllers.Helpers;
using NearForums.ServiceClient;

namespace NearForums.Web.Controllers
{
	[HandleError]
	public class HomeController : BaseController
	{
		public ActionResult Index()
		{
			return View(null, "Site", null);
		}

		public ActionResult About()
		{
			return View(null, "Site", null);
		}

		public ActionResult Login(string returnUrl, UserGroup? group)
		{
			if (User != null)
			{
				if (group == null || User.Group >= group)
				{
					return Redirect(HttpUtility.UrlDecode(returnUrl ?? "/"));
				}
				ViewData["UserGroup"] = group;
				ViewData["UserGroupName"] = UsersServiceClient.GetGroupName(group.Value);
			}

			return View();
		}

		public ActionResult Logout(string returnUrl)
		{
			Session.User = null;
			if (String.IsNullOrEmpty(returnUrl))
			{
				returnUrl = "/";
			}
			return Redirect(HttpUtility.UrlDecode(returnUrl));
		}
	}
}
