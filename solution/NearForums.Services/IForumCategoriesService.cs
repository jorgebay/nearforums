using System.Collections.Generic;

namespace NearForums.Services
{
	public interface IForumCategoriesService
	{
		List<ForumCategory> GetAll();
		ForumCategory Get(int id);
		void Add(ForumCategory category);
		void Edit(ForumCategory category);
		bool Delete(int id);
		int GetForumCount(int id);

	}
}
