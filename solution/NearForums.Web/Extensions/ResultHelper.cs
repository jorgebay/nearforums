using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using System.Collections;
using System.Web.Routing;

namespace NearForums.Web.Extensions
{
	public class ResultHelper
	{
		/// <summary>
		/// Returns a status 404 to the client and the error 404 view.
		/// </summary>
		/// <param name="controller"></param>
		/// <param name="emptyBody">false: the response ends</param>
		/// <returns></returns>
		public static ActionResult NotFoundResult(ControllerBase controller, bool emptyBody)
		{
			controller.ControllerContext.HttpContext.Response.StatusCode = 404;
			if (emptyBody)
			{
				controller.ControllerContext.HttpContext.Response.End();
			}

			ViewResult viewResult = new ViewResult();
			viewResult.ViewName = "/Views/Error/404.aspx";
			return viewResult;
		}

		public static ActionResult NotFoundResult(ControllerBase controller)
		{
			return NotFoundResult(controller, false);
		}

		public static ActionResult ForbiddenResult(ControllerBase controller)
		{
			return ForbiddenResult(controller, false);
		}

		public static ActionResult ForbiddenResult(ControllerBase controller, bool emptyBody)
		{
			controller.ControllerContext.HttpContext.Response.StatusCode = 403;
			if (emptyBody)
			{
				controller.ControllerContext.HttpContext.Response.End();
			}

			ViewResult viewResult = new ViewResult();
			viewResult.ViewName = "/Views/Error/403.aspx";
			return viewResult;
		}

		//public static ActionResult MovedPermanentlyResult(ControllerBase controller, object routeValues)
		//{
		//    return new MovedPermanentlyResult(routeValues);
		//}
	}
}
