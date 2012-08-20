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
		Forum GetByShortName(string shortName);

		/// <summary>
		/// Get all categories (without the forums in it).
		/// </summary>
		List<ForumCategory> GetCategories();

		/// <summary>
		/// Gets a list of ForumCategories with the list forums, dependant of the user role.
		/// </summary>
		List<ForumCategory> GetList(UserRole? role);
	}
}
