using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.Common;
using NearForums.DataAccess;

namespace NearForums.DataAccess
{
	public class TopicsDataAccess : BaseDataAccess, ITopicsDataAccess
	{
		public List<Topic> GetByForum(int forumId, int startIndex, int length, UserRole? role)
		{
			DbCommand comm = this.GetCommand("SPTopicsGetByForum");
			comm.AddParameter(this.Factory, "ForumId", DbType.Int32, forumId);
			comm.AddParameter(this.Factory, "StartIndex", DbType.Int32, startIndex);
			comm.AddParameter(this.Factory, "Length", DbType.Int32, length);
			comm.AddParameter(Factory, "UserGroupId", DbType.Int16, (short?) role);

			var list = ParseTopicsForFullList(comm);
			return list;
		}

		public List<Topic> GetByTag(string tag, int forumId, UserRole? role)
		{
			DbCommand comm = this.GetCommand("SPTopicsGetByTag");
			comm.AddParameter<string>(this.Factory, "Tag", tag);
			comm.AddParameter<int>(this.Factory, "ForumId", forumId);
			comm.AddParameter(Factory, "UserGroupId", DbType.Int16, (short?) role);

			var list = ParseTopicsForFullList(comm);
			return list;
		}

		public List<Topic> GetByForumLatest(int forumId, int startIndex, int length, UserRole? role)
		{
			var comm = this.GetCommand("SPTopicsGetByForumLatest");
			comm.AddParameter<int>(Factory, "ForumId", forumId);
			comm.AddParameter<int>(Factory, "StartIndex", startIndex);
			comm.AddParameter<int>(Factory, "Length", length);
			comm.AddParameter(Factory, "UserGroupId", DbType.Int16, (short?) role);

			var list = ParseTopicsForFullList(comm);
			return list;
		}

		public List<Topic> GetUnanswered(int forumId, UserRole? role)
		{
			var comm = this.GetCommand("SPTopicsGetByForumUnanswered");
			comm.AddParameter<int>(Factory, "ForumId", forumId);
			comm.AddParameter(Factory, "UserGroupId", DbType.Int16, (short?) role);

			var list = ParseTopicsForFullList(comm);
			return list;
		}

		public List<Topic> GetLatest()
		{
			var list = new List<Topic>();
			var comm = this.GetCommand("SPTopicsGetLatest");
			comm.AddParameter(Factory, "UserGroupId", DbType.Int16, null);

			DataTable dt = this.GetTable(comm);
			bool parseAccessRights = dt.Columns.IndexOf("ReadAccessGroupId") >= 0;
			foreach (DataRow dr in dt.Rows)
			{
				Topic t = ParseBasicTopicDataRow(dr, parseAccessRights);
				t.User = new User(dr.Get<int>("UserId"), dr.Get<string>("UserName"));

				list.Add(t);
			}
			return list;
		}

		public Topic Get(int id)
		{
			Topic t = null;
			DbCommand comm = GetCommand("SPTopicsGet");
			comm.AddParameter(this.Factory, "TopicId", DbType.Int32, id);
			DataRow dr = this.GetFirstRow(comm);
			if (dr != null)
			{
				t = ParseBasicTopicDataRow(dr, dr.Table.Columns.IndexOf("ReadAccessGroupId") >= 0);
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
			var list = new List<Topic>();
			var comm = GetCommand("SPTopicsGetByRelated");
			comm.AddParameter(Factory, "Tag1", DbType.String, null);
			comm.AddParameter(Factory, "Tag2", DbType.String, null);
			comm.AddParameter(Factory, "Tag3", DbType.String, null);
			comm.AddParameter(Factory, "Tag4", DbType.String, null);
			comm.AddParameter(Factory, "Tag5", DbType.String, null);
			comm.AddParameter(Factory, "Tag6", DbType.String, null);
			for (int i = 0; i < topic.Tags.Count && i < 6; i++)
			{
				comm.Parameters[i].Value = topic.Tags[i];
			}
			comm.AddParameter(Factory, "TopicId", DbType.Int32, topic.Id);
			comm.AddParameter(Factory, "Amount", DbType.Int32, amount);
			comm.AddParameter(Factory, "UserGroupId", DbType.Int16, null);

			DataTable dt = this.GetTable(comm);
			bool parseAccessRights = dt.Columns.IndexOf("ReadAccessGroupId") >= 0;
			foreach (DataRow dr in dt.Rows)
			{
				Topic t = ParseBasicTopicDataRow(dr, parseAccessRights);
				t.Forum = new Forum();
				t.Forum.Id = dr.Get<int>("ForumId");
				t.Forum.Name = dr.GetString("ForumName");
				t.Forum.ShortName = dr.GetString("ForumShortName");

				list.Add(t);
			}
			return list;
		}

		#region Parsing
		public virtual Topic ParseBasicTopicDataRow(DataRow dr, bool parseAccessRights)
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
			t.IsSticky = dr.GetNullable<int?>("TopicOrder") >= 0;
			if (parseAccessRights)
			{
				t.ReadAccessRole = dr.GetNullableStruct<UserRole>("ReadAccessGroupId");
				t.PostAccessRole = dr.Get<UserRole>("PostAccessGroupId");
			}

			return t;
		}

