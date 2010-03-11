using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

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

		public ActionResult Login(string returnUrl)
		{
			if (User != null)
			{
				return Redirect(HttpUtility.UrlDecode(returnUrl));
			}
			return View();
		}
	}
}
