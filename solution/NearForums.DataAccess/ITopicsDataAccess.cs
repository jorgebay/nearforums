using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums.DataAccess
{
	public interface ITopicsDataAccess
	{
		void Add(Topic topic, string ip);
		void AddVisit(int topicId);
		void Close(int id, int userId, string ip);
		void Delete(int id, int userId, string ip);
		void Edit(Topic topic, string ip);
		Topic Get(int id);
		List<Topic> GetByForum(int forumId, int startIndex, int length, UserRole? role);
		List<Topic> GetByForumLatest(int forumId, int startIndex, int length, UserRole? role);
		List<Topic> GetByTag(string tag, int forumId, UserRole? role);
		List<Topic> GetByUser(int userId, UserRole? role);
		List<Topic> GetLatest();
		List<Topic> GetRelatedTopics(Topic topic, int amount);
		List<Topic> GetTopicsAndMessagesByUser(int userId);
		List<Topic> GetUnanswered();
		List<Topic> GetUnanswered(int forumId, UserRole? role);
		void Move(int id, int forumId, int userId, string ip);
		void Open(int id, int userId, string ip);
	}
}
