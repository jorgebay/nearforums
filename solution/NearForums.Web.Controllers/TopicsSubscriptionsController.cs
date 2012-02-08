using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.ServiceClient;
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
			int removedSubscription = TopicsSubscriptionsServiceClient.Remove(tid, uid, parsedGuid);

			if (removedSubscription > 0)
			{
				//Load the user data
				ViewData["User"] = UsersServiceClient.Get(uid);
			}
			topic = TopicsServiceClient.Get(tid);
			return View(topic);
		}
	}
}
