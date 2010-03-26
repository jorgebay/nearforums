using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;
using NearForums.DataAccess;
using System.Data;

namespace NearForums.DataAccess
{
	public class ForumsDataAccess : BaseDataAccess
	{
		public List<ForumCategory> GetList()
		{
			DbCommand comm = GetCommand("SPForumsGetByCategory");
			DataTable dt = GetTable(comm);

			List<ForumCategory> categoryList = new List<ForumCategory>();
			ForumCategory category = null;
			foreach (DataRow dr in dt.Rows)
			{
				if (category == null || category.Name != dr.GetString("CategoryName"))
				{
					category = new ForumCategory(dr.Get<int>("CategoryId"), dr.GetString("CategoryName"));
					category.Forums = new List<Forum>();
					categoryList.Add(category);
				}
				Forum f = ParseForumDataRow(dr);
				f.Category = category;
				category.Forums.Add(f);
			}

			return categoryList;
		}

		public void Add(Forum f, int userId)
		{
			DbCommand comm = this.GetCommand("SPForumsInsert");
			comm.AddParameter(this.Factory, "ForumName", DbType.String, f.Name);
			comm.AddParameter(this.Factory, "ForumShortName", DbType.String, f.ShortName);
			comm.AddParameter(this.Factory, "ForumDescription", DbType.String, f.Description);
			comm.AddParameter(this.Factory, "CategoryId", DbType.String, f.Category.Id);
			comm.AddParameter(this.Factory, "UserId", DbType.String, userId);

			comm.SafeExecuteNonQuery();
		}

		protected virtual Forum ParseForumDataRow(DataRow dr)
		{
			Forum f = new Forum();
			f.Name = dr.GetString("ForumName");
			f.Description = dr.GetString("ForumDescription");
			f.ShortName = dr.GetString("ForumShortName");
			f.Id = dr.Get<int>("ForumId");
			f.TopicCount = dr.Get<int>("ForumTopicCount");
			f.MessageCount = dr.Get<int>("ForumMessageCount");

			return f;
		}

		public Forum GetByShortName(string shortName)
		{
			Forum forum = null;
			DbCommand comm = GetCommand("SPForumsGetByShortName");
			comm.AddParameter(this.Factory, "ShortName", DbType.String, shortName);
			DataRow dr = this.GetFirstRow(comm);
			if (dr != null)
			{
				forum = this.ParseForumDataRow(dr);
				forum.Category = new ForumCategory(dr.Get<int>("CategoryId"), dr.GetString("CategoryName"));
			}

			return forum;
		}
	}
}
