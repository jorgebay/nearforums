using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.Web.Mvc;
using System.Web;

using NearForums.Validation;
using NearForums.ServiceClient;
using NearForums.Web.Controllers.Filters;
using NearForums.Web.Controllers.Helpers;
using System.Net;
using NearForums.Web.Extensions;
using System.Text.RegularExpressions;
using ICSharpCode.SharpZipLib.Zip;
using NearForums.Configuration;

namespace NearForums.Web.Controllers
{
	public class TemplatesController : BaseController
	{
		#region Add template
		[RequireAuthorization(UserGroup.Admin)]
		[AcceptVerbs(HttpVerbs.Get)]
		public ActionResult Add()
		{
			return View();
		}


		[RequireAuthorization(UserGroup.Admin)]
		[HttpPost]
		[ValidateInput(true)]
		public ActionResult Add([Bind(Prefix = "")] Template template, HttpPostedFileBase postedFile)
		{

			try
			{
				TemplateHelper.Add(template, postedFile, HttpContext);
				return RedirectToAction("List");
			}
			catch (ValidationException ex)
			{
				this.AddErrors(this.ModelState, ex);
			}
			return View();
		}
		#endregion

		#region List templates
		[RequireAuthorization(UserGroup.Admin)]
		public ActionResult List(TemplateActionError? error)
		{
			var list = TemplatesServiceClient.GetAll();
			ViewBag.BasePath = Url.Content(Config.UI.Template.Path);
			if (error == TemplateActionError.DeleteCurrent)
			{
				ViewBag.DeleteCurrent = true;
			}
			else if (error == TemplateActionError.UnauthorizedAccess)
			{
				ViewBag.Access = true;
			}
			return View(list);
		}

		public enum TemplateActionError
		{
			DeleteCurrent=0,
			UnauthorizedAccess=1
		}
		#endregion 

		#region Set current
		[RequireAuthorization(UserGroup.Admin)]
		[ValidateAntiForgeryToken]
		[HttpPost]
		public ActionResult SetCurrent(int id)
		{
			TemplatesServiceClient.SetCurrent(id);

			this.Cache.Template = null;

			return RedirectToAction("List");
		}
		#endregion

		#region Delete Template
		[RequireAuthorization(UserGroup.Admin)]
		[ValidateAntiForgeryToken]
		[HttpPost]
		public ActionResult Delete(int id)
		{
			TemplateActionError? error = null;

			Template t = TemplatesServiceClient.Get(id);
			if (t != null)
			{
				if (t.IsCurrent)
				{
					error = TemplateActionError.DeleteCurrent;
				}
				else
				{

					string baseDirectory = Server.MapPath(Config.UI.Template.Path + t.Key);
					try
					{
						SafeIO.Directory_Delete(baseDirectory, true);
						TemplatesServiceClient.Delete(id);
					}
					catch (UnauthorizedAccessException)
					{
						error = TemplateActionError.UnauthorizedAccess;
					}
				}
				
			}
			return RedirectToAction("List", new{error=error});
		}
		#endregion

		#region Export
		[RequireAuthorization(UserGroup.Admin)]
		public ActionResult Export(int id)
		{
			var template = TemplatesServiceClient.Get(id);
			string fileName = Server.MapPath(Config.UI.Template.Path + template.Key + "/template.zip");
			return new FilePathResult(fileName, "application/zip") 
			{ 
				FileDownloadName = template.Key + ".zip"
			};
		}
		#endregion

		#region How to
		[RequireAuthorization(UserGroup.Admin)]
		public ActionResult HowTo()
		{
			return View();
		}
		#endregion

		#region Preview
		[RequireAuthorization(UserGroup.Admin)]
		public ActionResult Preview(int id)
		{
			Session.IsTemplatePreview = true;
			return RedirectToRoute(new { controller="Forums", action="List", _tid=id});
		}
		#endregion
	}
}
