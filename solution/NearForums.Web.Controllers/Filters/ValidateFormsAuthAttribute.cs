using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using System.Web;
using System.Web.Security;
using NearForums.Web.State;
using NearForums;
using NearForums.Web.Extensions;
using System.Web.Routing;
using NearForums.Configuration;
using NearForums.Web.Controllers.Helpers;

namespace NearForums.Web.Controllers.Filters
{
	/// <summary>
	/// Validates that FormsAuth / Membership is enabled. If the user is logged in, validates that the provider for the user is this.
	/// </summary>
	public class ValidateFormsAuthAttribute : BaseActionFilterAttribute
	{
		public override void OnActionExecuting(ActionExecutingContext filterContext)
		{
			var session = new SessionWrapper(filterContext.HttpContext);
			if (!Config.AuthenticationProviders.FormsAuth.IsDefined)
			{
				filterContext.Result = ResultHelper.ForbiddenResult(filterContext.Controller as BaseController);
			}
			else
			{
				if (session.User != null && session.User.Provider != AuthenticationProvider.Membership)
				{
					filterContext.Result = ResultHelper.ForbiddenResult(filterContext.Controller as BaseController);
				}
			}
			base.OnActionExecuting(filterContext);
		}
	}
}
