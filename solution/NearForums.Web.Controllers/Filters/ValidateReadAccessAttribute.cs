using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Web.State;
using System.Web.Routing;
using NearForums.Web.Extensions;
using NearForums.Web.Controllers.Helpers;

namespace NearForums.Web.Controllers.Filters
{
	/// <summary>
	/// Represents an attribute that is used to restrict access by callers to an action method that shows IAccessRightContainer (Forum/Topic) information
	/// </summary>
	public class ValidateReadAccessAttribute : BaseActionFilterAttribute
	{
		/// <summary>
		/// Current route table used in the application
		/// </summary>
		public RouteCollection Routes
		{
			get;
			set;
		}

		/// <summary>
		/// Determines if the filter must return forbidden http status with an empty result in the case the user hasn't got the access rights
		/// </summary>
		public bool RefuseOnFail
		{
			get;
			set;
		}

		public ValidateReadAccessAttribute()
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
				var modelAccessRights = GetAccessRightsEntity(model);
				if (modelAccessRights.ReadAccessRole != null)
				{
					var session = new SessionWrapper(filterContext.HttpContext);
					if (session.User == null || !modelAccessRights.HasReadAccess(session.User.Role))
					{
						HandleUnauthorizedRequest(filterContext, modelAccessRights.ReadAccessRole.Value);
					}
				}
			}
			base.OnActionExecuted(filterContext);
		}

		protected virtual void HandleUnauthorizedRequest(ActionExecutedContext filterContext, UserRole role)
		{
			filterContext.Canceled = true;
			if (RefuseOnFail)
			{
				filterContext.Result = ResultHelper.ForbiddenResult(filterContext.Controller as BaseController, true);
			}
			else
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

		/// <summary>
		/// Gets the IAccessRightContainer (forum / topic) from the view data model
		/// </summary>
		/// <param name="model">Model</param>
		/// <returns></returns>
		protected virtual IAccessRightContainer GetAccessRightsEntity(object model)
		{
			if (model == null)
			{
				throw new ArgumentNullException("model");
			}
			var container = model as IAccessRightContainer;

			if (container == null)
			{
				throw new ArgumentException("Model must be an instance of IAccessRightContainer (forum/topic).");
			}
			return container;
		}
	}
}
