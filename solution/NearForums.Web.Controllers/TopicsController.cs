using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.ServiceClient;
using NearForums.Web.Extensions;
using NearForums.Validation;
using NearForums.Web.Controllers.Filters;
using System.Web.Routing;
using NearForums.Web.Controllers.Helpers;

namespace NearForums.Web.Controllers
{
	public class TopicsController : BaseController
	{
		#region Detail
		[AddVisit]
		[ValidateReadAccess]
		public ActionResult Detail(int id, string name, string forum, int page)
		{
			var topic = TopicsServiceClient.Get(id, name);

			if (topic == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			if (topic.Forum.ShortName != forum)
			{
				//The topic could have been moved to another forum
				//Move permanently to the other forum's topic
				return ResultHelper.MovedPermanentlyResult(this, new{action="Detail", controller="Topics", id=id, name=name, forum=topic.Forum.ShortName});
			}

			topic.Messages = MessagesServiceClient.GetByTopic(id);
			//load related topics
			TopicsServiceClient.LoadRelatedTopics(topic, 5);

			ViewData["Page"] = page;
			//Defines that the message url should be full
			ViewData["FullUrl"] = true;

			return View(topic);
		} 
		#endregion

		#region Latest Messages
		[ValidateReadAccess]
		public ActionResult LatestMessages(int id, string name)
		{
			var topic = TopicsServiceClient.Get(id, name);

			if (topic == null)
			{
				return ResultHelper.NotFoundResult(this);
			}

			topic.Messages = MessagesServiceClient.GetByTopicLatest(id);

			return ResultHelper.XmlViewResult(this, topic);
		}
		#endregion

		#region Add
		[HttpGet]
		[RequireAuthorization]
		[PreventFlood]
		public ActionResult Add(string forum)
		{
			var f = ForumsServiceClient.Get(forum);
			if (!f.HasPostAccess(Role))
			{
				return ResultHelper.ForbiddenResult(this);
			}

			var topic = new Topic();
			topic.Forum = f;
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
				SubscriptionHelper.SetNotificationEmail(notify, email, Session, Config);
				
				topic.Forum = ForumsServiceClient.Get(forum);
				if (topic.Forum == null)
				{
					return ResultHelper.NotFoundResult(this);
				}
				if (!topic.Forum.HasPostAccess(Role))
				{
					return ResultHelper.ForbiddenResult(this);
				}

				topic.User = new User(User.Id, User.UserName);
				topic.ShortName = topic.Title.ToUrlSegment(64);
				topic.IsSticky = (topic.IsSticky && this.User.Role >= UserRole.Moderator);
				if (topic.Description != null)
				{
					topic.Description = topic.Description.SafeHtml().ReplaceValues();
				}

				if (ModelState.IsValid)
				{
					TopicsServiceClient.Create(topic, Request.UserHostAddress);
					SubscriptionHelper.Manage(notify, topic.Id, this.User.Id, this.User.Guid, this.Config);
				}
			}
			catch (ValidationException ex)
			{
				this.AddErrors(this.ModelState, ex);
			}

			if (ModelState.IsValid)
			{
				return RedirectToRoute(new{action="Detail",controller="Topics",id=topic.Id,name=topic.ShortName,forum=forum,page=0});
			}
			return View("Edit", topic);
		}
		#endregion

		#region Edit
		[HttpGet]
		[RequireAuthorization]
		public ActionResult Edit(int id, string name, string forum)
		{
			Topic topic = TopicsServiceClient.Get(id, name);

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
			ViewData["IsEdit"] = true;

			ViewData["notify"] = SubscriptionHelper.IsUserSubscribed(id, this.User.Id, this.Config);

			return View(topic);
		}

