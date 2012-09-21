using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Validation;
using NearForums.Web.Extensions;
using NearForums.Web.State;
using System.Threading;

namespace NearForums.Web.Controllers.Filters
{
	public class CaptchaAttribute : BaseActionFilterAttribute
	{
		private const string _captchaModelStateKey = "captcha";

		private bool _showCaptcha = true;
		public bool ShowCaptcha
		{
			get
			{
				return _showCaptcha;
			}
			set
			{
				_showCaptcha = value;
			}
		}

		/// <summary>
		/// Determines if the request is POST
		/// </summary>
		protected virtual bool IsPost(ControllerContext context)
		{
			return context.HttpContext.Request.HttpMethod == "POST";
		}

		public override void OnActionExecuting(ActionExecutingContext filterContext)
		{
			if (IsPost(filterContext) && ShowCaptcha)
			{
				ValidateCaptchaModelState(filterContext);
			}

			filterContext.Controller.ViewBag.ShowCaptcha = ShowCaptcha;

			base.OnActionExecuting(filterContext);
		}

		/// <summary>
		/// Checks if captcha value is invalid. If so, it add a model error to the current ModelState
		/// </summary>
		protected virtual bool ValidateCaptchaModelState(ActionExecutingContext filterContext)
		{
			var isValid = false;
			var captchaModelState = filterContext.Controller.ViewData.ModelState[_captchaModelStateKey];
			if (captchaModelState == null)
			{
				captchaModelState = new ModelState();
				var postedValue = filterContext.HttpContext.Request.Form[_captchaModelStateKey];
				captchaModelState.Value = new ValueProviderResult(postedValue, postedValue, Thread.CurrentThread.CurrentUICulture);
				filterContext.Controller.ViewData.ModelState.Add(_captchaModelStateKey, captchaModelState);
			}

			//if its the captcha value is not correct, add a modelState error
			if (String.IsNullOrEmpty(captchaModelState.Value.AttemptedValue))
			{
				captchaModelState.Errors.Add(new ValidationError(_captchaModelStateKey, ValidationErrorType.NullOrEmpty));
			}
			else if (!CaptchaHelper.IsValidCaptchaValue(captchaModelState.Value.AttemptedValue, new SessionWrapper(filterContext.HttpContext)))
			{
				captchaModelState.Errors.Add(new ValidationError(_captchaModelStateKey, ValidationErrorType.CompareNotMatch));
			}
			else
			{
				isValid = true;
			}

			if (isValid)
			{
				OnCaptchaValid(filterContext);
			}

			return isValid;
		}

		/// <summary>
		/// Called when the captcha is correctly filled in, 
		/// determining that the user is human
		/// </summary>
		/// <param name="context"></param>
		protected virtual void OnCaptchaValid(ControllerContext context)
		{
			var session = new SessionWrapper(context.HttpContext);
			session.IsHuman = true;
		}

		/// <summary>
		/// Called after the action method executes
		/// </summary>
		public override void OnActionExecuted(ActionExecutedContext filterContext)
		{
			base.OnActionExecuted(filterContext);
		}
	}
}
