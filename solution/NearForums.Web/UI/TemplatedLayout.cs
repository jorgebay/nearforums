using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using System.Web.Mvc.Html;
using NearForums.Web.State;
using System.Web;
using NearForums.Configuration;
using NearForums.Web.Extensions;

namespace NearForums.Web.UI
{
	public class TemplatedLayout : BaseViewPage
	{
		protected virtual TemplateState Template
		{
			get
			{
				if (Session.TemplatePreviewed != null)
				{
					return Session.TemplatePreviewed;
				}
				return Cache.Template;
			}
		}

		protected virtual int? TemplatePreviewId
		{
			get
			{
				int? id = null;
				if (Session.TemplatePreviewed != null)
				{
					id = Session.TemplatePreviewed.Id;
				}
				return id;
			}
		}

		public override void ExecutePageHierarchy()
		{
			base.ExecutePageHierarchy();
			foreach (TemplateState.TemplateItem item in Template.Items)
			{
				WriteItem(item);
			}

		}

		protected virtual void WriteItem(TemplateState.TemplateItem item)
		{
			if (item.Type == TemplateState.TemplateItemType.Text)
			{
				WriteLiteral(item.Value);
			}
			else if (item.Type == TemplateState.TemplateItemType.Container)
			{
				switch (item.Value.ToUpper()) //Name
				{
					case "BODYCONTAINER":
						Write(RenderBody());
						WriteTemplatePreview();
						break;
					case "HEADCONTAINER":
						Write(Html.Partial("HeadContainer"));
						if (IsSectionDefined("Head"))
						{
							Write(RenderSection("Head"));
						}
						break;
				}
			}
			else if (item.Type == TemplateState.TemplateItemType.Partial)
			{
				Write(Html.Partial(item.Value, ViewData));
			}
		}

		/// <summary>
		/// If the template is beeing previewed, renders a special partial view
		/// </summary>
		protected virtual void WriteTemplatePreview()
		{
			if (TemplatePreviewId != null)
			{
				Write(Html.Partial("~/Views/Templates/PreviewPartial.cshtml", ViewData));
			}
		}
	}
}
