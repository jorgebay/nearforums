using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NearForums.Web.Controllers.Helpers;
using NearForums.ServiceClient;
using NearForums.Web.Extensions;

namespace NearForums.Web.Controllers
{
	public class HomeController : BaseController
	{
		public ActionResult Index()
		{
			return View(null, "Site", null);
		}

		public ActionResult Login(string returnUrl, UserGroup? group)
		{
			if (User != null)
			{
				if (group == null || User.Group >= group)
				{
					return Redirect(HttpUtility.UrlDecode(returnUrl ?? "/"));
				}
				ViewData["UserGroup"] = group;
				ViewData["UserGroupName"] = UsersServiceClient.GetGroupName(group.Value);
			}

			return View();
		}

		public ActionResult Logout(string returnUrl)
		{
			Session.User = null;
			if (String.IsNullOrEmpty(returnUrl))
			{
				returnUrl = "/";
			}
			return Redirect(HttpUtility.UrlDecode(returnUrl));
		}

		public ActionResult TwitterStartLogin(string returnUrl)
		{
			if (this.User != null)
			{
				return Redirect(returnUrl);
			}
			if (!this.Config.AuthorizationProviders.Twitter.IsDefined)
			{
				return ResultHelper.ForbiddenResult(this);
			}

			//Will redirect to twitter
			SecurityHelper.TwitterStartLogin(this.Cache);

			//Normally the twitter consumer will redirect and end execution.
			//But if it didn't:
			throw new AuthenticationProviderException("Unexpected behaviour on dotnetopenauth Twitter consumer.");
		}

		public ActionResult About()
		{
			return Static("About", true);
		}

		public ActionResult FacebookReceiver()
		{
			return Static("FacebookXDReceiver", false);
		}
	}
}
