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

namespace NearForums.Web.Controllers.Filters
{
	public class RequireAuthorizationAttribute : FilterAttribute, IAuthorizationFilter
	{
		/// <summary>
		/// Required minimal UserGroup
		/// </summary>
		public UserGroup? UserGroup
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
		/// <param name="userGroup">Required minimal UserGroup</param>
		public RequireAuthorizationAttribute(UserGroup userGroup)
			: this()
		{
			this.UserGroup = userGroup;
		}

		/// <summary>
		/// Determines if the filter must return forbidden status in the case the user is not logged in
		/// </summary>
		public bool RefuseOnFail
		{
			get;
			set;
		}

		#region IAuthorizationFilter Members
		public void OnAuthorization(AuthorizationContext filterContext)
		{
			if (filterContext == null)
			{
				throw new ArgumentNullException("filterContext");
			}

			
			SessionWrapper session = new SessionWrapper(filterContext.HttpContext.Session);
			if (IsAuthorized(session.User))
			{
				HttpCachePolicyBase cachePolicy = filterContext.HttpContext.Response.Cache;
				cachePolicy.SetProxyMaxAge(new TimeSpan(0));
			}
			else
			{
				//Authorization failed
				if (RefuseOnFail)
				{
					filterContext.Result = ResultHelper.ForbiddenResult(filterContext.Controller);
					return;
				}
				string redirectOnSuccess = HttpUtility.UrlEncode(filterContext.HttpContext.Request.Url.PathAndQuery);
				VirtualPathData path = this.Routes.GetVirtualPath(filterContext.RequestContext, new RouteValueDictionary(new{controller="Home",action="Login",returnUrl=redirectOnSuccess,group=this.UserGroup}));
				if (path == null)
				{
					throw new ArgumentException("Route for Home>Login not found.");
				}
				string loginUrl = path.VirtualPath;
				filterContext.HttpContext.Response.Redirect(loginUrl, true);
			}
		}

		#endregion

		public virtual bool IsAuthorized(UserState user)
		{
			if (user == null)
			{
				return false;
			}
			if (this.UserGroup != null)
			{
				if (user.Group < this.UserGroup.Value)
				{
					return false;
				}
			}
			return true;
		}
	}
}
