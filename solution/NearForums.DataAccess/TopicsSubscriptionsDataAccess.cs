using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;
using System.Data;

namespace NearForums.DataAccess
{
	public class TopicsSubscriptionsDataAccess: BaseDataAccess, ITopicsSubscriptionsDataAccess
	{
		/// <summary>
		/// Add a subscription for the user to the topic
		/// </summary>
		public void Add(int topicId, int userId)
		{
			var comm = this.GetCommand("SPTopicsSubscriptionsInsert");
			comm.AddParameter<int>(this.Factory, "TopicId", topicId);
			comm.AddParameter<int>(this.Factory, "UserId", userId);

			comm.SafeExecuteNonQuery();
		}

		public int Remove(int topicId, int userId, Guid guid)
		{
			var comm = this.GetCommand("SPTopicsSubscriptionsDelete");
			comm.AddParameter<int>(this.Factory, "TopicId", topicId);
			comm.AddParameter<int>(this.Factory, "UserId", userId);
			comm.AddParameter<Guid>(this.Factory, "UserGuid", guid);

			return comm.SafeExecuteNonQuery();
		}

		/// <summary>
		/// Gets users subscribed to a topic
		/// </summary>
		public List<User> GetUsersByTopic(int topicId)
		{
			List<User> users = new List<User>();

			var comm = this.GetCommand("SPTopicsSubscriptionsGetByTopic");
			comm.AddParameter<int>(this.Factory, "TopicId", topicId);

			DataTable dt = this.GetTable(comm);
			foreach (DataRow dr in dt.Rows)
			{
				var u = new User(dr.Get<int>("UserId"), dr.GetString("UserName"));
				u.Email = dr.GetString("UserEmail");
				u.EmailPolicy = (EmailPolicy)(dr.GetNullable<int?>("UserEmailPolicy") ?? (int)EmailPolicy.None);
				u.Guid = dr.Get<Guid>("UserGuid");
				users.Add(u);
			}

			return users;
		}

		/// <summary>
		/// Gets the topics to which the user subscribed to
		/// </summary>
		public List<Topic> GetTopicsByUser(int userId)
		{
			var topics = new List<Topic>();

			var comm = this.GetCommand("SPTopicsSubscriptionsGetByUser");
			comm.AddParameter<int>(this.Factory, "UserId", userId);

			DataTable dt = this.GetTable(comm);
			foreach (DataRow dr in dt.Rows)
			{
				var t = new Topic(dr.Get<int>("TopicId"));
				t.Title = dr.GetString("TopicTitle");
				t.ShortName = dr.GetString("TopicShortName");
				t.Forum = new Forum();
				t.Forum.Id = dr.Get<int>("ForumId");
				t.Forum.Name = dr.GetString("ForumName");
				t.Forum.ShortName = dr.GetString("ForumShortName");
				topics.Add(t);
			}

			return topics;
		}
	}
}
