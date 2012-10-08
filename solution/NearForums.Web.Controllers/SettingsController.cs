using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Configuration;
using NearForums.Services;

namespace NearForums.Web.Controllers
{
	public class SettingsController : BaseController
	{
		public SettingsController(IUsersService service)
			: base(service)
		{

		}

		[HttpGet]
		public ActionResult EditGeneral()
		{
			return View(Config.General.GetEditable<GeneralElement>());
		}

		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult EditGeneral(GeneralElement element)
		{
			if (ModelState.IsValid)
			{
				Config.General = element;
				Config.SaveSettings();
			}
			return View(element);
		}
	}
}
