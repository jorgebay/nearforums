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
			List<ForumCategory> list = ForumsServiceClient.GetList();
			return View(list);
		}
		#endregion

		#region Manage
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

			return View(false, "LatestTopics" + format.ToString(), f);
		}

		public ActionResult LatestAllTopics()
		{
			//Get the latest topics
			List<Topic> topics = TopicsServiceClient.GetLatest();

			return View(false, topics);
		} 
		#endregion

		#region Unanswered topics
		public ActionResult ListUnansweredTopics(string forum)
		{
			Forum f = ForumsServiceClient.Get(forum);
			f.Topics = TopicsServiceClient.GetUnanswered(f.Id);

			return View(f);
		}
		#endregion

		#region Add / Edit
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
					forum.ShortName = Utils.ToUrlFragment(forum.Name, 32);
				}
				ForumsServiceClient.Add(forum, this.User.Id);
				return RedirectToAction("Manage");
			}
			catch (ValidationException ex)
			{
				this.AddErrors(this.ModelState, ex);
			}
			SelectList categories = new SelectList(ForumsServiceClient.GetCategories(), "Id", "Name");
			ViewData["Categories"] = categories;
			return View("Edit", forum);
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

				ForumsServiceClient.Edit(f, this.User.Id);
				return RedirectToAction("Manage");
			}
			catch (ValidationException ex)
			{
				this.AddErrors(this.ModelState, ex);
			}
			SelectList categories = new SelectList(ForumsServiceClient.GetCategories(), "Id", "Name");
			ViewData["Categories"] = categories;
			ViewData["IsEdit"] = true;
			return View("Edit", f);
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
