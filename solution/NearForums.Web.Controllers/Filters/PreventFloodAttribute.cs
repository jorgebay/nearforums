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
			//var atts = filterContext.ActionDescriptor.GetCustomAttributes(typeof(AcceptVerbsAttribute), false).First(t => t.GetType() == typeof(AcceptVerbsAttribute)) as AcceptVerbsAttribute;

			//Checks if the user is flooding, show captcha
			var isFlooding = CheckFlooding(filterContext);
			if (isFlooding)
			{
				//filterContext.
			}
			
			base.OnActionExecuting(filterContext);
		}

		/// <summary>
		/// Checks if the user is flooding
		/// </summary>
		protected virtual bool CheckFlooding(ControllerContext context)
		{
			bool isFlooding = false;
			//TODO: Get the rules of flooding from configuration.
			var maxTime = TimeSpan.FromSeconds(120);
			DateTime? latestPosting = GetLatestPosting(context);
			if (latestPosting != null && DateTime.Now.Subtract(latestPosting.Value) > maxTime)
			{
				isFlooding = true;
			}

			return isFlooding;
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
				SetLatestPosting(filterContext);
			}
			base.OnActionExecuted(filterContext);
		}

		#region Get/Set Last Posting
		/// <summary>
		/// Stores the date of the latest posting on the state server (cache)
		/// </summary>
		/// <param name="httpContext"></param>
		protected virtual void SetLatestPosting(ControllerContext context)
		{
			var cache = new CacheWrapper(context.HttpContext);
			cache.SetLatestPosting(context.HttpContext.Request.UserHostAddress);
		}
		
		protected virtual DateTime? GetLatestPosting(ControllerContext context)
		{
			var cache = new CacheWrapper(context.HttpContext);
			return cache.GetLatestPosting(context.HttpContext.Request.UserHostAddress);
		}
		#endregion

		#region Is Success
		/// <summary>
		/// Determines if the action execution was successful. ie: Redirection after save, 
		/// </summary>
		protected virtual bool IsSuccess(ActionResult actionResult)
		{
			return SuccessResultType == null || (actionResult != null && actionResult.GetType().IsSubclassOf(SuccessResultType));
		} 
		#endregion
	}
}
