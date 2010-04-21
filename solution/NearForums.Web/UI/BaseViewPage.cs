using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Web.State;
using System.Web;
using NearForums.Configuration;
using NearForums.Web.Extensions;

namespace NearForums.Web.UI
{
	public class BaseViewPage<TModel> : ViewPage<TModel> where TModel : class
	{
		#region Initialization
		public BaseViewPage()
		{
			this.AllowMaster = true;
		}

		protected override void OnPreInit(EventArgs e)
		{
			if (!this.AllowMaster)
			{
				this.MasterLocation = null;
			}
			base.OnPreInit(e);
		}

		protected override void OnInit(EventArgs e)
		{
			this.Session = new SessionWrapper(this.ViewContext.HttpContext.Session);
			this.Cache = new CacheWrapper(this.ViewContext.HttpContext.Cache);
			base.OnInit(e);
		} 
		#endregion

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

		public new UserState User
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

		/// <summary>
		/// Current page index (ViewData["Page"])
		/// </summary>
		public int PageIndex
		{
			get
			{
				if (ViewData.ContainsKey("Page"))
				{
					return Convert.ToInt32(ViewData["Page"]);
				}
				return 0;
			}
		}

		public bool AllowMaster
		{
			get;
			set;
		}

		#region Domain
		/// <summary>
		/// Gets the application current domain (Host) including Protocol and delimiter. Example: http://www.contoso.com (without slash).
		/// </summary>
		public string Domain
		{
			get
			{
				if (this.ViewContext == null)
				{
					return "http://www.contoso.com";
				}
				return this.ViewContext.HttpContext.Request.Url.Scheme + Uri.SchemeDelimiter + this.ViewContext.HttpContext.Request.Url.Host;
			}
		}
		#endregion
		#endregion

		protected virtual T Eval<T>()
		{
			return (T)this.Page.GetDataItem();
		}

		protected ViewDataDictionary CreateViewData(object values)
		{
			return ViewDataExtensions.CreateViewData(values);
		}
	}

	public class BaseViewPage : BaseViewPage<object>
	{

	}
}
