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
using NearForums.Localization;

namespace NearForums.Web.UI
{
	public class BaseViewPage<TModel> : WebViewPage<TModel> where TModel : class
	{
		#region Initialization
		public BaseViewPage()
		{

		}

		protected override void InitializePage()
		{
			Session = new SessionWrapper(this.ViewContext.HttpContext.Session);
			Cache = new CacheWrapper(this.ViewContext.HttpContext.Cache);
			Localizer = Localizer.Current;
			base.InitializePage();
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

		public virtual Localizer Localizer
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

		/// <summary>
		/// Gets the current action name
		/// </summary>
		public string ActionName
		{
			get
			{
				return ViewContext.RouteData.Values["action"].ToString();
			}
		}

		/// <summary>
		/// Determines if it is the current actionName
		/// </summary>
		/// <param name="actionName"></param>
		/// <returns></returns>
		public bool IsAction(string actionName)
		{
			return this.ActionName.ToUpper() == actionName.ToUpper();
		}
		#endregion

		#region Methods
		protected ViewDataDictionary CreateViewData(object values)
		{
			return ViewDataExtensions.CreateViewData(values);
		}

		public virtual IHtmlString T(string neutralValue)
		{
			var text = neutralValue;
			if (Localizer != null)
			{
				text = Localizer[neutralValue];
			}
			return text.ToHtmlString(); 
		}

		public virtual IHtmlString T(string neutralValue, params object[] args)
		{
			var text = neutralValue;
			if (Localizer != null)
			{
				text = Localizer.Get(neutralValue, args);
			}
			return text.ToHtmlString();
		}

		public override void Execute()
		{

		}
		#endregion
	}

	public class BaseViewPage : BaseViewPage<object>
	{

	}
}
