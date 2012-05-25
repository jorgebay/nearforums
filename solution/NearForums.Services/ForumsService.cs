using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;

namespace NearForums.Services
{
	public class ForumsService : IForumsService
	{
		/// <summary>
		/// Forums repository
		/// </summary>
		private readonly IForumsDataAccess _dataAccess;

		public ForumsService(IForumsDataAccess da)
		{
			_dataAccess = da;
		}

		public List<ForumCategory> GetList(UserRole? role)
		{
			return _dataAccess.GetList(role);
		}

		public  List<ForumCategory> GetCategories()
		{
			return _dataAccess.GetCategories();
		}

		public  Forum Get(string shortName)
		{
			return _dataAccess.GetByShortName(shortName);
		}

		public  void Add(Forum forum, int userId)
		{
			forum.ValidateFields();
			SetAvailableShortName(forum);
			_dataAccess.Add(forum, userId);
		}

		public  void SetAvailableShortName(Forum forum)
		{
			if (forum == null || forum.ShortName == null)
			{
				throw new ArgumentNullException("Forum.ShortName");
			}
			forum.ShortName = _dataAccess.GetAvailableShortName(forum.ShortName);
		}

		public  void Edit(Forum forum, int userId)
		{
			forum.ValidateFields();
			_dataAccess.Edit(forum, userId);
		}

		public  bool Delete(string forum)
		{
			return _dataAccess.Delete(forum);
		}
	}
}
