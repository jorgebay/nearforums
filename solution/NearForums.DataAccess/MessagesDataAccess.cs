﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;
using System.Data;
using NearForums.DataAccess;

namespace NearForums.DataAccess
{
	public class MessagesDataAccess : BaseDataAccess
	{
		public List<Message> GetByTopic(int topicId)
		{
			List<Message> list = new List<Message>();
			DbCommand comm = this.GetCommand("SPMessagesGetByTopic");
			comm.AddParameter(this.Factory, "TopicId", DbType.Int32, topicId);

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
			DbCommand comm = this.GetCommand("SPMessagesGetByTopicLatest");
			comm.AddParameter(this.Factory, "TopicId", DbType.Int32, topicId);

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
			m.Topic = new Topic(dr.Get<int>("TopicId"));
			m.Active = dr.Get<bool>("Active");

			return m;
		}

		public List<Message> GetByTopic(int topicId, int firstMsg, int lastMsg, int initIndex)
		{
			List<Message> list = new List<Message>();
			DbCommand comm = this.GetCommand("SPMessagesGetByTopicUpTo");
			comm.AddParameter(this.Factory, "TopicId", DbType.Int32, topicId);
			comm.AddParameter(this.Factory, "FirstMsg", DbType.Int32, firstMsg);
			comm.AddParameter(this.Factory, "LastMsg", DbType.Int32, lastMsg);

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
			DbCommand comm = this.GetCommand("SPMessagesGetByTopicFrom");
			comm.AddParameter(this.Factory, "TopicId", DbType.Int32, topicId);
			comm.AddParameter(this.Factory, "FirstMsg", DbType.Int32, firstMsg);
			comm.AddParameter(this.Factory, "Amount", DbType.Int32, amount);

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
			DbCommand comm = this.GetCommand("SPMessagesInsert");
			comm.AddParameter(this.Factory, "TopicId", DbType.Int32, message.Topic.Id);
			comm.AddParameter(this.Factory, "MessageBody", DbType.String, message.Body);
			comm.AddParameter(this.Factory, "UserId", DbType.Int32, message.User.Id);
			comm.AddParameter(this.Factory, "Ip", DbType.String, ip);

			DbParameter idParameter = comm.AddParameter(this.Factory, "MessageId", DbType.Int32, null);
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

		public void Delete(int messageId, int userId)
		{
			DbCommand comm = this.GetCommand("SPMessagesDelete");
			comm.AddParameter<int>(this.Factory, "MessageId", messageId);
			comm.AddParameter<int>(this.Factory, "UserId", userId);

			comm.SafeExecuteNonQuery();
		}
	}
}