using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.ServiceClient;
using NearForums.Web.UI;

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
			//Get the topics of the forum
			//Must Page the topics on the backend (Can be too many topics)
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

		#region Add / Edit
		#region Add
		[AcceptVerbs(HttpVerbs.Get)]
		public ActionResult Add()
		{
			return View("Edit");
		}

		[AcceptVerbs(HttpVerbs.Post)]
		public ActionResult Add([Bind(Prefix = "", Exclude = "Id")] Forum forum)
		{
			return View("Edit", forum);
		} 
		#endregion

		#region Edit
		
		#endregion
		#endregion
	}
}
