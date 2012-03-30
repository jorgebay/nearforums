using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Web.UI;
using NearForums.Validation;
using NearForums.Web.Controllers.Filters;
using NearForums.Web.Extensions;
using NearForums.Configuration;
using NearForums.Web.Controllers.Helpers;
using NearForums.Services;
using NearForums.ServiceClient;

namespace NearForums.Web.Controllers
{
	public class ForumsController : BaseController
	{
		/// <summary>
		/// Forum service
		/// </summary>
		private readonly IForumsService service;
		public ForumsController(IForumsService serv)
		{
			service = serv;
		}

		#region List
		public ActionResult List()
		{
			var list = service.GetList(Role);
			if (list.Count == 0)
			{
				ViewBag.ShowFirstSteps = !UsersServiceClient.IsThereAnyUser();
			}
			return View(list);
		}
		#endregion

		#region Manage
		[RequireAuthorization(UserRole.Moderator)]
		public ActionResult Manage()
		{
			var list = service.GetList(Role);
			return View(list);
		} 
		#endregion

		#region Detail
		[ValidateReadAccess]
		public ActionResult Detail(string forum, int page)
		{
			if (Config.UI.DefaultForumSort == ForumSort.LatestActivity)
			{
				return LatestTopics(forum, page, ResultFormat.Html);
			}
			return MostViewedTopics(forum, page);
		} 
		#endregion

		#region Most Viewed topics
		[ValidateReadAccess]
		public ActionResult MostViewedTopics(string forum, int page)
		{
			var f = service.Get(forum);
			if (f == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			//Get the topics of the forum
			//Must Paginate the topics on the backend (Can be too many topics)
			f.Topics = TopicsServiceClient.GetByForum(f.Id, page * Config.UI.TopicsPerPage, Config.UI.TopicsPerPage, Role);

			ViewData["Tags"] = TagsServiceClient.GetMostViewed(f.Id, Config.UI.TagsCloudCount);
			ViewData["Page"] = page;
			ViewData["TotalTopics"] = f.TopicCount;

			return View("Detail", f);
		}
		#endregion

		#region Latest topics
		[ValidateReadAccess]
		public ActionResult LatestTopics(string forum, int page, ResultFormat format)
		{
			var f = service.Get(forum);
			if (f == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			//Get the topics of the forum
			//Must Page the topics on the backend (Can be too many topics)
			f.Topics = TopicsServiceClient.GetLatest(f.Id, page * Config.UI.TopicsPerPage, Config.UI.TopicsPerPage, Role);
			if (format == ResultFormat.Html)
			{
				ViewData["Tags"] = TagsServiceClient.GetMostViewed(f.Id, Config.UI.TagsCloudCount);
				ViewData["Page"] = page;
				ViewData["TotalTopics"] = f.TopicCount;
				return View("Detail", f);
			}

			return ResultHelper.XmlViewResult(this, f, "LatestTopicsRss");
		}

		/// <summary>
		/// Get the latest topics on all forums
		/// </summary>
		/// <returns></returns>
		public ActionResult LatestAllTopics()
		{
			var topics = TopicsServiceClient.GetLatest();

			return ResultHelper.XmlViewResult(this, topics);
		} 
		#endregion

		#region Unanswered topics
		[ValidateReadAccess]
		public ActionResult ListUnansweredTopics(string forum)
		{
			Forum f = service.Get(forum);
			if (f == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			f.Topics = TopicsServiceClient.GetUnanswered(f.Id, Role);

			return View(f);
		}

		[RequireAuthorization(UserRole.Moderator)]
		public ActionResult ListAllUnansweredTopics()
		{
			List<Topic> topics = TopicsServiceClient.GetUnanswered();
			return View(topics);
		}
		#endregion

		#region Add / Edit / Delete
		#region Add
		[HttpGet]
		[RequireAuthorization(UserRole.Moderator)]
		public ActionResult Add()
		{
			var roles = UsersServiceClient.GetRoles().Where(x => x.Key <= Role);
			ViewBag.UserRoles = new SelectList(roles, "Key", "Value");
			ViewBag.Categories = new SelectList(service.GetCategories(), "Id", "Name");
			return View("Edit");
		}

		[HttpPost]
		[RequireAuthorization(UserRole.Moderator)]
		[ValidateAntiForgeryToken]
		public ActionResult Add([Bind(Prefix = "", Exclude = "Id")] Forum forum)
		{
			try
			{
				if (!String.IsNullOrEmpty(forum.Name))
				{
					forum.ShortName = forum.Name.ToUrlSegment(32);
				}
				if (ModelState.IsValid)
				{
					service.Add(forum, this.User.Id);
					return RedirectToAction("Detail", new{forum=forum.ShortName});
				}
			}
			catch (ValidationException ex)
			{
				this.AddErrors(this.ModelState, ex);
			}
			var roles = UsersServiceClient.GetRoles().Where(x => x.Key <= Role);
			ViewBag.UserRoles = new SelectList(roles, "Key", "Value");
			ViewBag.Categories = new SelectList(service.GetCategories(), "Id", "Name");
			return View("Edit", forum);
		} 
		#endregion

		#region Edit
		[HttpGet]
		[RequireAuthorization(UserRole.Moderator)]
		public ActionResult Edit(string forum)
		{
			var f = service.Get(forum);
			if (f == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			if (!f.HasPostAccess(Role))
			{
				return ResultHelper.ForbiddenResult(this);
			}
			var roles = UsersServiceClient.GetRoles().Where(x => x.Key <= Role);
			ViewBag.UserRoles = new SelectList(roles, "Key", "Value");
			ViewBag.Categories = new SelectList(service.GetCategories(), "Id", "Name");
			ViewBag.IsEdit = true;
			return View("Edit", f);
		}

		[HttpPost]
		[RequireAuthorization(UserRole.Moderator)]
		[ValidateAntiForgeryToken]
		public ActionResult Edit(string forum, [Bind(Prefix = "")] Forum f)
		{
			try
			{
				#region Check access rights
				var originalForum = service.Get(forum);
				if (originalForum == null)
				{
					return ResultHelper.NotFoundResult(this);
				}
				if (!originalForum.HasPostAccess(Role))
				{
					return ResultHelper.ForbiddenResult(this);
				} 
				#endregion

				f.ShortName = forum;
				if (ModelState.IsValid)
				{
					service.Edit(f, User.Id);
					return RedirectToAction("Detail", new{forum=f.ShortName});
				}
			}
			catch (ValidationException ex)
			{
				AddErrors(this.ModelState, ex);
			}
			var roles = UsersServiceClient.GetRoles().Where(x => x.Key <= Role);
			ViewBag.UserRoles = new SelectList(roles, "Key", "Value");
			ViewBag.Categories = new SelectList(service.GetCategories(), "Id", "Name");
			ViewBag.IsEdit = true;
			return View("Edit", f);
		}
		#endregion

		#region Delete
		[AcceptVerbs(HttpVerbs.Post)]
		[RequireAuthorization(UserRole.Moderator)]
		[ValidateAntiForgeryToken]
		public ActionResult Delete(string forum)
		{
			service.Delete(forum);

			return RedirectToAction("Manage");
		}
		#endregion
		#endregion

		#region Tag detail
		[ValidateReadAccess]
		public ActionResult TagDetail(string forum, string tag, int page)
		{
			Forum f = service.Get(forum);
			if (f == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			f.Topics = TopicsServiceClient.GetByTag(tag, f.Id, Role);
			ViewData["Page"] = page;
			ViewData["Tag"] = tag;
			return View(f);
		}
		#endregion
	}
}
