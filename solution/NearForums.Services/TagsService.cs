using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;

namespace NearForums.Services
{
	public class TagsService : ITagsService
	{
		private readonly ITagsDataAccess dataAccess;

		public TagsService(ITagsDataAccess da)
		{
			dataAccess = da;
		}

		public List<WeightTag> GetMostViewed(int forumId, int top)
		{
			return dataAccess.GetMostViewed(forumId, top);
		}
	}
}
