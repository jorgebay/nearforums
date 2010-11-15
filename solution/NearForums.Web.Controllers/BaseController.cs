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

namespace NearForums.Web.Controllers
{
	[HandleErrorLog(View = "/Views/Errors/500.aspx")]
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
					_session = new SessionWrapper(this.ControllerContext.HttpContext.Session);
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

		public new UserState User
		{
			get
			{
				return Session.User;
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
				return this.Request.Url.Scheme + Uri.SchemeDelimiter + this.Request.Url.Host;
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
		#endregion

		#region Init
		protected override void Initialize(System.Web.Routing.RequestContext requestContext)
		{
			base.Initialize(requestContext);

			this.Init();
		}

		protected virtual void Init()
		{
			if (this.Config.Template.UseTemplates && Cache.Template == null)
			{
				LoadTemplate();
			}

			if (Session.User == null)
			{
				SecurityHelper.TryLoginFromProviders(this.Session, this.Cache, this.Request, this.Response);
			}
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

		#region Templates
		public void LoadTemplate()
		{
			//Gets the current template code from db
			Template t = TemplatesServiceClient.GetCurrent();


			//Get all the files in the directory
			TemplateState template = new TemplateState(t.Key);
			string[] fileNameList = SafeIO.Directory_GetFiles(Server.MapPath(template.Path), "*.part.*.html");
			foreach (string fileName in fileNameList)
			{
				template.Items.Add(new TemplateState.TemplateItem(SafeIO.File_ReadAllText(fileName)));
			}

			this.Cache.Template = template;
		}
		#endregion

		#region ViewResults
		protected override ViewResult View(string viewName, string masterName, object model)
		{
			if (masterName == null && Config != null)
			{
				masterName = Config.Template.Master;
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
			return View(useMaster, "~/Views/Static/" + key + ".aspx", null);
		}
		#endregion
	}
}
