using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Web.State;
using System.Web.Routing;
using NearForums.Services;

namespace NearForums.Web.Controllers.Filters
{
	/// <summary>
	/// Adds an unique visit to a topic by IP (Default order 100)
	/// </summary>
	public class AddVisitAttribute : BaseActionFilterAttribute
	{
		public ITopicsService Service { get; set; }

		public AddVisitAttribute()
		{
			//Execute last
			Order = 100;
		}

		public override void OnActionExecuted(ActionExecutedContext filterContext)
		{
			if (!filterContext.Canceled)
			{
				var cache = new CacheWrapper(filterContext.HttpContext.Cache);
				var values = filterContext.RouteData.Values;
				if (!(values.ContainsKey("controller") && values.ContainsKey("action") && values.ContainsKey("id")))
				{
					throw new ArgumentException("Necessary route values not found in controller context.");
				}
				if (Service == null)
				{
					throw new NullReferenceException("The service is null, where an instance of ITopicsService was required.");
				}

				if (!cache.VisitedActionAlready(values["controller"].ToString(), values["action"].ToString(), values["id"].ToString(), filterContext.HttpContext.Request.UserHostAddress))
				{
					Service.AddVisit(Convert.ToInt32(values["id"]));
				}
			}
			base.OnActionExecuted(filterContext);
		}
	}
}
