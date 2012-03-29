using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;

namespace NearForums.Services
{
	public class ForumsService : IForumsService
	{
		private readonly IForumsDataAccess dataAccess;
		public ForumsService(IForumsDataAccess da)
		{
			dataAccess = da;
		}

		public List<ForumCategory> GetList(UserRole? role)
		{
			return dataAccess.GetList(role);
		}

		public  List<ForumCategory> GetCategories()
		{
			return dataAccess.GetCategories();
		}

		public  Forum Get(string shortName)
		{
			return dataAccess.GetByShortName(shortName);
		}

		public  void Add(Forum forum, int userId)
		{
			forum.ValidateFields();
			SetAvailableShortName(forum);
			dataAccess.Add(forum, userId);
		}

		public  void SetAvailableShortName(Forum forum)
		{
			if (forum == null || forum.ShortName == null)
			{
				throw new ArgumentNullException("Forum.ShortName");
			}
			forum.ShortName = dataAccess.GetAvailableShortName(forum.ShortName);
		}

		public  void Edit(Forum forum, int userId)
		{
			forum.ValidateFields();
			dataAccess.Edit(forum, userId);
		}

		public  bool Delete(string forum)
		{
			return dataAccess.Delete(forum);
		}
	}
}
