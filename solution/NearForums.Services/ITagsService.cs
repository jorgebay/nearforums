using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums.Services
{
	public interface ITagsService
	{
		List<WeightTag> GetMostViewed(int forumId, int top);
	}
}
