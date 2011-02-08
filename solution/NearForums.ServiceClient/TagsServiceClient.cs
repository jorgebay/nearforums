using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;

namespace NearForums.ServiceClient
{
	public static class TagsServiceClient
	{
		public static List<WeightTag> GetMostViewed(int forumId, int top)
		{
			TagsDataAccess da = new TagsDataAccess();
			return da.GetMostViewed(forumId, top);
		}
	}
}
