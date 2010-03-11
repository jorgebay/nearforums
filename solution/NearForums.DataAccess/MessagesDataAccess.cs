using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using NearForums.DataAccess;

namespace NearForums.DataAccess
{
	public class MessagesDataAccess : BaseDataAccess
	{
		public List<Message> GetByTopic(int topicId)
		{
			List<Message> list = new List<Message>();
			SqlCommand comm = this.GetCommand("SPMessagesGetByTopic");
			comm.AddParameter("@TopicId", SqlDbType.Int, topicId);

			DataTable dt = this.GetTable(comm);
			foreach (DataRow dr in dt.Rows)
			{
				Message m = this.ParseBasicMessageRow(dr, 0);

				list.Add(m);
			}

			return list;
		}

		/// <summary>
		/// Gets top latest message of a topic
		/// </summary>
		/// <param name="topicId"></param>
		/// <returns></returns>
		public List<Message> GetByTopicLatest(int topicId)
		{
			List<Message> list = new List<Message>();
			SqlCommand comm = this.GetCommand("SPMessagesGetByTopicLatest");
			comm.AddParameter("@TopicId", SqlDbType.Int, topicId);

			DataTable dt = this.GetTable(comm);
			foreach (DataRow dr in dt.Rows)
			{
				Message m = this.ParseBasicMessageRow(dr, 0);

				list.Add(m);
			}

			return list;
		}

		protected virtual Message ParseBasicMessageRow(DataRow dr, int initIndex)
		{
			Message m = new Message();
			m.Id = dr.Get<int>("MessageId");
			m.Body = dr.GetString("MessageBody");
			m.Date = dr.GetDate("MessageCreationDate");
			m.User = new User(dr.Get<int>("UserId"), dr.GetString("UserName"));
			m.User.Signature = dr.GetNullableString("UserSignature");
			m.User.Group = dr.Get<UserGroup>("UserGroupId");
			m.User.GroupName = dr.GetString("UserGroupName");

			return m;
		}

		public List<Message> GetByTopic(int topicId, int firstMsg, int lastMsg, int initIndex)
		{
			List<Message> list = new List<Message>();
			SqlCommand comm = this.GetCommand("SPMessagesGetByTopicUpTo");
			comm.AddParameter("@TopicId", SqlDbType.Int, topicId);
			comm.AddParameter("@FirstMsg", SqlDbType.Int, firstMsg);
			comm.AddParameter("@LastMsg", SqlDbType.Int, lastMsg);

			DataTable dt = this.GetTable(comm);
			foreach (DataRow dr in dt.Rows)
			{
				Message m = this.ParseBasicMessageRow(dr, initIndex);

				list.Add(m);
			}

			return list;
		}

		public List<Message> GetByTopicFrom(int topicId, int firstMsg, int amount, int initIndex)
		{
			List<Message> list = new List<Message>();
			SqlCommand comm = this.GetCommand("SPMessagesGetByTopicFrom");
			comm.AddParameter("@TopicId", SqlDbType.Int, topicId);
			comm.AddParameter("@FirstMsg", SqlDbType.Int, firstMsg);
			comm.AddParameter("@Amount", SqlDbType.Int, amount);

			DataTable dt = this.GetTable(comm);
			foreach (DataRow dr in dt.Rows)
			{
				Message m = this.ParseBasicMessageRow(dr, initIndex);

				list.Add(m);
			}

			return list;
		}

		public void Add(Message message, string ip)
		{
			SqlCommand comm = this.GetCommand("SPMessagesInsert");
			comm.AddParameter("@TopicId", SqlDbType.Int, message.Topic.Id);
			comm.AddParameter("@MessageBody", SqlDbType.VarChar, message.Body);
			comm.AddParameter("@UserId", SqlDbType.Int, message.User.Id);
			comm.AddParameter("@Ip", SqlDbType.VarChar, ip);

			SqlParameter idParameter = comm.AddParameter("@MessageId", SqlDbType.Int, null);
			idParameter.Direction = ParameterDirection.Output;

			this.SafeExecuteNonQuery(comm);
			if (idParameter.Value == null)
			{
				throw new DataException("No value for the output parameter: " + idParameter.ParameterName);
			}
			if (idParameter.Value != DBNull.Value)
			{
				message.Id = Convert.ToInt32(idParameter.Value);
			}
		}
	}
}
