using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Web.Controllers.Filters;
using NearForums.ServiceClient;

namespace NearForums.Web.Controllers
{
	public class UsersController : BaseController
	{
		public ActionResult Detail(int id)
		{
			User user = UsersServiceClient.Get(id);
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
	}
}