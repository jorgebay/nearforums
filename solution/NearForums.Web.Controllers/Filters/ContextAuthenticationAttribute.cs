using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.Services;
using System.Web.Security;
using NearForums.Web.Controllers.Helpers;
using System.Web;
using System.Web.Mvc;
using NearForums.Web.State;
using System.Web.Routing;

namespace NearForums.Web.Controllers.Filters
{
	/// <summary>
	/// Tries to Authenticate the user based on the context (cookie or querystring)
	/// </summary>
	public class ContextAuthenticationAttribute : BaseActionFilterAttribute
	{
		private MembershipProvider _membershipProvider;

		/// <summary>
		/// Gets or sets the app membership provider.
		/// </summary>
		protected virtual MembershipProvider MembershipProvider
		{
			get
			{
				//local default
				if (_membershipProvider == null)
				{
					_membershipProvider = Membership.Provider;
				}
				return _membershipProvider;
			}
			set
			{
				_membershipProvider = value;
			}
		}

		/// <summary>
		/// User service
		/// </summary>
		public IUsersService UserService { get; set; }

		public override void OnActionExecuting(System.Web.Mvc.ActionExecutingContext filterContext)
		{
			//Tries to authenticate.
			var context = filterContext.HttpContext;
			var session = new SessionWrapper(context);

			if (session.User == null)
			{
				var userId = SecurityHelper.TryFinishMembershipLogin(context, session, MembershipProvider, UserService);
				if (userId > 0 && session.User == null)
				{
					//The user is banned or suspended
					filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary(new {controller="Users", action="Detail", id=userId }));
				}
			}

			base.OnActionExecuting(filterContext);
		}
	}
}