		protected virtual List<Topic> ParseTopicsForFullList(DbCommand comm)
		{
			var list = new List<Topic>();
			DataTable dt = GetTable(comm);
			bool parseAccessRights = dt.Columns.IndexOf("ReadAccessGroupId") >= 0;
			foreach (DataRow dr in dt.Rows)
			{
				Topic t = ParseBasicTopicDataRow(dr, parseAccessRights);
				t.User = new User(dr.Get<int>("UserId"), dr.Get<string>("UserName"));
				if (!dr.IsNull("MessageCreationDate"))
				{
					t.LastMessage = new Message(dr.Get<int>("LastMessageId"), dr.GetDate("MessageCreationDate"));
					t.LastMessage.User = new User(dr.Get<int>("MessageUserId"), dr.GetString("MessageUserName"));
				}
				list.Add(t);
			}
			return list;
		} 
		#endregion

		public void Add(Topic topic, string ip)
		{
			DbCommand comm = this.GetCommand("SPTopicsInsert");
			comm.AddParameter<string>(this.Factory, "TopicTitle", topic.Title);
			comm.AddParameter<string>(this.Factory, "TopicShortName", topic.ShortName);
			comm.AddParameter<string>(this.Factory, "TopicDescription", topic.Description);
			comm.AddParameter<int>(this.Factory, "UserId", topic.User.Id);
			comm.AddParameter<string>(this.Factory, "TopicTags", topic.Tags.ToString());
			comm.AddParameter<string>(this.Factory, "Forum", topic.Forum.ShortName);
			comm.AddParameter(this.Factory, "TopicOrder", DbType.Int32, topic.IsSticky ? 1 : (int?)null);
			comm.AddParameter<string>(this.Factory, "Ip", ip);
			comm.AddParameter(this.Factory, "ReadAccessGroupId", DbType.Int16, topic.ReadAccessRole);
			comm.AddParameter(this.Factory, "PostAccessGroupId", DbType.Int16, topic.PostAccessRole);

			DbParameter idParameter = comm.AddParameter(this.Factory, "TopicId", DbType.Int32, null);
			idParameter.Direction = ParameterDirection.Output;

			this.SafeExecuteNonQuery(comm);
			if (idParameter.Value != DBNull.Value)
			{
				topic.Id = Convert.ToInt32(idParameter.Value);
			}
			else
			{
				throw new DataException("No value for the output parameter: " + idParameter.ParameterName);
			}
		}

		public void Edit(Topic topic, string ip)
		{
			DbCommand comm = this.GetCommand("SPTopicsUpdate");
			comm.AddParameter<int>(this.Factory, "TopicId", topic.Id);
			comm.AddParameter<string>(this.Factory, "TopicTitle", topic.Title);
			comm.AddParameter<string>(this.Factory, "TopicDescription", topic.Description);
			comm.AddParameter<int>(this.Factory, "UserId", topic.User.Id);
			comm.AddParameter<string>(this.Factory, "TopicTags", topic.Tags.ToString());
			comm.AddParameter(this.Factory, "TopicOrder", DbType.Int32, topic.IsSticky ? 1 : (int?) null);
			comm.AddParameter<string>(this.Factory, "Ip", ip);
			comm.AddParameter(this.Factory, "ReadAccessGroupId", DbType.Int16, topic.ReadAccessRole);
			comm.AddParameter(this.Factory, "PostAccessGroupId", DbType.Int16, topic.PostAccessRole);

			this.SafeExecuteNonQuery(comm);
		}

