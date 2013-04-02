using System.Linq;
using System.Web.Mvc;
using NearForums.Services;
using NearForums.Web.Extensions;
using NearForums.Validation;
using NearForums.Web.Controllers.Filters;
using NearForums.Web.Controllers.Helpers;

namespace NearForums.Web.Controllers
{
	public class TopicsController : BaseController
	{
		/// <summary>
		/// Topic service
		/// </summary>
		private readonly ITopicsService _service;
		/// <summary>
		/// User service
		/// </summary>
		private readonly IUsersService _userService;
		/// <summary>
		/// Forum service
		/// </summary>
		private readonly IForumsService _forumService;
		/// <summary>
		/// Service that handles the subscriptions
		/// </summary>
		private readonly ITopicsSubscriptionsService _topicSubscriptionService;

		public TopicsController(ITopicsService service, IForumsService forumService, IUsersService userService, ITopicsSubscriptionsService topicSubscriptionService)
		{
			_service = service;
			_forumService = forumService;
			_userService = userService;
			_topicSubscriptionService = topicSubscriptionService;
		}

		#region Detail
		/// <summary>
		/// Topic detail page 
		/// </summary>
		/// <param name="name">topic short name</param>
		/// <param name="forum">forum short name</param>
		/// <param name="page">zero-based page index</param>
		[AddVisit]
		[ValidateReadAccess]
		public ActionResult Detail(int id, string name, string forum, int page)
		{
			var topic = _service.GetWithMessages(id, page * Config.UI.MessagesPerPage, Config.UI.MessagesPerPage);

			if (topic == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			if (topic.Forum.ShortName != forum)
			{
				//The topic could have been moved to another forum
				return ResultHelper.MovedPermanentlyResult(this, new{action="Detail", controller="Topics", id=id, name=name, forum=topic.Forum.ShortName});
			}

			_service.LoadRelatedTopics(topic, 5);

			ViewBag.Page = page;
			//Defines that the message url should be full
			ViewBag.FullUrl = true;

			return View(topic);
		}
		#endregion

		#region Latest Messages
		[ValidateReadAccess]
		public ActionResult LatestMessages(int id, string name)
		{
			var topic = _service.GetWithMessagesLatest(id, name);
			if (topic == null)
			{
				return ResultHelper.NotFoundResult(this);
			}

			return ResultHelper.XmlViewResult(this, topic);
		}
		#endregion

		#region Add
		[HttpGet]
		[RequireAuthorization]
		[PreventFlood]
		public ActionResult Add(string forum)
		{
			var f = _forumService.Get(forum);
			if (!f.HasPostAccess(Role))
			{
				return ResultHelper.ForbiddenResult(this);
			}

			var topic = new Topic();
			topic.Forum = f;
			//Default the right access to its parent. If less it will be overriden.
			topic.ReadAccessRole = f.ReadAccessRole;
			//Default, It can be less than its parent
			topic.PostAccessRole = f.PostAccessRole;
			var roles = _userService.GetRoles().Where(x => x.Key <= Role);
			ViewBag.UserRoles = new SelectList(roles, "Key", "Value");
			return View("Edit", topic);
		}

		[HttpPost]
		[RequireAuthorization]
		[ValidateInput(false)]
		[PreventFlood(typeof(RedirectToRouteResult))]
		[ValidateAntiForgeryToken]
		public ActionResult Add(string forum, [Bind(Prefix = "", Exclude = "Id,Forum")] Topic topic, bool notify, string email)
		{
			try
			{
				SubscriptionHelper.SetNotificationEmail(notify, email, Session, Config, _userService);
				
				topic.Forum = _forumService.Get(forum);
				if (topic.Forum == null)
				{
					return ResultHelper.NotFoundResult(this);
				}
				if (!topic.Forum.HasPostAccess(Role))
				{
					return ResultHelper.ForbiddenResult(this);
				}

				topic.ShortName = topic.Title.ToUrlSegment(64);
				topic.IsSticky = (topic.IsSticky && this.User.Role >= UserRole.Moderator);
				if (ModelState.IsValid)
				{
					_service.Create(topic, Request.UserHostAddress, User.ToUser());
					SubscriptionHelper.Manage(notify, topic.Id, this.User.Id, this.User.Guid, this.Config, _topicSubscriptionService);
					return RedirectToRoute(new { action = "Detail", controller = "Topics", id = topic.Id, name = topic.ShortName, forum = forum, page = 0 });
				}
			}
			catch (ValidationException ex)
			{
				this.AddErrors(this.ModelState, ex);
			}
			var roles = _userService.GetRoles().Where(x => x.Key <= Role);
			ViewBag.UserRoles = new SelectList(roles, "Key", "Value");
			return View("Edit", topic);
		}
		#endregion

		#region Edit
		[HttpGet]
		[RequireAuthorization]
		[ValidateReadAccess]
		public ActionResult Edit(int id, string name, string forum)
		{
			Topic topic = _service.Get(id, name);

			if (topic == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			#region Check if user can edit
			if (this.User.Role < UserRole.Moderator && this.User.Id != topic.User.Id)
			{
				return ResultHelper.ForbiddenResult(this);
			}
			#endregion
			ViewBag.IsEdit = true;
			ViewBag.notify = SubscriptionHelper.IsUserSubscribed(id, this.User.Id, this.Config, _topicSubscriptionService);
			var roles = _userService.GetRoles().Where(x => x.Key <= Role);
			ViewBag.UserRoles = new SelectList(roles, "Key", "Value");

			return View(topic);
		}

		[HttpPost]
		[RequireAuthorization]
		[ValidateInput(false)]
		[ValidateAntiForgeryToken]
		public ActionResult Edit(int id, string name, string forum, [Bind(Prefix = "", Exclude = "Forum")] Topic topic, bool notify, string email)
		{
			topic.Id = id;
			topic.Forum = _forumService.Get(forum);
			if (topic.Forum == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			if (!topic.Forum.HasPostAccess(Role))
			{
				return ResultHelper.ForbiddenResult(this);
			}

			#region Check if user can edit
			var originalTopic = _service.Get(id);
			if (User.Role < UserRole.Moderator)
			{
				//If the user is not moderator or admin: Check if the user that created of the topic is the same as the logged user
				if (User.Id != originalTopic.User.Id)
				{
					return ResultHelper.ForbiddenResult(this);
				}
				//The user cannot edit the sticky property
				topic.IsSticky = originalTopic.IsSticky;
			}
			else if (!originalTopic.HasReadAccess(Role))
			{
				return ResultHelper.ForbiddenResult(this);
			}
			#endregion

			try
			{
				SubscriptionHelper.SetNotificationEmail(notify, email, Session, Config, _userService);

				topic.ShortName = name;
				_service.Edit(topic, Request.UserHostAddress, User.ToUser());
				SubscriptionHelper.Manage(notify, topic.Id, User.Id, this.User.Guid, Config, _topicSubscriptionService);
				return RedirectToRoute(new{action="Detail",controller="Topics",id=topic.Id,name=name,forum=forum});
			}
			catch (ValidationException ex)
			{
				this.AddErrors(this.ModelState, ex);
			}
			ViewBag.IsEdit = true;
			var roles = _userService.GetRoles().Where(x => x.Key <= Role);
			ViewBag.UserRoles = new SelectList(roles, "Key", "Value");

			return View(topic);
		}
		#endregion

		#region Client Paging
		/// <summary>
		/// Gets an amount (by config) of message items starting from index
		/// </summary>
		[HttpPost]
		[ValidateReadAccess(RefuseOnFail=true)]
		public ActionResult PageMore(int id, string name, string forum, int from)
		{
			var topic = _service.GetWithMessages(id, from, Config.UI.MessagesPerPage);
			if (topic == null)
			{
				return ResultHelper.NotFoundResult(this);
			}

			return View(false, topic);
		}

		[HttpPost]
		[ValidateReadAccess(RefuseOnFail = true)]
		public ActionResult PageUntil(int id, string name, string forum, int firstMsg, int lastMsg)
		{
			var topic = _service.GetWithMessages(id, firstMsg, lastMsg-firstMsg);
			if (topic == null)
			{
				return ResultHelper.NotFoundResult(this);
			}

			return View(false, "PageMore", topic);
		}
		#endregion

		#region Short Urls
		/// <summary>
		/// Gets the topic by id and redirects to the long relative url
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>
		public ActionResult ShortUrl(int id)
		{
			Topic t = _service.Get(id);
			if (t == null)
			{
				return ResultHelper.NotFoundResult(this, true);
			}

			return new MovedPermanentlyResult(new{action="Detail", controller="Topics", id=t.Id, name=t.ShortName,forum=t.Forum.ShortName});
		}
		#endregion

		#region Move / Close / Delete
		#region Delete
		[HttpPost]
		[RequireAuthorization]
		[ValidateAntiForgeryToken]
		public ActionResult Delete(int id, string name, string forum)
		{
			#region Check if user can edit
			var originalTopic = _service.Get(id);
			if (this.User.Role < UserRole.Moderator)
			{
				//Check if the user that created of the topic is the same as the logged user
				if (this.User.Id != originalTopic.User.Id)
				{
					return ResultHelper.ForbiddenResult(this);
				}
			}
			else if (!originalTopic.HasReadAccess(Role))
			{
				return ResultHelper.ForbiddenResult(this);
			}			
			#endregion

			_service.Delete(id, this.User.Id, Request.UserHostAddress);

			return Json(new { nextUrl=Url.Action("Detail", "Forums", new{ forum = forum})});
		}
		#endregion

		#region Move topic
		[HttpGet]
		[RequireAuthorization(UserRole.Moderator)]
		[ValidateReadAccess]
		public ActionResult Move(int id, string name)
		{
			var topic = _service.Get(id, name);
			if (topic == null)
			{
				return ResultHelper.NotFoundResult(this);
			}

			ViewBag.Categories = _forumService.GetList(Role);
			return View(topic);
		}

		[HttpPost]
		[RequireAuthorization(UserRole.Moderator)]
		[ValidateAntiForgeryToken]
		public ActionResult Move(int id, string name, [Bind(Prefix = "", Exclude = "Id")] Topic t)
		{
			Topic savedTopic = _service.Move(id, t.Forum.Id, this.User.Id, Request.UserHostAddress);
			return RedirectToAction("Detail", new
			{
				forum = savedTopic.Forum.ShortName
			});
		}
		#endregion

		#region Close
		/// <summary>
		/// Disallow replies on the topic
		/// </summary>
		[HttpPost]
		[RequireAuthorization]
		[ValidateAntiForgeryToken]
		public ActionResult CloseReplies(int id, string name)
		{
			#region Check if user can edit
			var originalTopic = _service.Get(id);
			if (Role < UserRole.Moderator)
			{
				//Check if the user that created of the topic is the same as the logged user
				if (this.User.Id != originalTopic.User.Id)
				{
					return ResultHelper.ForbiddenResult(this);
				}
			}
			else if (!originalTopic.HasReadAccess(Role))
			{
				return ResultHelper.ForbiddenResult(this);
			}
			#endregion

			_service.Close(id, this.User.Id, Request.UserHostAddress);

			return new EmptyResult();
		}

		/// <summary>
		/// Allow replies on the topic
		/// </summary>
		[HttpPost]
		[RequireAuthorization]
		[ValidateAntiForgeryToken]
		public ActionResult OpenReplies(int id, string name)
		{
			#region Check if user can edit
			var originalTopic = _service.Get(id);
			if (this.User.Role < UserRole.Moderator)
			{
				//Check if the user that created of the topic is the same as the logged user
				if (this.User.Id != originalTopic.User.Id)
				{
					return ResultHelper.ForbiddenResult(this);
				}
			}
			else if (!originalTopic.HasReadAccess(Role))
			{
				return ResultHelper.ForbiddenResult(this);
			}
			#endregion

			_service.Open(id, this.User.Id, Request.UserHostAddress);

			return new EmptyResult();
		}
		#endregion
		#endregion
	}
}
