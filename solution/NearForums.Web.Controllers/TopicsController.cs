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
		public ActionResult Detail(int id, string name, int page)
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
				topic.Forum = new Forum(){ShortName=forum};
				topic.User = new User(User.Id, User.UserName);
				topic.ShortName = name;
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
		//[AcceptVerbs(HttpVerbs.Post)]
		public ActionResult PageMore(int id, int from, int initIndex)
		{
			//load messages
			List<Message> messages = MessagesServiceClient.GetByTopicFrom(id, from, Config.Topics.MessagesPerPage, initIndex);
			//Defines that the message url just be the anchor name
			ViewData["FullUrl"] = false;

			return View(messages);
		}

		[AcceptVerbs(HttpVerbs.Post)]
		public ActionResult PageUntil(int id, int firstMsg, int lastMsg, int initIndex)
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
		[AcceptVerbs(HttpVerbs.Get)]
		[RequireAuthorization]
		public ActionResult Reply(int id, string name)
		{
			Message message = new Message();
			message.Topic = TopicsServiceClient.Get(id);
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

			return View(message);
		}

		[AcceptVerbs(HttpVerbs.Post)]
		[RequireAuthorization]
		[ValidateInput(false)]
		public ActionResult Reply([Bind(Prefix = "", Exclude = "Id")] Message message, int id, string name, string forum)
		{
			try
			{
				message.Topic = new Topic(){Id=id};
				message.Body = message.Body.ReplaceValues();
				message.User = Session.User.ToUser();
				TopicsServiceClient.AddReply(message, Request.UserHostAddress);

				return new RedirectToRouteExtraResult(new{action="Detail",controller="Topics",id=id,name=name,forum=forum}, "#msg" + message.Id);
			}
			catch (ValidationException ex)
			{
				this.AddErrors(ModelState, ex);
			}

			message.Topic = TopicsServiceClient.Get(id);
			return View(message);
		}
		#endregion

		#region Delete message
		[RequireAuthorization(UserGroup.Moderator, RefuseOnFail=true)]
		public ActionResult DeleteMessage(int mid, int id, string forum, string name)
		{
			MessagesServiceClient.Delete(mid, this.User.Id);

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
