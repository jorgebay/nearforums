using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Web.Controllers.Filters;
using NearForums.ServiceClient;
using NearForums.Web.Extensions;
using NearForums.Validation;

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
		
		[RequireAuthorization(UserGroup.Admin)]
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
			ViewData["userName"] = userName;
			ViewData["page"] = page;

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
			return View(topics);
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
				//Maybe handle a moderator/admin users
				return ResultHelper.ForbiddenResult(this);
			}
			try
			{
				user.Id = id;
				UsersServiceClient.Edit(user);
				return RedirectToAction("Detail", new{id=id});
			}
			catch (ValidationException ex)
			{
				this.AddErrors(this.ModelState, ex);
			}
			return View(user);
		} 
		#endregion

		#region Promote / Demote / Delete
		[RequireAuthorization(UserGroup.Admin)]
		public ActionResult Promote(int id, string searched)
		{
			UsersServiceClient.Promote(id);
			return RedirectToAction("List", new
			{
				userName = searched,
				page = 0
			});
		}

		[RequireAuthorization(UserGroup.Admin)]
		public ActionResult Demote(int id, string searched)
		{
			UsersServiceClient.Demote(id);
			return RedirectToAction("List", new
			{
				userName = searched,
				page=0
			});
		}

		[RequireAuthorization(UserGroup.Admin)]
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