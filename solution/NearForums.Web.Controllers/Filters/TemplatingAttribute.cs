using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.Services;
using NearForums.Web.Controllers.Helpers;
using NearForums.Web.State;
using System.Web;
using NearForums.Web.Extensions;

namespace NearForums.Web.Controllers.Filters
{
	public class TemplatingAttribute : BaseActionFilterAttribute
	{
		public ITemplatesService Service { get; set; }

		public override void OnActionExecuting(System.Web.Mvc.ActionExecutingContext filterContext)
		{
			LoadTemplateState(filterContext.HttpContext);

			base.OnActionExecuting(filterContext);
		}

		/// <summary>
		/// Ensures that the template is on the server state (cache/session)
		/// </summary>
		/// <returns></returns>
		private TemplateState LoadTemplateState(HttpContextBase context)
		{
			TemplateState template = null;
			var session = new SessionWrapper(context);
			var cache = new CacheWrapper(context);
			template = LoadPreview(context, session);
			if (template != null)
			{
				return template;
			}

			if (Config.UI.Template.UseTemplates)
			{
				if (cache.Template == null)
				{
					//Load the current template in the cache
					cache.Template = TemplateHelper.GetCurrentTemplateState(context, Service);
				}
				template = cache.Template;
			}
			else
			{
				cache.Template = null;
			}

			return template;
		}

		/// <summary>
		/// If a template is being previewed, load into session state
		/// </summary>
		private TemplateState LoadPreview(HttpContextBase context, SessionWrapper session)
		{
			TemplateState template = null;
			int? previewTemplateId = context.Request.QueryString["_tid"].ToNullableInt();
			if (session.IsTemplatePreview)
			{
				if (previewTemplateId != null)
				{
					if (session.TemplatePreviewed == null || session.TemplatePreviewed.Id != previewTemplateId.Value)
					{
						//Load the previewed template into the session
						session.TemplatePreviewed = TemplateHelper.GetTemplateState(context, previewTemplateId, Service);
					}
				}
				else
				{
					//Prevent for the previus previewed template to be shown in this 
					session.TemplatePreviewed = null;
				}
				template = session.TemplatePreviewed;
			}
			return template;
		}
	}
}
