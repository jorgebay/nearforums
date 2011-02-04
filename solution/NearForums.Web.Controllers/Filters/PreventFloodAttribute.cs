using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Web.State;
using System.Web;
using NearForums.Validation;

namespace NearForums.Web.Controllers.Filters
{
	public class PreventFloodAttribute : ActionFilterAttribute
	{
		private const string _captchaModelStateKey = "captcha";

		/// <summary>
		/// Determines the type of the action result in case of a success
		/// </summary>
		public Type SuccessResultType
		{
			get;
			set;
		}


		#region Before action execution
		public override void OnActionExecuting(ActionExecutingContext filterContext)
		{
			//It can be the get or post request
			//var atts = filterContext.ActionDescriptor.GetCustomAttributes(typeof(AcceptVerbsAttribute), false).First(t => t.GetType() == typeof(AcceptVerbsAttribute)) as AcceptVerbsAttribute;

			//Checks if the user is flooding, show captcha
			var isFlooding = CheckFlooding(filterContext);
			if (isFlooding)
			{
				//If the captcha is invalid.
					//Add ModelState error
				ValidateCaptcha(filterContext);

			}

			base.OnActionExecuting(filterContext);
		}
		#endregion

		#region Validate captcha
		/// <summary>
		/// Checks if captcha value is invalid. If so, it add a model error to the current ModelState
		/// </summary>
		/// <param name="filterContext"></param>
		protected virtual void ValidateCaptcha(ActionExecutingContext filterContext)
		{
			var captchaModelState = filterContext.Controller.ViewData.ModelState[_captchaModelStateKey];
			if (captchaModelState == null)
			{
				captchaModelState = new ModelState();
				filterContext.Controller.ViewData.ModelState[_captchaModelStateKey] = captchaModelState;

				filterContext.Controller.ViewData["ShowCaptcha"] = true;

				//Maybe if its post, add an error to the modelStateValue?
			}
			else
			{
				captchaModelState.Errors.Add(new ValidationError(_captchaModelStateKey, ValidationErrorType.CompareNotMatch));
				filterContext.Controller.ViewData["ShowCaptcha"] = true;
			}
		} 
		#endregion

		#region After action execution
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
		#endregion

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

		#region Check Flooding
		/// <summary>
		/// Checks if the user is flooding
		/// </summary>
		protected virtual bool CheckFlooding(ControllerContext context)
		{
			bool isFlooding = false;
			//TODO: Get the rules of flooding from configuration.
			var minTime = TimeSpan.FromMinutes(30);
			DateTime? latestPosting = GetLatestPosting(context);
			if (latestPosting != null && DateTime.Now.Subtract(latestPosting.Value) < minTime)
			{
				isFlooding = true;
			}

			return isFlooding;
		}
		#endregion

		#region Is Success
		/// <summary>
		/// Determines if the action execution was successful. ie: Redirection after save, 
		/// </summary>
		protected virtual bool IsSuccess(ActionResult actionResult)
		{
			return SuccessResultType != null && actionResult != null && actionResult.GetType().IsSubclassOf(SuccessResultType);
		} 
		#endregion
	}
}
