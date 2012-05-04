using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;

namespace NearForums.Services
{
	public class TagsService : ITagsService
	{
		/// <summary>
		/// Tags repository
		/// </summary>
		private readonly ITagsDataAccess _dataAccess;

		public TagsService(ITagsDataAccess da)
		{
			_dataAccess = da;
		}

		public List<WeightTag> GetMostViewed(int forumId, int top)
		{
			return _dataAccess.GetMostViewed(forumId, top);
		}
	}
}
