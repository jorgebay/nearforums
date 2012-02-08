using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Web.Controllers.Helpers;
using NearForums.Web.State;
using NearForums.Configuration;
using NearForums.Validation;
using System.Web;
using NearForums.ServiceClient;
using NearForums.Web.Controllers.Filters;
using System.Text.RegularExpressions;
using NearForums.Web.Extensions;

namespace NearForums.Web.Controllers
{
	[HandleErrorLog(View = "Errors/500")]
	public class BaseController : Controller
	{
		#region Props
		#region State management
		private SessionWrapper _session;
		public new SessionWrapper Session
		{
			get
			{
				if (_session == null)
				{
					_session = new SessionWrapper(ControllerContext.HttpContext.Session);
				}
				return _session;
			}
			set
			{
				_session = value;
			}
		}

		private CacheWrapper _cache;
		public CacheWrapper Cache
		{
			get
			{
				if (_cache == null)
				{
					_cache = new CacheWrapper(this.ControllerContext.HttpContext.Cache);
				}
				return _cache;
			}
			set
			{
				_cache = value;
			}
		}

		/// <summary>
		/// Gets the current user in session
		/// </summary>
		public new UserState User
		{
			get
			{
				return Session.User;
			}
		}

		/// <summary>
		/// Gets the role of user making the request
		/// </summary>
		public UserRole? Role
		{
			get
			{
				UserRole? role = null;
				if (HttpContext != null && Session.User != null)
				{
					role = Session.User.Role;
				}
				return role;
			}
		}
		#endregion

		#region Config
		public SiteConfiguration Config
		{
			get
			{
				return SiteConfiguration.Current;
			}
		} 
		#endregion

		#region Uri
		public Uri Uri
		{
			get
			{
				return Request.Url;
			}
		} 
		#endregion

		#region Domain
		/// <summary>
		/// Gets the application current domain (Host) including Protocol and delimiter. Example: http://www.contoso.com (without slash).
		/// </summary>
		public string Domain
		{
			get
			{
				if (this.HttpContext == null)
				{
					return "http://www.contoso.com";
				}
				return this.Request.Url.Scheme + Uri.SchemeDelimiter + this.Request.Url.Host + (this.Request.Url.Port !=80 ? ":" + Request.Url.Port : String.Empty);
			}
		}
		#endregion

		#region ApplicationHome
		/// <summary>
		/// The application path url. It would be / or /forum/ depending on if its a main website or is a sub application
		/// </summary>
		private string ApplicationHomeUrl
		{
			get
			{
				return Url.Content("~/");
			}
		}
		#endregion

		#region Site Setup
		/// <summary>
		/// Determines if the site is correctly setup.
		/// </summary>
		public bool IsSiteSet
		{
			get
			{
				bool result = false;
				try
				{
					if (UsersServiceClient.GetTestUser() != null)
					{
						result = true;
					}
				}
				catch
				{
				}
				return result;
			}
		}
		#endregion

		#region Is Mobile Request
		/// <summary>
		/// Check if the current request' user agent is a mobile device.
		/// </summary>
		public bool IsMobileRequest
		{
			get
			{
				bool isMobile = false;
				if (Request != null && Config.UI.Template.Mobile.IsDefined && !String.IsNullOrEmpty(Request.UserAgent))
				{
					isMobile = Regex.IsMatch(Request.UserAgent, Config.UI.Template.Mobile.Regex, RegexOptions.IgnoreCase);
				}
				return isMobile;
			}
		}
		#endregion
		#endregion

		#region Init
		protected override void Initialize(System.Web.Routing.RequestContext requestContext)
		{
			base.Initialize(requestContext);

			this.Init();
		}

		protected virtual void Init()
		{
			if (Session.User == null)
			{
				SecurityHelper.TryLoginFromProviders(Session, Cache, HttpContext);
			}
			LoadTemplate();
		} 
		#endregion

		#region Model state errors
		/// <summary>
		/// Add the errors to the model state.
		/// </summary>
		protected void AddErrors(ModelStateDictionary modelState, ValidationException ex)
		{
			foreach (ValidationError error in ex.ValidationErrors)
			{
				modelState.AddModelError(error.FieldName, error);
			}
		}

		protected ModelErrorCollection GetErrors(ModelStateDictionary modelStateDictionary)
		{
			ModelErrorCollection errors = new ModelErrorCollection();
			foreach (KeyValuePair<string, ModelState> pair in modelStateDictionary)
			{
				foreach (ModelError error in pair.Value.Errors)
				{
					errors.Add(error);
				}
			}

			return errors;
		}
		#endregion

		#region Templates & Master
		/// <summary>
		/// Loads the current template
		/// </summary>
		protected virtual void LoadTemplate()
		{
			Template = TemplateHelper.LoadTemplate(HttpContext);
		}

		/// <summary>
		/// Returns active/current template. 
		/// It returns null if disabled by configuration or no active.
		/// </summary>
		public TemplateState Template
		{
			get;
			set;
		}

		public virtual string GetDefaultMasterName()
		{
			var masterName = "Site";
			if (IsMobileRequest)
			{
				masterName = "Mobile";
			}
			else if (Template != null)
			{
				masterName = "Templated";
			}

			return masterName;
		}
		#endregion

		#region Action Results
		protected override ViewResult View(string viewName, string masterName, object model)
		{
			if (masterName == null)
			{
				masterName = GetDefaultMasterName();
			}
			return base.View(viewName, masterName, model);
		}

		protected virtual ViewResult View(bool useMaster, object model)
		{
			return View(useMaster, null, model);
		}

		protected virtual ViewResult View(bool useMaster, string viewName, object model)
		{
			if (!useMaster)
			{
				return View(viewName, "", model);
			}
			return View(viewName, model);
		}

		protected virtual ActionResult Static(string key, bool useMaster)
		{
			return View(useMaster, "~/Views/Static/" + key + ".cshtml", null);
		}

		public ActionResult Captcha()
		{
			return CaptchaHelper.CaptchaResult(Session);
		}

		/// <summary>
		/// Only local Urls. Creates a RedirectResult object that redirects to the specified URL. Checks that the URL is a local url.
		/// If the url is null, it redirects to the application home.
		/// </summary>
		protected override RedirectResult Redirect(string url)
		{
			if ((!String.IsNullOrEmpty(url)) && Url != null && Url.IsLocalUrl(url))
			{
				return base.Redirect(url);
			}
			else
			{
				return base.Redirect(this.ApplicationHomeUrl);
			}
		}
		#endregion
	}
}
