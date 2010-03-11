using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

namespace NearForums.Web.UI.Views.Shared
{
	public class Site : BaseViewMasterPage
	{
		protected Panel pnlLogin;
		protected Panel pnlLogged;

		protected override void OnLoad(EventArgs e)
		{
			if (User != null)
			{
				pnlLogin.Visible = false;
				pnlLogged.Visible = true;
			}
			base.OnLoad(e);
		}
	}
}
