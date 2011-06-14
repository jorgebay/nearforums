using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.ServiceClient;
using NearForums.Web.UI;
using NearForums.Validation;
using NearForums.Web.Controllers.Filters;
using NearForums.Web.Extensions;

namespace NearForums.Web.Controllers
{
	public class ForumsController : BaseController
	{
		#region List
		public ActionResult List()
		{
			List<ForumCategory> list = null;
			list = ForumsServiceClient.GetList();
			ViewData["IsSiteSet"] = IsSiteSet;
			return View(list);
		}
		#endregion

		#region Manage
		[RequireAuthorization(UserGroup.Moderator)]
		public ActionResult Manage()
		{
			List<ForumCategory> list = ForumsServiceClient.GetList();
			return View(list);
		} 
		#endregion

		#region Detail
		public ActionResult Detail(string forum, int page)
		{
			Forum f = ForumsServiceClient.Get(forum);
			if (f == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			//Get the topics of the forum
			//Must Paginate the topics on the backend (Can be too many topics)
			f.Topics = TopicsServiceClient.GetByForum(f.Id, page * Config.Forums.TopicsPerPage, Config.Forums.TopicsPerPage);

			ViewData["Tags"] = TagsServiceClient.GetMostViewed(f.Id, Config.Forums.TagsCloudCount);
			ViewData["Page"] = page;
			ViewData["TotalTopics"] = f.TopicCount;

			return View(f);
		} 
		#endregion

		#region Latest topics
		public ActionResult LatestTopics(string forum, int page, ResultFormat format)
		{
			Forum f = ForumsServiceClient.Get(forum);
			if (f == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			//Get the topics of the forum
			//Must Page the topics on the backend (Can be too many topics)
			f.Topics = TopicsServiceClient.GetLatest(f.Id, page * Config.Forums.TopicsPerPage, Config.Forums.TopicsPerPage);
			if (format == ResultFormat.Html)
			{
				ViewData["Tags"] = TagsServiceClient.GetMostViewed(f.Id, Config.Forums.TagsCloudCount);
				ViewData["Page"] = page;
				ViewData["TotalTopics"] = f.TopicCount;
				return View("LatestTopics" + format.ToString(), f);
			}

			return ResultHelper.XmlViewResult(this, f, "LatestTopics" + format.ToString());
		}

		/// <summary>
		/// Get the latest topics on all forums
		/// </summary>
		/// <returns></returns>
		public ActionResult LatestAllTopics()
		{
			List<Topic> topics = TopicsServiceClient.GetLatest();

			return ResultHelper.XmlViewResult(this, topics);
		} 
		#endregion

		#region Unanswered topics
		public ActionResult ListUnansweredTopics(string forum)
		{
			Forum f = ForumsServiceClient.Get(forum);
			if (f == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			f.Topics = TopicsServiceClient.GetUnanswered(f.Id);

			return View(f);
		}

		[RequireAuthorization(UserGroup.Moderator)]
		public ActionResult ListAllUnansweredTopics()
		{
			List<Topic> topics = TopicsServiceClient.GetUnanswered();
			return View(topics);
		}
		#endregion

		#region Add / Edit / Delete
		#region Add
		[AcceptVerbs(HttpVerbs.Get)]
		[RequireAuthorization(UserGroup.Moderator)]
		public ActionResult Add()
		{
			SelectList categories = new SelectList(ForumsServiceClient.GetCategories(), "Id", "Name");
			ViewData["Categories"] = categories;
			return View("Edit");
		}

		[AcceptVerbs(HttpVerbs.Post)]
		[RequireAuthorization(UserGroup.Moderator)]
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
					ForumsServiceClient.Add(forum, this.User.Id);
				}
			}
			catch (ValidationException ex)
			{
				this.AddErrors(this.ModelState, ex);
			}
			if (ModelState.IsValid)
			{
				return RedirectToAction("Detail", new{forum=forum.ShortName});
			}
			else
			{
				SelectList categories = new SelectList(ForumsServiceClient.GetCategories(), "Id", "Name");
				ViewData["Categories"] = categories;
				return View("Edit", forum);
			}
		} 
		#endregion

		#region Edit
		[AcceptVerbs(HttpVerbs.Get)]
		[RequireAuthorization(UserGroup.Moderator)]
		public ActionResult Edit(string forum)
		{
			SelectList categories = new SelectList(ForumsServiceClient.GetCategories(), "Id", "Name");
			ViewData["Categories"] = categories;
			Forum f = ForumsServiceClient.Get(forum);
			if (f == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			ViewData["IsEdit"] = true;
			return View("Edit", f);
		}

		[AcceptVerbs(HttpVerbs.Post)]
		[RequireAuthorization(UserGroup.Moderator)]
		public ActionResult Edit(string forum, [Bind(Prefix = "")] Forum f)
		{
			try
			{
				//fill the short name to use it as key
				f.ShortName = forum;
				if (ModelState.IsValid)
				{
					ForumsServiceClient.Edit(f, this.User.Id);
				}
			}
			catch (ValidationException ex)
			{
				this.AddErrors(this.ModelState, ex);
			}
			if (ModelState.IsValid)
			{
				return RedirectToAction("Detail", new{forum=f.ShortName});
			}
			else
			{
				SelectList categories = new SelectList(ForumsServiceClient.GetCategories(), "Id", "Name");
				ViewData["Categories"] = categories;
				ViewData["IsEdit"] = true;
				return View("Edit", f);
			}
		} 
		#endregion

		#region Delete
		[AcceptVerbs(HttpVerbs.Post)]
		[RequireAuthorization(UserGroup.Moderator)]
		[ValidateAntiForgeryToken]
		public ActionResult Delete(string forum)
		{
			ForumsServiceClient.Delete(forum);

			return RedirectToAction("Manage");
		}
		#endregion
		#endregion

		#region Tag detail
		public ActionResult TagDetail(string forum, string tag, int page)
		{
			Forum f = ForumsServiceClient.Get(forum);
			if (f == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			f.Topics = TopicsServiceClient.GetByTag(tag, f.Id);
			ViewData["Page"] = page;
			ViewData["Tag"] = tag;
			return View(f);
		}
		#endregion
	}
}
