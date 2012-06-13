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

		[HttpGet]
		public ActionResult Search(string q)
		{
			var results = _searchService.Search(q);
			return View(results);
		}
	}
}
