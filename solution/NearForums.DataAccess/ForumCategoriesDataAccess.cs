using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;

namespace NearForums.DataAccess
{
	public class ForumCategoriesDataAccess : BaseDataAccess, IForumCategoriesDataAccess
	{
		public List<ForumCategory> GetAll()
		{
			var list = new List<ForumCategory>();
			DbCommand comm = this.GetCommand("SPForumsCategoriesGetAll");

			DataTable dt = this.GetTable(comm);
			foreach (DataRow dr in dt.Rows)
			{

				ForumCategory category = this.ParseBasicPageContentRow(dr);

				list.Add(category);
			}
			return list;
		}

		public ForumCategory Get(int id)
		{
			ForumCategory category = null;
			DbCommand comm = this.GetCommand("SPForumsCategoriesGet");
			comm.AddParameter<int>(this.Factory, "CategoryId", id);

			DataTable dt = this.GetTable(comm);
			if (dt.Rows.Count > 0)
			{
				category = this.ParseBasicPageContentRow(dt.Rows[0]);
			}
			return category;
		}

		protected virtual ForumCategory ParseBasicPageContentRow(DataRow dr)
		{
			var category = new ForumCategory()
			{
				Id = dr.Get<int>("CategoryId"),
				Name = dr.GetString("CategoryName"),
				Order = dr.Get<int>("CategoryOrder")
			};
			return category;
		}


		public void Add(ForumCategory category)
		{
			DbCommand comm = this.GetCommand("SPForumsCategoriesInsert");
			comm.AddParameter<string>(this.Factory, "CategoryName", category.Name);
			comm.AddParameter<int>(this.Factory, "CategoryOrder", category.Order);

			comm.SafeExecuteNonQuery();
		}


		public void Edit(ForumCategory category)
		{
			DbCommand comm = this.GetCommand("SPForumsCategoriesUpdate");
			comm.AddParameter<int>(this.Factory, "CategoryId", category.Id);
			comm.AddParameter<string>(this.Factory, "CategoryName", category.Name);
			comm.AddParameter<int>(this.Factory, "CategoryOrder", category.Order);

			comm.SafeExecuteNonQuery();
		}

		public bool Delete(int id)
		{
			DbCommand comm = this.GetCommand("SPForumsCategoriesDelete");
			comm.AddParameter<int>(this.Factory, "CategoryId", id);

			return comm.SafeExecuteNonQuery() > 0;
		}

		public int GetForumCount(int id)
		{
			DbCommand comm = this.GetCommand("SPForumsCategoriesGetForumsCountPerCategory");
			comm.AddParameter<int>(this.Factory, "CategoryId", id);
			
			//Get the first column of the first row
			DataRow dtr1 = this.GetFirstRow(comm);
			return Convert.ToInt32(dtr1[0]);
		}
	}
}
