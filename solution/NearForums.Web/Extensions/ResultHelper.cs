using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using System.Collections;
using System.Web.Routing;

namespace NearForums.Web.Extensions
{
	public static class ResultHelper
	{
		/// <summary>
		/// Returns a status 404 to the client and the error 404 view.
		/// </summary>
		/// <param name="emptyBody">true: the response ends</param>
		public static ActionResult NotFoundResult(ControllerBase controller, bool emptyBody)
		{
			controller.ControllerContext.HttpContext.Response.StatusCode = 404;
			if (emptyBody)
			{
				controller.ControllerContext.HttpContext.Response.End();
			}

			ViewResult viewResult = new ViewResult();
			viewResult.ViewName = "Errors/404";
			return viewResult;
		}

		/// <summary>
		/// Returns a status 404 to the client and the error 404 view.
		/// </summary>
		/// <param name="controller"></param>
		/// <returns></returns>
		public static ActionResult NotFoundResult(ControllerBase controller)
		{
			return NotFoundResult(controller, false);
		}


		/// <summary>
		/// Returns a http status 403 to the client and the error 403 view.
		/// </summary>
		/// <param name="controller"></param>
		/// <returns></returns>
		public static ActionResult ForbiddenResult(ControllerBase controller)
		{
			return ForbiddenResult(controller, false);
		}

		/// <summary>
		/// Returns a http status 403 to the client and the error 403 view.
		/// </summary>
		/// <param name="controller">current controller</param>
		/// <param name="emptyBody">true: the http response end without body</param>
		/// <returns></returns>
		public static ActionResult ForbiddenResult(ControllerBase controller, bool emptyBody)
		{
			controller.ControllerContext.HttpContext.Response.StatusCode = 403;
			if (emptyBody)
			{
				controller.ControllerContext.HttpContext.Response.End();
				return new EmptyResult();
			}

			ViewResult viewResult = new ViewResult();
			viewResult.ViewName = "Errors/403";
			return viewResult;
		}

		public static ActionResult MovedPermanentlyResult(ControllerBase controller, object routeValues)
		{
			return new MovedPermanentlyResult(routeValues);
		}

		/// <summary>
		/// Returns a ViewResult with content type set as xml
		/// </summary>
		public static ActionResult XmlViewResult(ControllerBase controller, object model, string viewName=null)
		{
			controller.ControllerContext.HttpContext.Response.ContentType = "text/xml; charset=UTF-8";
			if (model != null)
			{
				controller.ViewData.Model = model;
			}
			ViewResult result = new ViewResult();
			result.ViewName = viewName;
			result.ViewData = controller.ViewData;
			result.TempData = controller.TempData;
			return result;
		}
	}
}
