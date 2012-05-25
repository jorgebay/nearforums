using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums.DataAccess
{
	public interface IForumsDataAccess
	{
		void Add(Forum f, int userId);
		bool Delete(string forum);
		void Edit(Forum f, int userId);
		string GetAvailableShortName(string shortName);
		NearForums.Forum GetByShortName(string shortName);
		System.Collections.Generic.List<ForumCategory> GetCategories();
		System.Collections.Generic.List<ForumCategory> GetList(UserRole? role);
	}
}
