using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Web.Controllers.Extensions;
using NearForums.Web.State;
using NearForums.Configuration;
using NearForums.Validation;
using System.IO;
using System.Web;
using NearForums.ServiceClient;

namespace NearForums.Web.Controllers
{
	public class BaseController : Controller
	{
		#region Props
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

		public Uri Uri
		{
			get
			{
				return Request.Url;
			}
		}
		#endregion

		#region Init
		protected override void Initialize(System.Web.Routing.RequestContext requestContext)
		{
			base.Initialize(requestContext);

			this.Init();
		}

		protected virtual void Init()
		{
			if (Cache.Template == null)
			{
				LoadTemplate();
			}

			if (Session.User == null)
			{
				SecurityHelper.TryLoginFromProviders(this.Session);
			}
		} 
		#endregion

		#region Actions
		public ActionResult Static(string key)
		{
			return View("~/Views/Static/" + key + ".aspx", "", null);
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
			//TODO: Get the current template code from db
			string key = TemplatesServiceClient.GetCurrent().Key;

			//Get all the files in the directory
			TemplateState template = new TemplateState(key);
			string[] fileNameList = Directory.GetFiles(Server.MapPath(template.Path), "*.part.*.html");
			foreach (string fileName in fileNameList)
			{
				template.Items.Add(new TemplateState.TemplateItem(System.IO.File.ReadAllText(fileName)));
			}

			this.Cache.Template = template;
		}
		#endregion

		#region View
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
		#endregion
	}
}
