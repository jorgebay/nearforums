using System.Collections.Generic;
using NearForums.DataAccess;

namespace NearForums.Services
{
	public class ForumCategoriesService : IForumCategoriesService
	{
		/// <summary>
		/// Page contents repository
		/// </summary>
		private readonly IForumCategoriesDataAccess _dataAccess;

		public ForumCategoriesService(IForumCategoriesDataAccess dService)
		{
			_dataAccess = dService;
		}
		public List<ForumCategory> GetAll()
		{
			return _dataAccess.GetAll();
		}

		public ForumCategory Get(int id)
		{
			return _dataAccess.Get(id);
		}

		public void Add(ForumCategory category)
		{
			category.ValidateFields();
			_dataAccess.Add(category);
		}

		public void Edit(ForumCategory category)
		{
			category.ValidateFields();
			_dataAccess.Edit(category);
		}

		public bool Delete(int id)
		{
			return _dataAccess.Delete(id);
		}

		public int GetForumCount(int id)
		{
			return _dataAccess.GetForumCount(id);
		}
	}
}
