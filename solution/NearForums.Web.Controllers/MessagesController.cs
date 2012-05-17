using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Web.Controllers.Filters;
using NearForums.Services;
using NearForums.Web.Extensions;
using NearForums.Web.Controllers.Helpers;
using NearForums.Validation;

namespace NearForums.Web.Controllers
{
	public class MessagesController : BaseController
	{
		/// <summary>
		/// Messages service
		/// </summary>
		private readonly IMessagesService _service;
		/// <summary>
		/// Topic service
		/// </summary>
		private readonly ITopicsService _topicService;

		public MessagesController(IMessagesService service, ITopicsService topicService, IUsersService userService) : base(userService)
		{
			_service = service;
			_topicService = topicService;
		}

		#region Add
		/// <summary>
		/// Loads the "reply to a topic" form
		/// </summary>
		/// <param name="id">thread id</param>
		/// <param name="name">thread short name</param>
		/// <param name="msg">Message id of the message being quoted.</param>
		[HttpGet]
		[RequireAuthorization]
		[PreventFlood]
		public ActionResult Add(int id, string name, int? msg)
		{
			var message = new Message();
			message.Topic = _topicService.Get(id, name);
			#region Check topic
			if (message.Topic == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			if (!message.Topic.HasPostAccess(Role))
			{
				return ResultHelper.ForbiddenResult(this);
			}
			if (message.Topic.IsClosed)
			{
				return ResultHelper.ForbiddenResult(this);
			} 
			#endregion
			if (msg != null)
			{
				message.InReplyOf = new Message(msg.Value);
			}


			ViewData["notify"] = SubscriptionHelper.IsUserSubscribed(id, this.User.Id, this.Config);

			return View("Edit", message);
		}

		/// <summary>
		/// Saves the message or Loads the reply form to allow the user to clear error messages
		/// </summary>
		/// <param name="id">thread id</param>
		/// <param name="msg">Message id of the message being quoted.</param>
		[HttpPost]
		[RequireAuthorization]
		[ValidateInput(false)]
		[PreventFlood(SuccessResultType = typeof(RedirectToRouteResult))]
		public ActionResult Add([Bind(Prefix = "", Exclude = "Id")] Message message, int id, string name, string forum, int? msg, bool notify, string email)
		{
			message.Topic = _topicService.Get(id, name);
			#region Check topic
			if (message.Topic == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			if (!message.Topic.HasPostAccess(Role))
			{
				return ResultHelper.ForbiddenResult(this);
			}
			if (message.Topic.IsClosed)
			{
				return ResultHelper.ForbiddenResult(this);
			}
			#endregion
			try
			{
				SubscriptionHelper.SetNotificationEmail(notify, email, Session, Config);
				SubscriptionHelper.Manage(notify, message.Topic.Id, this.User.Id, this.User.Guid, this.Config);

				if (message.Body != null)
				{
					message.Body = message.Body.SafeHtml().ReplaceValues();
				}
				message.User = Session.User.ToUser();
				if (msg != null)
				{
					message.InReplyOf = new Message(msg.Value);
				}
				if (ModelState.IsValid)
				{
					_service.Add(message, Request.UserHostAddress);
					SubscriptionHelper.SendNotifications(this, message.Topic, this.Config);
					//Redirect to the message posted
					return new RedirectToRouteExtraResult(new { action = "Detail", controller = "Topics", id = id, name = name, forum = forum }, "#msg" + message.Id);
				}
			}
			catch (ValidationException ex)
			{
				this.AddErrors(ModelState, ex);
			}
			return View("Edit", message);
		}
		#endregion

		#region Delete
		/// <summary>
		/// Removes a message
		/// </summary>
		/// <param name="mid">message id</param>
		/// <param name="id">topic id</param>
		[HttpPost]
		[RequireAuthorization(UserRole.Moderator, RefuseOnFail = true)]
		public ActionResult Delete(int mid, int id, string forum, string name)
		{
			_service.Delete(id, mid, this.User.Id);
			return Json(true);
		}
		#endregion

		#region Flag messages
		/// <summary>
		/// Marks a message as inapropriate
		/// </summary>
		/// <param name="mid">Message id</param>
		/// <param name="id">Topic id</param>
		[HttpPost]
		public ActionResult Flag(int mid, int id, string forum, string name)
		{
			bool flagged = _service.Flag(id, mid, Request.UserHostAddress);

			return Json(flagged);
		}
		#endregion

		#region List flagged messages
		/// <summary>
		/// Gets a list of flagged messages
		/// </summary>
		/// <returns></returns>
		[RequireAuthorization(UserRole.Moderator)]
		public ActionResult ListFlagged()
		{
			var topics = _service.ListFlagged();
			return View(topics);
		}
		#endregion

		#region ClearFlags
		[HttpPost]
		[RequireAuthorization(UserRole.Moderator, RefuseOnFail = true)]
		public ActionResult ClearFlags(int mid, int id, string forum, string name)
		{
			bool cleared = _service.ClearFlags(id, mid);
			return Json(cleared);
		}
		#endregion
	}
}
