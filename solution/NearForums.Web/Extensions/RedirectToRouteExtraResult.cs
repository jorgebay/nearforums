using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using System.Web.Routing;

namespace NearForums.Web.Extensions
{
	public class RedirectToRouteExtraResult : RedirectToRouteResult
	{
		public string ExtraUrlParam
		{
			get;
			set;
		}

		public RedirectToRouteExtraResult(object routeValues, string extraUrlParam)
			: base(new RouteValueDictionary(routeValues))
		{
			this.ExtraUrlParam = extraUrlParam;
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
			url += this.ExtraUrlParam;
			context.HttpContext.Response.Redirect(url, false);
		}
	}
}
