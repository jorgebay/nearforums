using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;
using NearForums.Validation;

namespace NearForums.ServiceClient
{
	public static class ForumsServiceClient
	{
		/// <summary>
		/// Gets a list of ForumCategories with the list forums.
		/// </summary>
		public static List<ForumCategory> GetList()
		{
			ForumsDataAccess da = new ForumsDataAccess();
			return da.GetList();
		}

		/// <summary>
		/// Get all categories (without the forums in it).
		/// </summary>
		public static List<ForumCategory> GetCategories()
		{
			ForumsDataAccess da = new ForumsDataAccess();
			return da.GetCategories();
		}

		public static Forum Get(string shortName)
		{
			ForumsDataAccess da = new ForumsDataAccess();
			return da.GetByShortName(shortName);
		}

		public static void Add(Forum forum, int userId)
		{
			forum.ValidateFields();
			SetAvailableShortName(forum);
			ForumsDataAccess da = new ForumsDataAccess();
			da.Add(forum, userId);
		}

		/// <summary>
		/// Validates if a forum shortname is already taken
		/// </summary>
		/// <exception cref="ArgumentNullException"></exception>
		public static void SetAvailableShortName(Forum forum)
		{
			if (forum == null || forum.ShortName == null)
			{
				throw new ArgumentNullException("Forum.ShortName");
			}
			ForumsDataAccess da = new ForumsDataAccess();
			forum.ShortName = da.GetAvailableShortName(forum.ShortName);
		}

		public static void Edit(Forum forum, int userId)
		{
			forum.ValidateFields();
			ForumsDataAccess da = new ForumsDataAccess();
			da.Edit(forum, userId);
		}
	}
}
