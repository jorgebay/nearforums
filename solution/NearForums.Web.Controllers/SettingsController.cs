using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Configuration;

namespace NearForums.Web.Controllers
{
	public class SettingsController : BaseController
	{
		[HttpGet]
		public ActionResult EditUI()
		{

			return View();
		}

		[HttpPost]
		public ActionResult EditUI(UIElement ui)
		{
			return View();
		}
	}
}
