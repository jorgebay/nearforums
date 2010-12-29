using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Web.State;
using System.Web;

namespace NearForums.Web.Controllers.Filters
{
	public class PreventFloodAttribute : ActionFilterAttribute
	{
		/// <summary>
		/// Determines the type of the action result in case of a success
		/// </summary>
		public Type SuccessResultType
		{
			get;
			set;
		}


		public override void OnActionExecuting(ActionExecutingContext filterContext)
		{
			//if the user has posted 
			base.OnActionExecuting(filterContext);
		}

		/// <summary>
		/// Called after the action method executes
		/// </summary>
		public override void OnActionExecuted(ActionExecutedContext filterContext)
		{
			if (filterContext == null)
			{
				throw new ArgumentNullException("filterContext");
			}
			//If the action was successful
			if (IsSuccess(filterContext.Result))
			{
				//Store the date of the posting
				SetLatestPosting(filterContext.HttpContext);
			}
			base.OnActionExecuted(filterContext);
		}

		/// <summary>
		/// Stores the date of the latest posting on the state server (cache)
		/// </summary>
		/// <param name="httpContext"></param>
		protected virtual void SetLatestPosting(HttpContextBase httpContext)
		{
			var cache = new CacheWrapper(httpContext);
			cache.SetLatestPosting(httpContext.Request.UserHostAddress);
		}

		/// <summary>
		/// Determines if the action execution was successful. ie: Redirection after save, 
		/// </summary>
		protected virtual bool IsSuccess(ActionResult actionResult)
		{
			return SuccessResultType == null || (actionResult != null && actionResult.GetType().IsSubclassOf(SuccessResultType));
		}
	}
}
