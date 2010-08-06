using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NearForums.Web.Controllers.Helpers;
using NearForums.ServiceClient;
using NearForums.Web.Extensions;

namespace NearForums.Web.Controllers
{
	public class HomeController : BaseController
	{
		public ActionResult Index()
		{
			return View(null, "Site", null);
		}

		public ActionResult About()
		{
			return Static("About", true);
		}
	}
}
