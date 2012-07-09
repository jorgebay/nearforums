using System;
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
			//Get posted messages (ordered 
			var topics = _topicService.GetTopicsAndMessagesByUser(id);
			return View(false, topics);
		}

		#region Edit
		[RequireAuthorization]
		[HttpGet]
		public ActionResult Edit(int id)
		{
			if (this.User.Id != id)
			{
				//Maybe handle a moderator/admin users
				return ResultHelper.ForbiddenResult(this);
			}
			User user = _service.Get(id);
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
				#region Update membership data
				if (Session.User.Provider == AuthenticationProvider.Membership && !String.IsNullOrEmpty(user.Email))
				{
					var membershipUser = Membership.GetUser();
					membershipUser.Email = user.Email;
					Membership.UpdateUser(membershipUser);
				}
				#endregion
				#region Adapt values
				this.User.UserName = user.UserName;
				this.User.Email = Utils.EmptyToNull(user.Email);
				#endregion
				return RedirectToAction("Detail", new { id = id });
			}
			catch (ValidationException ex)
			{
				this.AddErrors(this.ModelState, ex);
			}
			return View(user);
		}
		#endregion

		#region Promote / Demote / Delete
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
		#endregion
	}
}