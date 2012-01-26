using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Web.State;
using System.Web.Routing;
using NearForums.Web.Extensions;

namespace NearForums.Web.Controllers.Filters
{
	/// <summary>
	/// Represents an attribute that is used to restrict access by callers to an action method that shows Forum information
	/// </summary>
	public class ForumReadAccessAttribute : BaseActionFilterAttribute
	{
		public RouteCollection Routes
		{
			get;
			set;
		}

		public ForumReadAccessAttribute()
		{
			Routes = RouteTable.Routes;
		}

		/// <summary>
		/// Called by the Framework after the action method executes. Uses the model to determine the forum read access rights.
		/// </summary>
		public override void OnActionExecuted(System.Web.Mvc.ActionExecutedContext filterContext)
		{
			var model = filterContext.Controller.ViewData.Model;
			if (model != null)
			{
				var forum = model as Forum;
				if (forum == null)
				{
					throw new ArgumentException("Model must be an instance of the class Forum.");
				}
				if (forum.ReadAccessRole != null)
				{
					var session = new SessionWrapper(filterContext.HttpContext);
					if (session.User == null || session.User.Role < forum.ReadAccessRole.Value)
					{
						HandleUnauthorizedRequest(filterContext, forum.ReadAccessRole.Value);
					}
				}
			}
			base.OnActionExecuted(filterContext);
		}

		protected virtual void HandleUnauthorizedRequest(ActionExecutedContext filterContext, UserRole role)
		{
			string redirectOnSuccess = filterContext.HttpContext.Request.Url.PathAndQuery;
			filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary(new
			{
				controller = "Authentication",
				action = "Login",
				returnUrl = redirectOnSuccess,
				role = role
			}));
		}
	}
}
