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
		/// <summary>
		/// Gets a list of ForumCategories with the list forums.
		/// </summary>
		/// <returns></returns>
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

		/// <summary>
		/// Get all categories (without the forums in it).
		/// </summary>
		/// <returns></returns>
		public List<ForumCategory> GetCategories()
		{
			DbCommand comm = GetCommand("SPForumsCategoriesGetAll");
			DataTable dt = GetTable(comm);

			List<ForumCategory> categoryList = new List<ForumCategory>();
			foreach (DataRow dr in dt.Rows)
			{
				ForumCategory category = new ForumCategory(dr.Get<int>("CategoryId"), dr.GetString("CategoryName"));
				category.Forums = new List<Forum>();
				categoryList.Add(category);
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
			comm.AddParameter(this.Factory, "ReadAccessGroupId", DbType.Int16, f.ReadAccessRole);
			comm.AddParameter(this.Factory, "PostAccessGroupId", DbType.Int16, f.PostAccessRole);

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
				forum.ReadAccessRole = dr.GetNullable<UserRole?>("ReadAccessGroupId");
				forum.PostAccessRole = dr.Get<UserRole>("PostAccessGroupId");
			}

			return forum;
		}

		/// <summary>
		/// Updates the forum
		/// </summary>
		/// <param name="forum"></param>
		/// <param name="userId">User that is updating the forum</param>
		public void Edit(Forum f, int userId)
		{
			DbCommand comm = this.GetCommand("SPForumsUpdate");
			comm.AddParameter(this.Factory, "ForumShortName", DbType.String, f.ShortName);
			comm.AddParameter(this.Factory, "ForumName", DbType.String, f.Name);
			comm.AddParameter(this.Factory, "ForumDescription", DbType.String, f.Description);
			comm.AddParameter(this.Factory, "CategoryId", DbType.String, f.Category.Id);
			comm.AddParameter(this.Factory, "UserId", DbType.Int32, userId);
			comm.AddParameter(this.Factory, "ReadAccessGroupId", DbType.Int16, f.ReadAccessRole);
			comm.AddParameter(this.Factory, "PostAccessGroupId", DbType.Int16, f.PostAccessRole);

			comm.SafeExecuteNonQuery();
		}

		/// <summary>
		/// Gets an available shortname from the database.
		/// </summary>
		public string GetAvailableShortName(string shortName)
		{
			//TODO: Make it recursive for large and repititive names
			if (shortName == null)
			{
				throw new ArgumentNullException("shortName");
			}
			#region SearchShortName format
			//search for used shortnames: Could be something like "general", "general_1", "general_2", "general_3"
			string searchShortName = shortName;
			if (searchShortName.Length > 30)
			{
				searchShortName = searchShortName.Substring(0, 30);
			}
			searchShortName += "_";  
			#endregion

			DbCommand comm = this.GetCommand("SPForumsGetUsedShortNames");
			comm.AddParameter(this.Factory, "ForumShortName", DbType.String, shortName);
			comm.AddParameter(this.Factory, "SearchShortName", DbType.String, searchShortName);

			DataTable dt = this.GetTable(comm);
			#region Find the highest number
			int? number = null;
			if (dt.Rows.Count > 0)
			{
				number = dt.Rows.Count;
			}

			#endregion

			if (number == null)
			{
				return shortName;
			}
			else
			{
				number++;
				return searchShortName + number.Value.ToString();
			}
		}

		public bool Delete(string forum)
		{
			DbCommand comm = this.GetCommand("SPForumsDelete");
			comm.AddParameter(this.Factory, "ForumShortName", DbType.String, forum);

			var result = comm.SafeExecuteNonQuery();
			return result > 0;
		}
	}
}
