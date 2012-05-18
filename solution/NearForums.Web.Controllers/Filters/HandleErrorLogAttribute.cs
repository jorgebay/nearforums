using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using System.Web;
using NearForums.Services;

namespace NearForums.Web.Controllers.Filters
{
	public class HandleErrorLogAttribute : HandleErrorAttribute
	{
		public ILoggerService Logger { get; set; }

		public override void OnException(ExceptionContext filterContext)
		{
			if ((!filterContext.ExceptionHandled) && filterContext.HttpContext.IsCustomErrorEnabled)
			{
				Logger.LogError(filterContext.Exception);
			}
			base.OnException(filterContext);
		}
	}
}
