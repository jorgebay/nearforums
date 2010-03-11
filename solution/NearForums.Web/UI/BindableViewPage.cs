using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums.Web.UI
{
	public class BindableViewPage<TModel,TBindModel> : BaseViewPage<TModel> where TModel : class
	{
		protected override void OnLoad(EventArgs e)
		{
			base.OnLoad(e);

			this.DataBind();
		}

		protected TBindModel Item
		{
			get
			{
				return (TBindModel)this.Page.GetDataItem();
			}
		}
	}
}
