using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.Web.Mvc;
using System.Web;

using NearForums.Validation;
using NearForums.Services;
using NearForums.Web.Controllers.Filters;
using NearForums.Web.Controllers.Helpers;
using System.Net;
using NearForums.Web.Extensions;
using System.Text.RegularExpressions;
using ICSharpCode.SharpZipLib.Zip;
using NearForums.Configuration;
using System.IO;

namespace NearForums.Web.Controllers
{
	public class TemplatesController : BaseController
	{
		/// <summary>
		/// Template service
		/// </summary>
		private readonly ITemplatesService _service;

		public TemplatesController(ITemplatesService templateService, IUsersService userService) : base(userService)
		{
			_service = templateService;
		}

		#region Add template
		[RequireAuthorization(UserRole.Admin)]
		[HttpGet]
		public ActionResult Add()
		{
			return View();
		}


		[RequireAuthorization(UserRole.Admin)]
		[HttpPost]
		[ValidateInput(true)]
		public ActionResult Add([Bind(Prefix = "")] Template template, HttpPostedFileBase postedFile, bool useDefaultName)
		{

			try
			{
				if (useDefaultName)
				{
					template.Key = SafeIO.Path_GetFileNameWithoutExtension(postedFile.FileName);
				}

				if (SafeIO.Path_GetExtension(postedFile.FileName) != ".zip")
				{
					throw new ValidationException(new ValidationError("postedFile", ValidationErrorType.FileFormat));
				}

				TemplateHelper.Add(template, postedFile.InputStream, HttpContext, _service);
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
		[RequireAuthorization(UserRole.Admin)]
		public ActionResult List(TemplateActionError? error)
		{
			var list = _service.GetAll();
			ViewBag.BasePath = Url.Content(Config.TemplateFolderPath(""));
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
		[RequireAuthorization(UserRole.Admin)]
		[ValidateAntiForgeryToken]
		[HttpPost]
		public ActionResult SetCurrent(int id)
		{
			_service.SetCurrent(id);

			this.Cache.Template = null;

			return RedirectToAction("List");
		}
		#endregion

		#region Delete Template
		[RequireAuthorization(UserRole.Admin)]
		[ValidateAntiForgeryToken]
		[HttpPost]
		public ActionResult Delete(int id)
		{
			TemplateActionError? error = null;

			Template t = _service.Get(id);
			if (t != null)
			{
				if (t.IsCurrent)
				{
					error = TemplateActionError.DeleteCurrent;
				}
				else
				{

					string baseDirectory = Config.TemplateFolderPathFull(t.Key);
					try
					{
						SafeIO.Directory_Delete(baseDirectory, true);
						_service.Delete(id);
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
		[RequireAuthorization(UserRole.Admin)]
		public ActionResult Export(int id)
		{
			var template = _service.Get(id);
			string fileName = Config.TemplateFolderPath(template.Key) + "/template.zip";
			return new FilePathResult(fileName, "application/zip") 
			{ 
				FileDownloadName = template.Key + ".zip"
			};
		}
		#endregion

		#region Preview
		[RequireAuthorization(UserRole.Admin)]
		public ActionResult Preview(int id)
		{
			Session.IsTemplatePreview = true;
			return RedirectToRoute(new { controller="Forums", action="List", _tid=id});
		}
		#endregion

		#region Load Default Templates
		/// <summary>
		/// Loads all templates delivered on install
		/// </summary>
		[RequireAuthorization(UserRole.Admin)]
		[ValidateAntiForgeryToken]
		[HttpPost]
		public ActionResult AddDefaultTemplates()
		{
			var path = Config.TemplateFolderPathFull("installation") + "\\";
			ViewBag.TemplateCount = 0;
			ViewBag.Path = path;
			try
			{
				ViewBag.TemplateCount = TemplateHelper.AddDefaultTemplates(path, HttpContext, _service);
			}
			catch (DirectoryNotFoundException ex)
			{
				ViewBag.ErrorMessage = ex.Message;
			}
			catch (UnauthorizedAccessException ex)
			{
				ViewBag.ErrorMessage = ex.Message;
			}
			catch (ValidationException ex)
			{
				if (ex.ValidationErrors.Count > 0)
				{
					if (ex.ValidationErrors[0].Type == ValidationErrorType.AccessRights)
					{
						ViewBag.ErrorMessage = "The application does not have write access in the template folder.";
					}
				}
			}
			return View();
		}
		#endregion
	}
}
