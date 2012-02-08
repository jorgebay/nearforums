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
using NearForums.Web.Controllers.Helpers;

namespace NearForums.Web.Controllers.Filters
{
	public class RequireAuthorizationAttribute : AuthorizeAttribute
	{
		/// <summary>
		/// Required minimal User role
		/// </summary>
		public UserRole? UserRole
		{
			get;
			set;
		}

		public RouteCollection Routes
		{
			get;
			set;
		}

		public RequireAuthorizationAttribute()
		{
			this.Routes = RouteTable.Routes;
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="userRole">Required minimal role to access</param>
		public RequireAuthorizationAttribute(UserRole userRole)
			: this()
		{
			this.UserRole = userRole;
		}

		/// <summary>
		/// Determines if the filter must return forbidden status in the case the user is not logged in
		/// </summary>
		public bool RefuseOnFail
		{
			get;
			set;
		}

		protected override bool AuthorizeCore(HttpContextBase httpContext)
		{
			SessionWrapper session = new SessionWrapper(httpContext.Session);
			return IsAuthorized(session.User);
		}

		/// <summary>
		/// Determines if a user is authorized
		/// </summary>
		/// <param name="user"></param>
		/// <returns></returns>
		protected virtual bool IsAuthorized(UserState user)
		{
			if (user == null)
			{
				return false;
			}
			if (this.UserRole != null)
			{
				if (user.Role < this.UserRole.Value)
				{
					return false;
				}
			}
			return true;
		}

		/// <summary>
		/// Handles the request when the user is not authorized
		/// </summary>
		protected override void HandleUnauthorizedRequest(AuthorizationContext filterContext)
		{
			if (RefuseOnFail)
			{
				filterContext.Result = ResultHelper.ForbiddenResult(filterContext.Controller as BaseController);
			}
			else
			{
				string redirectOnSuccess = filterContext.HttpContext.Request.Url.PathAndQuery;
				VirtualPathData path = this.Routes.GetVirtualPath(filterContext.RequestContext, new RouteValueDictionary(new
				{
					controller = "Authentication",
					action = "Login",
					returnUrl = redirectOnSuccess,
					role = this.UserRole
				}));
				if (path == null)
				{
					throw new ArgumentException("Route for Authentication>Login not found.");
				}
				string loginUrl = path.VirtualPath;
				filterContext.Result = new RedirectResult(loginUrl, false);
			}
		}
	}
}
