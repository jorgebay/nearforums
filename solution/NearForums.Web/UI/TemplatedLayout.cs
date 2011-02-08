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
		public override void ExecutePageHierarchy()
		{
			base.ExecutePageHierarchy();
			foreach (TemplateState.TemplateItem item in this.Cache.Template.Items)
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
					case "MAINCONTENT":
						Write(RenderBody());
						break;
					case "HEADCONTENT":
						if (IsSectionDefined("Head"))
						{
							Write(RenderSection("Head"));
						}
						break;
				}
			}
			else if (item.Type == TemplateState.TemplateItemType.Partial)
			{
				Write(this.Html.Partial(item.Value, this.ViewData));
			}
		}
	}
}
