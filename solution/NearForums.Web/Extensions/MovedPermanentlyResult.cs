using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using System.Web.Routing;

namespace NearForums.Web.Extensions
{
	public class MovedPermanentlyResult : RedirectToRouteResult
	{
		public MovedPermanentlyResult(RouteValueDictionary routeValues)
			: base(routeValues)
		{
			
		}

		public MovedPermanentlyResult(object routeValues)
			: this(new RouteValueDictionary(routeValues))
		{

		}

		public override void ExecuteResult(ControllerContext context)
		{
			if (context == null)
			{
				throw new ArgumentNullException("context");
			}
			string url = new UrlHelper(context.RequestContext).RouteUrl(this.RouteValues);
			if (string.IsNullOrEmpty(url))
			{
				throw new InvalidOperationException("No route matched for the params.");
			}
			context.HttpContext.Response.AddHeader("Location", url);
			context.HttpContext.Response.StatusCode = 301;
			context.HttpContext.Response.ClearContent();
		}
	}
}
