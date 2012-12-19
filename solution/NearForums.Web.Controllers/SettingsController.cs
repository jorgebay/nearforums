using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Configuration;
using NearForums.Services;
using NearForums.Validation;
using NearForums.Web.Controllers.Filters;
using NearForums.Configuration.Spam;

namespace NearForums.Web.Controllers
{
	public class SettingsController : BaseController
	{
		/// <summary>
		/// Users service
		/// </summary>
		private readonly IUsersService _userService;

		public SettingsController(IUsersService service)
		{
			_userService = service;
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

		[HttpGet]
		[RequireAuthorization(UserRole.Admin)]
		public ActionResult EditUI()
		{
			return View(Config.UI.GetEditable<UIElement>());
		}

		[HttpPost]
		[ValidateAntiForgeryToken]
		[RequireAuthorization(UserRole.Admin)]
		public ActionResult EditUI(UIElement element)
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

		[HttpGet]
		[RequireAuthorization(UserRole.Admin)]
		public ActionResult EditSpamPrevention()
		{
			ViewBag.UserRoles = new SelectList(_userService.GetRoles(), "Key", "Value");
			return View(Config.SpamPrevention.GetEditable<SpamPreventionElement>());
		}

		[HttpPost]
		[ValidateAntiForgeryToken]
		[RequireAuthorization(UserRole.Admin)]
		public ActionResult EditSpamPrevention(SpamPreventionElement element)
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
			ViewBag.UserRoles = new SelectList(_userService.GetRoles(), "Key", "Value");
			return View(element);
		}

		/// <summary>
		/// Enables or disables the search engine on the website.
		/// </summary>
		/// <returns></returns>
		[HttpPost]
		[ValidateAntiForgeryToken]
		[RequireAuthorization(UserRole.Admin)]
		public ActionResult SearchToggle()
		{
			var isSearchEnabled = Config.Search.Enabled;
			var searchConfig = Config.Search.GetEditable<SearchElement>();
			searchConfig.Enabled = !isSearchEnabled;
			Config.SaveSetting(searchConfig);
			return RedirectToAction("Manage", "SearchEngine");
		}
	}
}
