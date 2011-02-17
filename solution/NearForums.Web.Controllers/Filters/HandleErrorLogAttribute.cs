using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using System.Web;
using NearForums.ServiceClient;

namespace NearForums.Web.Controllers.Filters
{
	public class HandleErrorLogAttribute : HandleErrorAttribute
	{
		public override void OnException(ExceptionContext filterContext)
		{
			if ((!filterContext.ExceptionHandled) && filterContext.HttpContext.IsCustomErrorEnabled)
			{
				LoggerServiceClient.LogError(filterContext.Exception);
			}
			base.OnException(filterContext);
		}
	}
}
