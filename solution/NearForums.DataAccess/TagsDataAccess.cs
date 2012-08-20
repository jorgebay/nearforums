using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.Common;

namespace NearForums.DataAccess
{
	public class TagsDataAccess : BaseDataAccess, ITagsDataAccess
	{
		public List<WeightTag> GetMostViewed(int forumId, int top)
		{
			List<WeightTag> list = new List<WeightTag>();
			DbCommand comm = GetCommand("SPTagsGetMostViewed");
			comm.AddParameter(this.Factory, "ForumId", DbType.Int32, forumId);
			comm.AddParameter(this.Factory, "Top", DbType.Int64, top);
			DataTable dt = this.GetTable(comm);
			foreach (DataRow dr in dt.Rows)
			{
				list.Add(new WeightTag(dr.GetString("Tag"), dr.Get<decimal>("Weight")));
			}
			return list;
		}
	}
}
