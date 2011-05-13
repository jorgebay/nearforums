using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Web.State;
using System.Web.Routing;
using NearForums.ServiceClient;

namespace NearForums.Web.Controllers.Filters
{
	public class AddVisitAttribute : BaseActionFilterAttribute
	{
		public override void OnActionExecuted(ActionExecutedContext filterContext)
		{
			CacheWrapper cache = new CacheWrapper(filterContext.HttpContext.Cache);
			RouteValueDictionary values = filterContext.RouteData.Values;
			if (!(values.ContainsKey("controller") && values.ContainsKey("action") && values.ContainsKey("id")))
			{
				throw new ArgumentException("Necessary route values not found in controller context.");
			}

			if (!cache.VisitedActionAlready(values["controller"].ToString(), values["action"].ToString(), values["id"].ToString(), filterContext.HttpContext.Request.UserHostAddress))
			{
				TopicsServiceClient.AddVisit(Convert.ToInt32(values["id"]));
			}
			base.OnActionExecuted(filterContext);
		}
	}
}
