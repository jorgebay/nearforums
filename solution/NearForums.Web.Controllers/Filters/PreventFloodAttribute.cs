using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Web.State;
using System.Web;
using NearForums.Validation;
using System.Threading;
using NearForums.Web.Extensions;
using NearForums.Configuration;

namespace NearForums.Web.Controllers.Filters
{
	/// <summary>
	/// Prevents a user (determined by the ip) to post unlimited times.
	/// Checks that a certain amount of time passed since the last post, if not it shows (and validates input) a captcha image to validate that its a human input.
	/// </summary>
	public class PreventFloodAttribute : CaptchaAttribute
	{
		#region Constructor, Field and Props
		/// <summary>
		/// Determines the type of the action result in case of a success
		/// </summary>
		public Type SuccessResultType
		{
			get;
			set;
		}

		/// <summary>
		/// Gets the minimum amount of time that the user should wait before re-posting.
		/// </summary>
		public TimeSpan MinTime
		{
			get
			{
				var minTime = TimeSpan.FromMinutes(Config.SpamPrevention.FloodControl.TimeBetweenPosts);
				return minTime;
			}
		}

		public PreventFloodAttribute() : base()
		{

		}

		public PreventFloodAttribute(Type successResultType)
		{
			SuccessResultType = successResultType;
		}
		#endregion

		/// <summary>
		/// Called before action executed
		/// </summary>
		/// <param name="filterContext"></param>
		public override void OnActionExecuting(ActionExecutingContext filterContext)
		{
			//Checks if the user is flooding, show captcha
			var isFlooding = IsFlooding(filterContext);
			ShowCaptcha = false;
			if (isFlooding)
			{
				ShowCaptcha = true;
			}

			base.OnActionExecuting(filterContext);
		}

		protected override void OnCaptchaValid(ControllerContext context)
		{
			ClearFlooding(context);
			base.OnCaptchaValid(context);
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

		/// <summary>
		/// Determines if the user is flooding
		/// </summary>
		protected virtual bool IsFlooding(ControllerContext context)
		{
			var session = new SessionWrapper(context.HttpContext);
			if (session.User != null && session.User.Role >= Config.SpamPrevention.FloodControl.IgnoreForRole)
			{
				return false;
			}
			//Check if the required time has passed
			DateTime? latestPosting = GetLatestPosting(context);
			if (latestPosting == null || latestPosting < DateTime.Now.Subtract(MinTime))
			{
				return false;
			}

			return true;
		}

		/// <summary>
		/// Sets this ip as not beeing flooding, untill the next post
		/// </summary>
		protected virtual void ClearFlooding(ControllerContext context)
		{
			var minTime = MinTime;
			var cache = new CacheWrapper(context.HttpContext);
			cache.SetTimePassed(context.HttpContext.Request.UserHostAddress, minTime);
		}

		/// <summary>
		/// Determines if the action execution was successful. ie: Redirection after save, 
		/// </summary>
		protected virtual bool IsSuccess(ActionResult actionResult)
		{
			if (actionResult == null)
			{
				throw new ArgumentNullException("actionResult");
			}
			return SuccessResultType != null && SuccessResultType.IsAssignableFrom(actionResult.GetType());
		}
	}
}
