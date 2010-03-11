using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using NearForums.DataAccess;

namespace NearForums.DataAccess
{
	public class TopicsDataAccess : BaseDataAccess
	{
		public List<Topic> GetByForum(int forumId, int startIndex, int length)
		{
			List<Topic> list = new List<Topic>();
			SqlCommand comm = this.GetCommand("SPTopicsGetByForum");
			comm.AddParameter("@ForumId", SqlDbType.Int, forumId);
			comm.AddParameter("@StartIndex", SqlDbType.Int, startIndex);
			comm.AddParameter("@Length", SqlDbType.Int, length);

			DataTable dt = this.GetTable(comm);
			foreach (DataRow dr in dt.Rows)
			{
				Topic t = ParseBasicTopicDataRow(dr);
				t.User = new User(dr.Get<int>("UserId"), dr.Get<string>("UserName"));

				list.Add(t);
			}
			return list;
		}

		public List<Topic> GetByForumLatest(int forumId, int startIndex, int length)
		{
			List<Topic> list = new List<Topic>();
			SqlCommand comm = this.GetCommand("SPTopicsGetByForumLatest");
			comm.AddParameter("@ForumId", SqlDbType.Int, forumId);
			comm.AddParameter("@StartIndex", SqlDbType.Int, startIndex);
			comm.AddParameter("@Length", SqlDbType.Int, length);

			DataTable dt = this.GetTable(comm);
			foreach (DataRow dr in dt.Rows)
			{
				Topic t = ParseBasicTopicDataRow(dr);
				t.User = new User(dr.Get<int>("UserId"), dr.Get<string>("UserName"));

				list.Add(t);
			}
			return list;
		}

		public List<Topic> GetLatest()
		{
			List<Topic> list = new List<Topic>();
			SqlCommand comm = this.GetCommand("SPTopicsGetLatest");

			DataTable dt = this.GetTable(comm);
			foreach (DataRow dr in dt.Rows)
			{
				Topic t = ParseBasicTopicDataRow(dr);
				t.User = new User(dr.Get<int>("UserId"), dr.Get<string>("UserName"));

				list.Add(t);
			}
			return list;
		}

		public Topic Get(int id)
		{
			Topic t = null;
			SqlCommand comm = GetCommand("SPTopicsGet");
			comm.AddParameter("@TopicId", SqlDbType.Int, id);
			DataRow dr = this.GetFirstRow(comm);
			if (dr != null)
			{
				t = ParseBasicTopicDataRow(dr);
				t.User = new User(dr.Get<int>("UserId"), dr.Get<string>("UserName"));
				t.Forum = new Forum();
				t.Forum.Id = dr.Get<int>("ForumId");
				t.Forum.Name = dr.GetString("ForumName");
				t.Forum.ShortName = dr.GetString("ForumShortName");
				t.Tags = new TagList(dr.GetString("TopicTags"));
			}
			return t;
		}

		public List<Topic> GetRelatedTopics(Topic topic, int amount)
		{
			List<Topic> list = new List<Topic>();
			SqlCommand comm = GetCommand("SPTopicsGetByRelated");
			comm.AddParameter("@Tag1", SqlDbType.VarChar, null);
			comm.AddParameter("@Tag2", SqlDbType.VarChar, null);
			comm.AddParameter("@Tag3", SqlDbType.VarChar, null);
			comm.AddParameter("@Tag4", SqlDbType.VarChar, null);
			comm.AddParameter("@Tag5", SqlDbType.VarChar, null);
			comm.AddParameter("@Tag6", SqlDbType.VarChar, null);
			for (int i = 0; i < topic.Tags.Count; i++)
			{
				comm.Parameters[i].Value = topic.Tags[i];
			}
			comm.AddParameter("@TopicId", SqlDbType.Int, topic.Id);
			comm.AddParameter("@Amount", SqlDbType.Int, amount);
			DataTable dt = this.GetTable(comm);
			foreach (DataRow dr in dt.Rows)
			{
				Topic t = ParseBasicTopicDataRow(dr);
				t.Forum = new Forum();
				t.Forum.Id = dr.Get<int>("ForumId");
				t.Forum.Name = dr.GetString("ForumName");
				t.Forum.ShortName = dr.GetString("ForumShortName");

				list.Add(t);
			}
			return list;
		}

		public Topic ParseBasicTopicDataRow(DataRow dr)
		{
			Topic t = new Topic();
			t.Id = dr.Get<int>("TopicId");
			t.Date = dr.GetDate("TopicCreationDate");
			t.Title = dr.GetString("TopicTitle");
			t.ShortName = dr.GetString("TopicShortName");
			t.Description = dr.GetString("TopicDescription");
			t.Replies = dr.Get<int>("TopicReplies");
			t.Views = dr.Get<int>("TopicViews");
			t.IsClosed = dr.Get<bool>("TopicIsClose");

			return t;
		}

		public void Add(Topic topic, string ip)
		{
			SqlCommand comm = this.GetCommand("SPTopicsInsert");
			comm.AddParameter("@TopicTitle", SqlDbType.VarChar, topic.Title);
			comm.AddParameter("@TopicShortName", SqlDbType.VarChar, topic.ShortName);
			comm.AddParameter("@TopicDescription", SqlDbType.VarChar, topic.Description);
			comm.AddParameter("@UserId", SqlDbType.Int, topic.User.Id);
			comm.AddParameter("@TopicTags", SqlDbType.VarChar, topic.Tags.ToString());
			comm.AddParameter("@Forum", SqlDbType.VarChar, topic.Forum.ShortName);
			comm.AddParameter("@Ip", SqlDbType.VarChar, ip);

			SqlParameter idParameter = comm.AddParameter("@TopicId", SqlDbType.Int, null);
			idParameter.Direction = ParameterDirection.Output;

			this.SafeExecuteNonQuery(comm);
			if (idParameter.Value == null)
			{
				throw new DataException("No value for the output parameter: " + idParameter.ParameterName);
			}
			if (idParameter.Value != DBNull.Value)
			{
				topic.Id = Convert.ToInt32(idParameter.Value);
			}
		}

		public void Edit(Topic topic, string ip)
		{
			SqlCommand comm = this.GetCommand("SPTopicsUpdate");
			comm.AddParameter("@TopicId", SqlDbType.Int, topic.Id);
			comm.AddParameter("@TopicTitle", SqlDbType.VarChar, topic.Title);
			comm.AddParameter("@TopicDescription", SqlDbType.VarChar, topic.Description);
			comm.AddParameter("@UserId", SqlDbType.Int, topic.User.Id);
			comm.AddParameter("@TopicTags", SqlDbType.VarChar, topic.Tags.ToString());
			comm.AddParameter("@Ip", SqlDbType.VarChar, ip);

			this.SafeExecuteNonQuery(comm);
		}

		public void AddVisit(int topicId)
		{
			SqlCommand comm = this.GetCommand("SPTopicsAddVisit");
			comm.AddParameter("@TopicId", SqlDbType.Int, topicId);

			this.SafeExecuteNonQuery(comm);
		}
	}
}
