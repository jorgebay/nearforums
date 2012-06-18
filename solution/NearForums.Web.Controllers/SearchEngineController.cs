using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Services;

namespace NearForums.Web.Controllers
{
	public class SearchEngineController : BaseController
	{
		/// <summary>
		/// Represents the service that performs the search on the index
		/// </summary>
		private readonly ISearchService _searchService;

		public SearchEngineController(ISearchService searchService, IUsersService userService) : base(userService)
		{
			_searchService = searchService;
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
			ViewBag.Q = q;
			return View(results);
		}

		/// <summary>
		/// Displays the Manage search index view
		/// </summary>
		/// <returns></returns>
		public ActionResult Manage()
		{
			ViewBag.DocumentCount = _searchService.DocumentCount;
			return View();
		}
	}
}
