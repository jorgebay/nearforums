using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;
using NearForums.Dto;

namespace NearForums.Services
{
	public class SearchIndexBatchService : ISearchIndexBatchService
	{
		/// <summary>
		/// Forums repository
		/// </summary>
		private readonly IForumsDataAccess _forumsDa;
		/// <summary>
		/// Represents the service that performs the index of documents
		/// </summary>
		private readonly ISearchService _searchService;

		public SearchIndexBatchService(ISearchService searchService, IForumsDataAccess forumsDa, ITopicsDataAccess topics)
		{
			_searchService = searchService;
			_forumsDa = forumsDa;
		}

		public List<ForumDto> GetForums()
		{
			var categories = _forumsDa.GetList(null);
			var forums = categories.SelectMany<ForumCategory, Forum>(category => category.Forums).ToList();
			return forums.Select<Forum, ForumDto>(f => new ForumDto(f)).ToList();
		}

		public void IndexBatch(int forumId, int index)
		{
			
		}
	}
}