		[HttpPost]
		[RequireAuthorization]
		[ValidateInput(false)]
		[ValidateAntiForgeryToken]
		public ActionResult Edit(int id, string name, string forum, [Bind(Prefix = "", Exclude = "Forum")] Topic topic, bool notify, string email)
		{
			topic.Id = id;
			topic.Forum = ForumsServiceClient.Get(forum);
			if (topic.Forum == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			if (!topic.Forum.HasPostAccess(Role))
			{
				return ResultHelper.ForbiddenResult(this);
			}

			#region Check if user can edit
			if (this.User.Role < UserRole.Moderator)
			{
				//If the user is not moderator or admin: Check if the user that created of the topic is the same as the logged user
				var originalTopic = TopicsServiceClient.Get(id);
				if (User.Id != originalTopic.User.Id)
				{
					return ResultHelper.ForbiddenResult(this);
				}
				//The user cannot edit the sticky property
				topic.IsSticky = originalTopic.IsSticky;
			}
			#endregion

			try
			{
				SubscriptionHelper.SetNotificationEmail(notify, email, Session, Config);

				topic.User = new User(User.Id, User.UserName);
				topic.ShortName = name;
				if (topic.Description != null)
				{
					topic.Description = topic.Description.SafeHtml().ReplaceValues();
				}
				TopicsServiceClient.Edit(topic, Request.UserHostAddress);

				SubscriptionHelper.Manage(notify, topic.Id, User.Id, this.User.Guid, Config);

				return RedirectToRoute(new{action="Detail",controller="Topics",id=topic.Id,name=name,forum=forum});
			}
			catch (ValidationException ex)
			{
				this.AddErrors(this.ModelState, ex);
			}
			ViewData["IsEdit"] = true;

			return View(topic);
		}
		#endregion

		#region Client Paging
		/// <summary>
		/// Gets an amount (by config) of message items starting from initIndex
		/// </summary>
		[HttpPost]
		[ValidateReadAccess(RefuseOnFail=true)]
		public ActionResult PageMore(int id, string name, string forum, int from, int initIndex)
		{
			//load topic that contains messages
			var topic = TopicsServiceClient.GetMessagesFrom(id, from, Config.UI.MessagesPerPage, initIndex);
			if (topic == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			//Defines that the message url just be the anchor name
			ViewData["FullUrl"] = false;

			return View(false, topic);
		}

		[HttpPost]
		[ValidateReadAccess(RefuseOnFail = true)]
		public ActionResult PageUntil(int id, string name, string forum, int firstMsg, int lastMsg, int initIndex)
		{
			//load topic that contains messages
			var topic = TopicsServiceClient.GetMessages(id, firstMsg, lastMsg, initIndex);
			if (topic == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			//Defines that the message url just be the anchor name
			ViewData["FullUrl"] = false;

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
			Topic t = TopicsServiceClient.Get(id);
			if (t == null)
			{
				return ResultHelper.NotFoundResult(this, true);
			}

			return new MovedPermanentlyResult(new{action="Detail", controller="Topics", id=t.Id, name=t.ShortName,forum=t.Forum.ShortName});
		}
		#endregion

		#region Move / Close / Delete
		#region Delete
		[RequireAuthorization]
		public ActionResult Delete(int id, string name, string forum)
		{
			#region Check if user can edit
			if (this.User.Role < UserRole.Moderator)
			{
				//Check if the user that created of the topic is the same as the logged user
				Topic originalTopic = TopicsServiceClient.Get(id);
				if (this.User.Id != originalTopic.User.Id)
				{
					return ResultHelper.ForbiddenResult(this);
				}
			}
			#endregion

			TopicsServiceClient.Delete(id, this.User.Id, Request.UserHostAddress);

			return RedirectToAction("Detail", "Forums", new
			{
				forum = forum
			});
		}
		#endregion

		#region Move topic
		[HttpGet]
		[RequireAuthorization(UserRole.Moderator)]
		public ActionResult Move(int id, string name)
		{
			Topic topic = TopicsServiceClient.Get(id, name);

			if (topic == null)
			{
				return ResultHelper.NotFoundResult(this);
			}

			ViewData["Categories"] = ForumsServiceClient.GetList(Role);

			return View(topic);
		}

		[HttpPost]
		[RequireAuthorization(UserRole.Moderator)]
		public ActionResult Move(int id, string name, [Bind(Prefix = "", Exclude = "Id")] Topic t)
		{
			Topic savedTopic = TopicsServiceClient.Move(id, t.Forum.Id, this.User.Id, Request.UserHostAddress);
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
		[RequireAuthorization]
		public ActionResult CloseReplies(int id, string name)
		{
			#region Check if user can edit
			if (this.User.Role < UserRole.Moderator)
			{
				//Check if the user that created of the topic is the same as the logged user
				Topic originalTopic = TopicsServiceClient.Get(id);
				if (this.User.Id != originalTopic.User.Id)
				{
					return ResultHelper.ForbiddenResult(this);
				}
			}
			#endregion

			TopicsServiceClient.Close(id, this.User.Id, Request.UserHostAddress);

			return RedirectToAction("Detail");
		}

		/// <summary>
		/// Allow replies on the topic
		/// </summary>
		[RequireAuthorization]
		public ActionResult OpenReplies(int id, string name)
		{
			#region Check if user can edit
			if (this.User.Role < UserRole.Moderator)
			{
				//Check if the user that created of the topic is the same as the logged user
				Topic originalTopic = TopicsServiceClient.Get(id);
				if (this.User.Id != originalTopic.User.Id)
				{
					return ResultHelper.ForbiddenResult(this);
				}
			}
			#endregion

			TopicsServiceClient.Open(id, this.User.Id, Request.UserHostAddress);

			return RedirectToAction("Detail");
		}
		#endregion
		#endregion
	}
}
