using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;

namespace NearForums.ServiceClient
{
	public static class ForumsServiceClient
	{
		public static List<ForumCategory> GetList()
		{
			ForumsDataAccess da = new ForumsDataAccess();
			return da.GetList();
		}

		public static Forum Get(string shortName)
		{
			ForumsDataAccess da = new ForumsDataAccess();
			return da.GetByShortName(shortName);
		}

		public static void Add(Forum forum, int userId)
		{
			forum.ValidateFields();
			ForumsDataAccess da = new ForumsDataAccess();
			da.Add(forum, userId);
		}
	}
}
