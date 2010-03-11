using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Web.State;
using NearForums.Configuration;

namespace NearForums.Web.UI
{
	public class BaseViewUserControl<TModel> : ViewUserControl<TModel> where TModel : class
	{
		#region Properties
		public new SessionWrapper Session
		{
			get;
			set;
		}

		public new CacheWrapper Cache
		{
			get;
			set;
		}

		public UserState User
		{
			get
			{
				return Session.User;
			}
		}

		public SiteConfiguration Config
		{
			get
			{
				return SiteConfiguration.Current;
			}
		}
		#endregion

		protected override void OnInit(EventArgs e)
		{
			this.Session = new SessionWrapper(this.ViewContext.HttpContext.Session);
			this.Cache = new CacheWrapper(this.ViewContext.HttpContext.Cache);
			base.OnInit(e);
		}
	}

	public class BaseViewUserControl : BaseViewUserControl<object>
	{

	}
}
