﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Web.Controllers.Filters;
using NearForums.Services;
using NearForums.Web.Extensions;
using NearForums.Validation;
using System.Web.Security;
using NearForums.Web.Controllers.Helpers;

namespace NearForums.Web.Controllers
{
	public class UsersController : BaseController
	{
		/// <summary>
		/// User service
		/// </summary>
		private readonly IUsersService _service;

		/// <summary>
		/// Topic service
		/// </summary>
		private readonly ITopicsService _topicService;

		public UsersController(IUsersService service, ITopicsService topicService) : base(service)
		{
			_service = service;
			_topicService = topicService;
		}

		/// <summary>
		/// Bans a user permanently from the site
		/// </summary>
		/// <returns>Empty JSON</returns>
		[RequireAuthorization(UserRole.Moderator)]
		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult Ban(int id, ModeratorReason reason, string reasonText)
		{
			//Include the result of banning in the viewdata for tracking (testing)
			ViewData.Model = _service.Ban(id, User.Id, User.Role, reason, reasonText);
			return Json(null);
		}

		[RequireAuthorization(UserRole.Admin)]
		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult Delete(int id, string searched)
		{
			_service.Delete(id);
			return RedirectToAction("List", new
			{
				userName = searched,
				page = 0
			});
		}

		[RequireAuthorization(UserRole.Admin)]
		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult Demote(int id, string searched)
		{
			_service.Demote(id);
			return RedirectToAction("List", new
			{
				userName = searched,
				page = 0
			});
		}

		public ActionResult Detail(int id)
		{
			User user = _service.Get(id);
			if (user == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			//Get posted topics
			ViewData["Topics"] = _topicService.GetByUser(id, Role);

			return View(user);
		}

		[RequireAuthorization]
		[HttpGet]
		public ActionResult Edit(int id)
		{
			if (this.User.Id != id)
			{
				//Maybe handle a moderator/admin users
				return ResultHelper.ForbiddenResult(this);
			}
			var user = _service.Get(id);
			ViewBag.GravatarPhoto = _service.GetGravatarImageUrl(user);
			return View(user);
		}

		[RequireAuthorization]
		[HttpPost]
		public ActionResult Edit(int id, [Bind(Prefix = "")]User user)
		{
			if (this.User.Id != id)
			{
				//Future: Maybe handle a moderator/admin users
				return ResultHelper.ForbiddenResult(this);
			}
			try
			{
				user.Id = id;
				_service.Edit(user);

				//Update membership data
				if (Session.User.AuthenticatedBy(AuthenticationProvider.Membership) && !String.IsNullOrEmpty(user.Email))
				{
					if (HttpContext.User.Identity.Name == "")
					{
						throw new Exception("Identity can not be null.");
					}
					var membershipUser = MembershipProvider.GetUser(HttpContext.User.Identity.Name, false);
					membershipUser.Email = user.Email;
					MembershipProvider.UpdateUser(membershipUser);
				}

				this.User.UserName = user.UserName;
				this.User.Email = Utils.EmptyToNull(user.Email);

				return RedirectToAction("Detail", new { id = id });
			}
			catch (ValidationException ex)
			{
				this.AddErrors(this.ModelState, ex);
			}
			ViewBag.GravatarPhoto = _service.GetGravatarImageUrl(user);
			return View(user);
		}

		[RequireAuthorization(UserRole.Admin)]
		public ActionResult List(string userName, int page)
		{
			List<User> users = null;
			if (String.IsNullOrEmpty(userName))
			{
				users = _service.GetAll();
			}
			else
			{
				users = _service.GetByName(userName);
			}
			ViewBag.UserName = userName;
			ViewBag.Page = page;

			return View(users);
		}

		public ActionResult MessagesByUser(int id)
		{
			User user = _service.Get(id);
			if (user == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			//Get posted messages
			var topics = _topicService.GetTopicsAndMessagesByUser(id);
			return View(false, topics);
		}

		[RequireAuthorization(UserRole.Admin)]
		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult Promote(int id, string searched)
		{
			_service.Promote(id);
			return RedirectToAction("List", new
			{
				userName = searched,
				page = 0
			});
		}

		/// <summary>
		/// Suspends a user for a period of time
		/// </summary>
		/// <returns>Empty JSON</returns>
		[RequireAuthorization(UserRole.Moderator)]
		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult Suspend(int id, ModeratorReason reason, string reasonText, DateTime endDate)
		{
			ViewData.Model = _service.Suspend(id, User.Id, User.Role, reason, reasonText, endDate);
			return Json(ViewData.Model);
		}

		/// <summary>
		/// Warns the user of bad behaviour
		/// </summary>
		/// <returns>Empty JSON</returns>
		[RequireAuthorization(UserRole.Moderator)]
		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult Warn(int id, ModeratorReason reason, string reasonText)
		{
			ViewData.Model = _service.Warn(id, User.Id, User.Role, reason, reasonText);
			return Json(ViewData.Model);
		}

		/// <summary>
		/// Confirms that the user read the warning and dismisses the user message.
		/// </summary>
		/// <returns>Empty JSON</returns>
		[RequireAuthorization]
		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult WarnDismiss()
		{
			ViewData.Model = _service.WarnDismiss(User.Id);
			//TODO: Mark in session state that the warning was dismissed.
			throw new NotImplementedException();
			//return Json(ViewData.Model);
		}
	}
}