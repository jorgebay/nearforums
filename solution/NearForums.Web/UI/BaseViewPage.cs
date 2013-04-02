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
			Localizer = Localizer.Current;
			base.InitializePage();
		}
		#endregion

		#region Properties
		private SessionWrapper _session;
		public new SessionWrapper Session
		{
			get
			{
				if (_session == null && Context != null)
				{
					_session = new SessionWrapper(Context.Session);
				}
				return _session;
			}
			set
			{
				_session = value;
			}
		}

		private CacheWrapper _cache; 
		public new CacheWrapper Cache
		{
			get
			{
				if (_cache == null && Context != null)
				{
					_cache = new CacheWrapper(Context.Cache);
				}
				return _cache;
			}
			set
			{
				_cache = value;
			}
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

		/// <summary>
		/// Gets the role of the current user
		/// </summary>
		public UserRole? Role
		{
			get
			{
				UserRole? role = null;
				if (User != null)
				{
					role = User.Role;
				}
				return role;
			}
		}

		/// <summary>
		/// Gets the current configuration
		/// </summary>
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
				if (ViewContext.RouteData.Values["action"] == null)
				{
					return "";
				}
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

		/// <summary>
		/// Returns an HtmlString containing the localized value
		/// </summary>
		/// <param name="neutralValue">The text to be localized</param>
		public virtual IHtmlString T(string neutralValue)
		{
			return MvcHtmlString.Create(S(neutralValue));
		}

		/// <summary>
		/// Returns an HtmlString containing the localized value
		/// </summary>
		/// <param name="neutralValue">The text to be localized</param>
		public virtual IHtmlString T(string neutralValue, params object[] args)
		{
			return MvcHtmlString.Create(S(neutralValue, args));
		}


		/// <summary>
		/// Returns the localized representation of the string
		/// </summary>
		/// <param name="neutralValue">The text to be localized</param>
		public virtual string S(string neutralValue, params object[] args)
		{
			var text = neutralValue;
			if (Localizer != null)
			{
				text = Localizer.Get(neutralValue, args);
			}
			return text;
		}

		/// <summary>
		/// Returns the localized representation of the string
		/// </summary>
		/// <param name="neutralValue">The text to be localized</param>
		public virtual string S(string neutralValue)
		{
			var text = neutralValue;
			if (Localizer != null)
			{
				text = Localizer[neutralValue];
			}
			return text; 
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
