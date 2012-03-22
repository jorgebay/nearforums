using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums.DataAccess
{
	public interface ITopicsSubscriptionsDataAccess
	{
		void Add(int topicId, int userId);
		List<Topic> GetTopicsByUser(int userId);
		List<User> GetUsersByTopic(int topicId);
		int Remove(int topicId, int userId, Guid guid);
	}
}
