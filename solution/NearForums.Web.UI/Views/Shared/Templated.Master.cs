using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.Mvc.Html;
using NearForums.Web.State;

namespace NearForums.Web.UI.Views.Shared
{
	public partial class Templated : BaseViewMasterPage
	{
		protected ContentPlaceHolder TitleContent;
		protected ContentPlaceHolder HeadContent;
		protected ContentPlaceHolder MainContent;

		protected override void Render(HtmlTextWriter writer)
		{
			foreach (TemplateState.TemplateItem item in this.Cache.Template.Items)
			{
				RenderItem(item, writer);
			}
		}

		private void RenderItem(TemplateState.TemplateItem item, HtmlTextWriter writer)
		{
			if (item.Type == TemplateState.TemplateItemType.Text)
			{
				writer.Write(item.Value);
			}
			else if (item.Type == TemplateState.TemplateItemType.Container)
			{
				Control control = this.FindControl(item.Value);
				if (control == null)
				{
					throw new ArgumentException("The ContentPlaceHolder '" + item.Value + "' does not exist.");
				}
				control.RenderControl(writer);
			}
			else if (item.Type == TemplateState.TemplateItemType.Partial)
			{
				this.Html.RenderPartial(item.Value, this.ViewData);
			}
		}
	}
}
