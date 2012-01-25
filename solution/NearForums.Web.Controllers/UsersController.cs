using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Web.Controllers.Filters;
using NearForums.ServiceClient;
using NearForums.Web.Extensions;
using NearForums.Validation;
using System.Web.Security;

namespace NearForums.Web.Controllers
{
	public class UsersController : BaseController
	{
		public ActionResult Detail(int id)
		{
			User user = UsersServiceClient.Get(id);
			if (user == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			//Get posted topics
			ViewData["Topics"] = TopicsServiceClient.GetByUser(id);

			return View(user);
		}

		[RequireAuthorization(UserRole.Admin)]
		public ActionResult List(string userName, int page)
		{
			List<User> users = null;
			if (String.IsNullOrEmpty(userName))
			{
				users = UsersServiceClient.GetAll();
			}
			else
			{
				users = UsersServiceClient.GetByName(userName);
			}
			ViewBag.UserName = userName;
			ViewBag.Page = page;

			return View(users);
		}

		public ActionResult MessagesByUser(int id)
		{
			User user = UsersServiceClient.Get(id);
			if (user == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			//Get posted messages (ordered 
			List<Topic> topics = TopicsServiceClient.GetTopicsAndMessagesByUser(id);
			return View(false, topics);
		}

		#region Edit
		[RequireAuthorization]
		[AcceptVerbs(HttpVerbs.Get)]
		public ActionResult Edit(int id)
		{
			if (this.User.Id != id)
			{
				//Maybe handle a moderator/admin users
				return ResultHelper.ForbiddenResult(this);
			}
			User user = UsersServiceClient.Get(id);
			return View(user);
		}

		[RequireAuthorization]
		[AcceptVerbs(HttpVerbs.Post)]
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
				UsersServiceClient.Edit(user);
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
			UsersServiceClient.Promote(id);
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
			UsersServiceClient.Demote(id);
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
			UsersServiceClient.Delete(id);
			return RedirectToAction("List", new
			{
				userName = searched,
				page = 0
			});
		}
		#endregion
	}
}