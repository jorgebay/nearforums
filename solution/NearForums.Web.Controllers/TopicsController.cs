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

namespace NearForums.Web.Controllers
{
	public class TopicsController : BaseController
	{
		#region Detail
		[AddVisit]
		public ActionResult Detail(int id, string name, string forum, int page)
		{
			Topic topic = TopicsServiceClient.Get(id);

			#region The shortname must match
			if (topic != null)
			{
				if (topic.ShortName != name)
				{
					topic = null;
				}
				else if(topic.Forum.ShortName != forum)
				{
					//The topic could have been moved to another forum
					//Move permanently to the other forum's topic
					return ResultHelper.MovedPermanentlyResult(this, new{action="Detail", controller="Topics", id=id, name=name, forum=topic.Forum.ShortName});
				}
			}
			#endregion

			if (topic == null)
			{
				return ResultHelper.NotFoundResult(this);
			}

			//get messages
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
		public ActionResult LatestMessages(int id, string name)
		{
			Topic topic = TopicsServiceClient.Get(id);
			#region The shortname must match
			if (topic != null && topic.ShortName.ToUpper() != name.ToUpper())
			{
				topic = null;
			}
			#endregion

			if (topic == null)
			{
				return ResultHelper.NotFoundResult(this);
			}

			topic.Messages = MessagesServiceClient.GetByTopicLatest(id);
			return View(false, topic);
		}
		#endregion

		#region Add
		[AcceptVerbs(HttpVerbs.Get)]
		[RequireAuthorization]
		public ActionResult Add(string forum)
		{
			Forum f = ForumsServiceClient.Get(forum);
			Topic topic = new Topic();
			topic.Forum = f;

			return View("Edit", topic);
		}

		[AcceptVerbs(HttpVerbs.Post)]
		[RequireAuthorization]
		[ValidateInput(false)]
		public ActionResult Add(string forum, [Bind(Prefix = "", Exclude = "Id")] Topic topic)
		{
			try
			{
				topic.Forum = new Forum(){ShortName=forum};
				topic.User = new User(User.Id, User.UserName);
				topic.ShortName = Utils.ToUrlFragment(topic.Title, 64);
				topic.IsSticky = (topic.IsSticky && this.User.Group >= UserGroup.Moderator);
				if (topic.Description != null)
				{
					topic.Description = topic.Description.ReplaceValues();
				}

				TopicsServiceClient.Create(topic, Request.UserHostAddress);
				return RedirectToRoute(new{action="Detail",controller="Topics",id=topic.Id,name=topic.ShortName,forum=forum,page=0});
			}
			catch (ValidationException ex)
			{
				this.AddErrors(this.ModelState, ex);
			}

			topic.Forum = ForumsServiceClient.Get(forum);
			return View("Edit", topic);
		}
		#endregion

		#region Edit
		[AcceptVerbs(HttpVerbs.Get)]
		[RequireAuthorization]
		public ActionResult Edit(int id, string name)
		{
			Topic topic = TopicsServiceClient.Get(id);
			#region The shortname must match
			if (topic != null && topic.ShortName.ToUpper() != name.ToUpper())
			{
				topic = null;
			}
			#endregion

			if (topic == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			#region Check if user can edit
			if (this.User.Group < UserGroup.Moderator && this.User.Id != topic.User.Id)
			{
				return ResultHelper.ForbiddenResult(this);
			}
			#endregion
			ViewData["IsEdit"] = true;

			return View(topic);
		}

		[AcceptVerbs(HttpVerbs.Post)]
		[RequireAuthorization]
		[ValidateInput(false)]
		public ActionResult Edit(int id, string name, string forum, [Bind(Prefix = "")] Topic topic)
		{
			topic.Id = id;
			try
			{
				#region Check if user can edit
				if (this.User.Group < UserGroup.Moderator)
				{
					//The user is not moderator or admin
					//Check if the user that created of the topic is the same as the logged user
					Topic originalTopic = TopicsServiceClient.Get(id);
					if (this.User.Id != originalTopic.User.Id)
					{
						return ResultHelper.ForbiddenResult(this);
					}
					//The user can not edit the sticky property
					topic.IsSticky = originalTopic.IsSticky;
				}
				#endregion
				topic.Forum = new Forum(){ShortName=forum};
				topic.User = new User(User.Id, User.UserName);
				topic.ShortName = name;
				if (topic.Description != null)
				{
					topic.Description = topic.Description.ReplaceValues();
				}
				TopicsServiceClient.Edit(topic, Request.UserHostAddress);

				return RedirectToRoute(new{action="Detail",controller="Topics",id=topic.Id,name=name,forum=forum});
			}
			catch (ValidationException ex)
			{
				this.AddErrors(this.ModelState, ex);
			}
			topic.Forum = ForumsServiceClient.Get(forum);
			ViewData["IsEdit"] = true;

			return View(topic);
		}
		#endregion

		#region Client Paging
		[AcceptVerbs(HttpVerbs.Post)]
		public ActionResult PageMore(int id, string name, string forum, int from, int initIndex)
		{
			//load messages
			List<Message> messages = MessagesServiceClient.GetByTopicFrom(id, from, Config.Topics.MessagesPerPage, initIndex);
			//Defines that the message url just be the anchor name
			ViewData["FullUrl"] = false;

			return View(messages);
		}

		[AcceptVerbs(HttpVerbs.Post)]
		public ActionResult PageUntil(int id, string name, string forum, int firstMsg, int lastMsg, int initIndex)
		{
			//load messages
			List<Message> messages = MessagesServiceClient.GetByTopic(id, firstMsg, lastMsg, initIndex);
			//Defines that the message url just be the anchor name
			ViewData["FullUrl"] = false;

			return View("PageMore", messages);
		} 
		#endregion

		#region Short Urls
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

		#region Reply
		/// <summary>
		/// Loads the reply form
		/// </summary>
		/// <param name="id">thread id</param>
		/// <param name="msg">Message id of the message being quoted.</param>
		[AcceptVerbs(HttpVerbs.Get)]
		[RequireAuthorization]
		public ActionResult Reply(int id, string name, int? msg)
		{
			Message message = new Message();
			message.Topic = TopicsServiceClient.Get(id);
			if (msg != null)
			{
				message.InReplyOf = new Message(msg.Value);
			}
			#region Shortname must match
			if (message.Topic != null && message.Topic.ShortName.ToUpper() != name.ToUpper())
			{
				message.Topic = null;
			}
			#endregion

			if (message.Topic == null)
			{
				return ResultHelper.NotFoundResult(this);
			}

			#region Check if topic is closed for replies
			if (message.Topic.IsClosed)
			{
				return ResultHelper.ForbiddenResult(this);
			}
			#endregion

			var usersSubscribed = TopicsSubscriptionsServiceClient.GetSubscribed(id);
			ViewData["notify"] = usersSubscribed.Any(x => x.Id == this.User.Id);

			return View(message);
		}

		/// <summary>
		/// Saves the message or Loads the reply form to allow the user to clear error messages
		/// </summary>
		/// <param name="id">thread id</param>
		/// <param name="msg">Message id of the message being quoted.</param>
		[AcceptVerbs(HttpVerbs.Post)]
		[RequireAuthorization]
		[ValidateInput(false)]
		public ActionResult Reply([Bind(Prefix = "", Exclude = "Id")] Message message, int id, string name, string forum, int? msg, bool notify, string email)
		{
			message.Topic = TopicsServiceClient.Get(id);
			try
			{
				if (notify)
				{
					if (this.User.Email == null)
					{
						UsersServiceClient.AddEmail(this.User.Id, email, EmailPolicy.SendFromSubscriptions);
						this.User.Email = email;
					}
				}

				TopicsSubscriptionsServiceClient.Manage(notify, message.Topic.Id, this.User.Id, this.User.Guid);


				#region Check topic
				if (message.Topic == null)
				{
					return ResultHelper.NotFoundResult(this);
				}
				if (message.Topic.IsClosed)
				{
					return ResultHelper.ForbiddenResult(this);
				}
				#endregion
				message.Body = message.Body.ReplaceValues();
				message.User = Session.User.ToUser();
				if (msg != null)
				{
					message.InReplyOf = new Message(msg.Value);
				}
				TopicsServiceClient.AddReply(message, Request.UserHostAddress);

				#region Notifications
				string threadUrl = this.Domain + this.Url.RouteUrl(new{controller="Topics", action="ShortUrl", id=id});
				string unsubscribeUrl = this.Domain + this.Url.RouteUrl(new RouteValueDictionary());
				TopicsSubscriptionsServiceClient.SendNotifications(message.Topic, this.User.Id, threadUrl, unsubscribeUrl);
				#endregion

				return new RedirectToRouteExtraResult(new{action="Detail",controller="Topics",id=id,name=name,forum=forum}, "#msg" + message.Id);
			}
			catch (ValidationException ex)
			{
				this.AddErrors(ModelState, ex);
			}

			return View(message);
		}
		#endregion

		#region Move / Close / Delete
		#region Delete
		[RequireAuthorization]
		public ActionResult Delete(int id, string name, string forum)
		{
			#region Check if user can edit
			if (this.User.Group < UserGroup.Moderator)
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
		[AcceptVerbs(HttpVerbs.Get)]
		[RequireAuthorization(UserGroup.Moderator)]
		public ActionResult Move(int id, string name)
		{
			Topic topic = TopicsServiceClient.Get(id);
			#region Shortname must match
			if (topic != null && topic.ShortName.ToUpper() != name.ToUpper())
			{
				topic = null;
			} 
			#endregion

			if (topic == null)
			{
				return ResultHelper.NotFoundResult(this);
			}

			ViewData["Categories"] = ForumsServiceClient.GetList();

			return View(topic);
		}

		[AcceptVerbs(HttpVerbs.Post)]
		[RequireAuthorization(UserGroup.Moderator)]
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
			if (this.User.Group < UserGroup.Moderator)
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
			if (this.User.Group < UserGroup.Moderator)
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

		#region Delete message
		[RequireAuthorization(UserGroup.Moderator, RefuseOnFail=true)]
		public ActionResult DeleteMessage(int mid, int id, string forum, string name)
		{
			MessagesServiceClient.Delete(id, mid, this.User.Id);

			if (Request.UrlReferrer != null)
			{
				return Redirect(Request.UrlReferrer.PathAndQuery);
			}
			else
			{
				return RedirectToAction("Detail", new{id=id, name=name, forum=forum});
			}
		}
		#endregion
	}
}
