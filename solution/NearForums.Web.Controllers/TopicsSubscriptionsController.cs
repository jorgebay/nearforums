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

namespace NearForums.Web.Controllers
{
	public class TopicsSubscriptionsController : BaseController
	{
		/// <summary>
		/// Unsubscribes a user from a topic
		/// </summary>
		/// <param name="guid">user guid</param>
		/// <param name="id">topic id</param>
		public ActionResult UnSubscribe(int uid, string guid, int id)
		{
			Guid parsedGuid = Guid.Empty;
			User user = null;
			try
			{
				parsedGuid = new Guid(guid);
			}
			catch
			{
				ResultHelper.ForbiddenResult(this);
			}
			int removedSubscription = TopicsSubscriptionsServiceClient.Remove(id, uid, parsedGuid);

			if (removedSubscription > 0)
			{
				//Load the user data
				user = UsersServiceClient.Get(uid);
			}
			return View(user);
		}
	}
}
