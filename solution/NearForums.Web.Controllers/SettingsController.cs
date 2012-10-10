using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Configuration;
using NearForums.Services;
using NearForums.Validation;

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
				try
				{
					Config.SaveSetting(element);
				}
				catch (ValidationException ex)
				{
					AddErrors(ModelState, ex);
				}
			}
			return View(element);
		}
	}
}
