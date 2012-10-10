using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Configuration;
using NearForums.Services;
using NearForums.Validation;
using NearForums.Web.Controllers.Filters;

namespace NearForums.Web.Controllers
{
	public class SettingsController : BaseController
	{
		public SettingsController(IUsersService service)
			: base(service)
		{

		}

		[HttpGet]
		[RequireAuthorization(UserRole.Admin)]
		public ActionResult EditGeneral()
		{
			return View(Config.General.GetEditable<GeneralElement>());
		}

		[HttpPost]
		[ValidateAntiForgeryToken]
		[RequireAuthorization(UserRole.Admin)]
		public ActionResult EditGeneral(GeneralElement element)
		{
			if (ModelState.IsValid)
			{
				try
				{
					Config.SaveSetting(element);
					return RedirectToAction("Dashboard", "Admin");
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
