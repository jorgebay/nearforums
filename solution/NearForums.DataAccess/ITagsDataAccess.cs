using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums.DataAccess
{
	public interface ITagsDataAccess
	{
		List<WeightTag> GetMostViewed(int forumId, int top);
	}
}
