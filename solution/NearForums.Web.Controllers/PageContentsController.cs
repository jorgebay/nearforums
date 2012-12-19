using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Services;
using NearForums.Web.Extensions;
using NearForums.Web.Controllers.Filters;
using NearForums.Validation;
using NearForums.Web.Controllers.Helpers;

namespace NearForums.Web.Controllers
{
	public class PageContentsController : BaseController
	{
		/// <summary>
		/// PageContents service
		/// </summary>
		private readonly IPageContentsService _service;

		public PageContentsController(IPageContentsService serv)
		{
			_service = serv;
		}

		[RequireAuthorization(UserRole.Admin)]
		public ActionResult List()
		{
			var list = _service.GetAll();
			return View(list);
		}

		public ActionResult Detail(string name)
		{
			var content = _service.Get(name);
			if (content == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			return View(content);
		}

		[HttpGet]
		[RequireAuthorization(UserRole.Admin)]
		public ActionResult Add()
		{
			return View("Edit");
		}

		[HttpPost]
		[RequireAuthorization(UserRole.Admin)]
		[ValidateInput(false)]
		public ActionResult Add([Bind] PageContent content)
		{
			try
			{
				content.ShortName = content.Title.ToUrlSegment(128);
				_service.Add(content);
			}
			catch (ValidationException ex)
			{
				this.AddErrors(this.ModelState, ex);
			}
			if (ModelState.IsValid)
			{
				return RedirectToAction("Detail", new{name=content.ShortName});
			}
			else
			{
				return View("Edit", content);
			}
		}

		[HttpGet]
		[RequireAuthorization(UserRole.Admin)]
		public ActionResult Edit(string name)
		{
			var content = _service.Get(name);
			if (content == null)
			{
				return ResultHelper.NotFoundResult(this);
			}
			ViewData["IsEdit"] = true;
			return View(content);
		}

		[HttpPost]
		[RequireAuthorization(UserRole.Admin)]
		[ValidateInput(false)]
		public ActionResult Edit(string name, [Bind] PageContent content)
		{
			try
			{
				content.ShortName = name;
				_service.Edit(content);
			}
			catch (ValidationException ex)
			{
				this.AddErrors(this.ModelState, ex);
			}
			if (ModelState.IsValid)
			{
				return RedirectToAction("Detail", new{name = content.ShortName});
			}
			else
			{
				ViewData["IsEdit"] = true;
				return View(content);
			}
		}

		[HttpPost]
		[RequireAuthorization(UserRole.Admin, RefuseOnFail=true)]
		public ActionResult Delete(string name)
		{
			bool deleted = _service.Delete(name);
			return Json(deleted);
		}
	}
}
