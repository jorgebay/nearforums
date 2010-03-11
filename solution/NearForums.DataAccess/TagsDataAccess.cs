using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace NearForums.DataAccess
{
	public class TagsDataAccess : BaseDataAccess
	{
		public List<WeightTag> GetMostViewed(int forumId, int top)
		{
			List<WeightTag> list = new List<WeightTag>();
			SqlCommand comm = GetCommand("SPTagsGetMostViewed");
			comm.AddParameter("@ForumId", SqlDbType.Int, forumId);
			comm.AddParameter("@Top", SqlDbType.BigInt, top);
			DataTable dt = this.GetTable(comm);
			foreach (DataRow dr in dt.Rows)
			{
				list.Add(new WeightTag(dr.GetString("Tag"), dr.Get<decimal>("Weight")));
			}
			return list;
		}
	}
}
