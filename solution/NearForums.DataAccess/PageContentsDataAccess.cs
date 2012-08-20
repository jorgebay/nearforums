using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;
using System.Data;

namespace NearForums.DataAccess
{
	public class PageContentsDataAccess : BaseDataAccess, IPageContentsDataAccess
	{
		public List<PageContent> GetAll()
		{
			var list = new List<PageContent>();
			DbCommand comm = this.GetCommand("SPPageContentsGetAll");

			DataTable dt = this.GetTable(comm);
			foreach (DataRow dr in dt.Rows)
			{
				PageContent content = this.ParseBasicPageContentRow(dr);

				list.Add(content);
			}
			return list;
		}

		protected virtual PageContent ParseBasicPageContentRow(DataRow dr)
		{
			var content = new PageContent()
			{
				Title = dr.GetString("PageContentTitle")
				, ShortName = dr.GetString("PageContentShortName")
				, Body = dr.GetString("PageContentBody")
			};
			return content;
		}

		public PageContent Get(string name)
		{
			PageContent content = null;
			DbCommand comm = this.GetCommand("SPPageContentsGet");
			comm.AddParameter<string>(this.Factory, "PageContentShortName", name);

			DataTable dt = this.GetTable(comm);
			if (dt.Rows.Count > 0)
			{
				content = this.ParseBasicPageContentRow(dt.Rows[0]);
			}
			return content;
		}

		public void Add(PageContent content)
		{
			DbCommand comm = this.GetCommand("SPPageContentsInsert");
			comm.AddParameter<string>(this.Factory, "PageContentShortName", content.ShortName);
			comm.AddParameter<string>(this.Factory, "PageContentTitle", content.Title);
			comm.AddParameter<string>(this.Factory, "PageContentBody", content.Body);

			comm.SafeExecuteNonQuery();
		}

		public void Edit(PageContent content)
		{
			DbCommand comm = this.GetCommand("SPPageContentsUpdate");
			comm.AddParameter<string>(this.Factory, "PageContentShortName", content.ShortName);
			comm.AddParameter<string>(this.Factory, "PageContentTitle", content.Title);
			comm.AddParameter<string>(this.Factory, "PageContentBody", content.Body);

			comm.SafeExecuteNonQuery();
		}

		public bool Delete(string name)
		{
			DbCommand comm = this.GetCommand("SPPageContentsDelete");
			comm.AddParameter<string>(this.Factory, "PageContentShortName", name);

			return comm.SafeExecuteNonQuery() > 0;
		}

		public string GetAvailableShortName(string shortName)
		{
			if (shortName == null)
			{
				throw new ArgumentNullException("shortName");
			}
			#region SearchShortName format
			//search for used shortnames: Could be something like "general", "general_1", "general_2", "general_3"
			string searchShortName = shortName;
			if (searchShortName.Length > 120)
			{
				searchShortName = searchShortName.Substring(0, 120);
			}
			searchShortName += "_";
			#endregion

			DbCommand comm = this.GetCommand("SPPageContentsGetUsedShortNames");
			comm.AddParameter<string>(this.Factory, "PageContentShortName", shortName);
			comm.AddParameter<string>(this.Factory, "SearchShortName", searchShortName);

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
	}
}
