using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;
using NearForums.Dto;
using NearForums.Configuration;

namespace NearForums.Services
{
	public class SearchIndexBatchService : ISearchIndexBatchService
	{
		/// <summary>
		/// Topics repository
		/// </summary>
		private readonly IForumsService _forumsService;
		/// <summary>
		/// Forums repository
		/// </summary>
		private readonly ITopicsService _topicsService;
		/// <summary>
		/// Represents the service that performs the index of documents
		/// </summary>
		private readonly ISearchService _searchService;

		public SearchIndexBatchService(IForumsService forumsService, ISearchService searchService, ITopicsService topicsService)
		{
			_searchService = searchService;
			_topicsService = topicsService;
			_forumsService = forumsService;
		}

		public List<ForumDto> GetForums()
		{
			var categories = _forumsService.GetList(null);
			var forums = categories.SelectMany<ForumCategory, Forum>(category => category.Forums).ToList();
			return forums.Select<Forum, ForumDto>(f => new ForumDto(f)).ToList();
		}

		public void IndexBatch(int forumId, int index)
		{
			throw new NotImplementedException();
			var config = SiteConfiguration.Current.Search;
			var topics = _topicsService.GetByForum(forumId, index * config.IndexBatchSize, config.IndexBatchSize, null);
			foreach (var t in topics)
			{
				var completeTopic = _topicsService.GetMessagesFrom(t.Id, 1, config.MaxMessages, 1);
				//TODO: Add multiple and then commit: _searchService.Add(completeTopic);
			}
		}
	}
}