using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.Services;
using NearForums.Web.Extensions;
using NearForums.Validation;
using NearForums.Web.Controllers.Filters;
using System.Web.Mvc;
using System.Web.Routing;
using NearForums.Web.Controllers.Helpers;

namespace NearForums.Web.Controllers
{
	public class TopicsSubscriptionsController : BaseController
	{
		/// <summary>
		/// Service that handles subscriptions
		/// </summary>
		private readonly ITopicsSubscriptionsService service;

		/// <summary>
		/// Topic service
		/// </summary>
		private readonly ITopicsService topicService;

		/// <summary>
		/// User service
		/// </summary>
		private readonly IUsersService userService;

		public TopicsSubscriptionsController(ITopicsSubscriptionsService serv, ITopicsService topicServ, IUsersService userServ)
		{
			service = serv;
			topicService = topicServ;
			userService = userServ;
		}
		/// <summary>
		/// Unsubscribes a user from a topic
		/// </summary>
		/// <param name="guid">user guid</param>
		/// <param name="id">topic id</param>
		public ActionResult Unsubscribe(int uid, string guid, int tid)
		{
			Guid parsedGuid = Guid.Empty;
			Topic topic = null;
			#region Parse guid
			try
			{
				parsedGuid = new Guid(guid);
			}
			catch
			{
				ResultHelper.ForbiddenResult(this);
			} 
			#endregion
			int removedSubscription = service.Remove(tid, uid, parsedGuid);

			if (removedSubscription > 0)
			{
				//Load the user data
				ViewData["User"] = userService.Get(uid);
			}
			topic = topicService.Get(tid);
			return View(topic);
		}
	}
}
