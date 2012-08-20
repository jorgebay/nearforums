using System;
using System.Collections.Generic;
namespace NearForums.Services
{
	public interface IForumsService
	{
		void Add(Forum forum, int userId);
		/// <summary>
		/// Deletes a forum from the system (not a phisical delete).
		/// </summary>
		/// <param name="forum"></param>
		/// <returns></returns>
		bool Delete(string forum);
		void Edit(Forum forum, int userId);
		Forum Get(string shortName);
		/// <summary>
		/// Get all categories (without the forums in it).
		/// </summary>
		List<ForumCategory> GetCategories();
		/// <summary>
		/// Gets a list of ForumCategories with the list forums, dependant of the user role.
		/// </summary>
		List<ForumCategory> GetList(UserRole? role);
		/// <summary>
		/// Validates if a forum shortname is already taken
		/// </summary>
		/// <exception cref="ArgumentNullException"></exception>
		void SetAvailableShortName(Forum forum);
	}
}