		public void AddVisit(int topicId)
		{
			DbCommand comm = this.GetCommand("SPTopicsAddVisit");
			comm.AddParameter(this.Factory, "TopicId", DbType.Int32, topicId);

			this.SafeExecuteNonQuery(comm);
		}

		public void Move(int id, int forumId, int userId, string ip)
		{
			DbCommand comm = this.GetCommand("SPTopicsMove");
			comm.AddParameter<int>(this.Factory, "TopicId", id);
			comm.AddParameter<int>(this.Factory, "ForumId", forumId);
			comm.AddParameter<int>(this.Factory, "UserId", userId);
			comm.AddParameter<string>(this.Factory, "Ip", ip);

			this.SafeExecuteNonQuery(comm);
		}

		public void Delete(int id, int userId, string ip)
		{
			DbCommand comm = this.GetCommand("SPTopicsDelete");
			comm.AddParameter<int>(this.Factory, "TopicId", id);
			comm.AddParameter<int>(this.Factory, "UserId", userId);
			comm.AddParameter<string>(this.Factory, "Ip", ip);

			this.SafeExecuteNonQuery(comm);
		}

		public void Close(int id, int userId, string ip)
		{
			DbCommand comm = this.GetCommand("SPTopicsClose");
			comm.AddParameter<int>(this.Factory, "TopicId", id);
			comm.AddParameter<int>(this.Factory, "UserId", userId);
			comm.AddParameter<string>(this.Factory, "Ip", ip);

			this.SafeExecuteNonQuery(comm);
		}

		public void Open(int id, int userId, string ip)
		{
			DbCommand comm = this.GetCommand("SPTopicsOpen");
			comm.AddParameter<int>(this.Factory, "TopicId", id);
			comm.AddParameter<int>(this.Factory, "UserId", userId);
			comm.AddParameter<string>(this.Factory, "Ip", ip);

			this.SafeExecuteNonQuery(comm);
		}

		public List<Topic> GetUnanswered()
		{
			List<Topic> list = new List<Topic>();
			DbCommand comm = this.GetCommand("SPTopicsGetUnanswered");

			var dt = GetTable(comm);
			bool parseAccessRights = dt.Columns.IndexOf("ReadAccessGroupId") >= 0;
			foreach (DataRow dr in dt.Rows)
			{
				Topic t = ParseBasicTopicDataRow(dr, parseAccessRights);
				t.User = new User(dr.Get<int>("UserId"), dr.Get<string>("UserName"));
				t.Forum = new Forum();
				t.Forum.Id = dr.Get<int>("ForumId");
				t.Forum.Name = dr.GetString("ForumName");
				t.Forum.ShortName = dr.GetString("ForumShortName");

				list.Add(t);
			}
			return list;
		}

		/// <summary>
		/// Gets a list of topics posted by the user
		/// </summary>
		public List<Topic> GetByUser(int userId, UserRole? role)
		{
			List<Topic> list = new List<Topic>();
			DbCommand comm = this.GetCommand("SPTopicsGetByUser");
			comm.AddParameter<int>(this.Factory, "UserId", userId);
			comm.AddParameter(Factory, "UserGroupId", DbType.Int16, (short?) role);

			var dt = GetTable(comm);
			bool parseAccessRights = dt.Columns.IndexOf("ReadAccessGroupId") >= 0;
			foreach (DataRow dr in dt.Rows)
			{
				Topic t = ParseBasicTopicDataRow(dr, parseAccessRights);
				list.Add(t);
			}
			return list;
		}

		/// <summary>
		/// Gets the messages posted by the user grouped by topic
		/// </summary>
		public List<Topic> GetTopicsAndMessagesByUser(int userId)
		{
			List<Topic> list = new List<Topic>();
			DbCommand comm = this.GetCommand("SPTopicsGetMessagesByUser");
			comm.AddParameter<int>(this.Factory, "UserId", userId);

			var dt = GetTable(comm);
			bool parseAccessRights = dt.Columns.IndexOf("ReadAccessGroupId") >= 0;
			Topic t = null;
			foreach (DataRow dr in dt.Rows)
			{
				if (t == null || t.Id != Convert.ToInt32(dr["TopicId"]))
				{
					t = ParseBasicTopicDataRow(dr, parseAccessRights);
					list.Add(t);
				}
				t.Messages.Add(new Message(dr.Get<int>("MessageId"), dr.GetDate("MessageCreationDate")));
			}
			return list;
		}
	}
}
