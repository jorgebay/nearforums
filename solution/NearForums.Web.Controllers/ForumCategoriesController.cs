using System.Linq;
using System.Web.Mvc;
using NearForums.Services;
using NearForums.Validation;
using NearForums.Web.Controllers.Filters;

namespace NearForums.Web.Controllers
{
	public class ForumCategoriesController : BaseController
	{
		private readonly IForumCategoriesService _service;

		public ForumCategoriesController(IForumCategoriesService service)
		{
			_service = service;
		}

		[RequireAuthorization(UserRole.Admin)]
		public ActionResult List()
		{
			var list = _service.GetAll();
			return View(list);
		}

		[HttpGet]
		[RequireAuthorization(UserRole.Admin)]
		public ActionResult Add()
		{
			int count = _service.GetAll().Count();
			var forumCategoryModel = new ForumCategory() { Order = ++count };
			return View("Edit", forumCategoryModel);
		}

		[HttpPost]
		[RequireAuthorization(UserRole.Admin)]
		[ValidateInput(false)]
		public ActionResult Add(ForumCategory category)
		{
			try
			{
				_service.Add(category);
			}
			catch (ValidationException ex)
			{
				this.AddErrors(this.ModelState, ex);
			}

			if (ModelState.IsValid)
			{
				return RedirectToAction("List");
			}
			return View("Edit", category);
		}


		[HttpGet]
		[RequireAuthorization(UserRole.Admin)]
		public ActionResult Edit(int id)
		{
			var category = _service.Get(id);

			ViewData["IsEdit"] = true;
			return View("Edit", category);
		}

		[HttpPost]
		[RequireAuthorization(UserRole.Admin)]
		public ActionResult Edit(ForumCategory category)
		{
			try
			{
				_service.Edit(category);
			}
			catch (ValidationException ex)
			{
				this.AddErrors(this.ModelState, ex);
			}
			if (ModelState.IsValid)
			{
				return RedirectToAction("List");
			}
			return View("Edit", category);
		}


		[RequireAuthorization(UserRole.Admin)]
		public bool Delete(int id)
		{

			if (_service.GetForumCount(id) > 0)
			{
				return false;
			}
			return _service.Delete(id);
		}

	}
}
