using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Services;
using NearForums.Web.Controllers.Filters;

namespace NearForums.Web.Controllers
{
	public class SearchEngineController : BaseController
	{
		/// <summary>
		/// Represents the service that performs the search on the index
		/// </summary>
		private readonly ISearchService _searchService;
		/// <summary>
		/// Represents the service that indexes content in batches
		/// </summary>
		private readonly ISearchIndexBatchService _batchService;

		public SearchEngineController(ISearchService searchService, ISearchIndexBatchService batchService)
		{
			_searchService = searchService;
			_batchService = batchService;
		}

		/// <summary>
		/// Searches the index and displays the search results
		/// </summary>
		/// <param name="q">Search query</param>
		/// <param name="page">Page index (zero based)</param>
		/// <returns></returns>
		[HttpGet]
		public ActionResult Search(string q, int? page)
		{
			var results = _searchService.Search(q, page ?? 0);
			ViewBag.Page = page ?? 0;
			ViewBag.Q = q ?? "";
			return View(results);
		}

		/// <summary>
		/// Displays the Manage search index view
		/// </summary>
		/// <returns></returns>
		[RequireAuthorization(UserRole.Admin)]
		public ActionResult Manage()
		{
			ViewBag.DocumentCount = _searchService.DocumentCount;
			return View();
		}
		
		[HttpPost]
		[ValidateAntiForgeryToken]
		[RequireAuthorization(UserRole.Admin, RefuseOnFail=true)]
		public ActionResult ReindexStart()
		{
			_searchService.CreateIndex();
			var forums = _batchService.GetForums();
			return Json(forums);
		}

		[HttpPost]
		[ValidateAntiForgeryToken]
		[RequireAuthorization(UserRole.Admin, RefuseOnFail = true)]
		public ActionResult IndexBatch(int forumId, int index)
		{
			var indexed = _batchService.IndexBatch(forumId, index);
			return Json(indexed);
		}
	}
}
