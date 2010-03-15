using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using NearForums.DataAccess;
using System.Data.Common;

namespace NearForums.DataAccess
{
	public class TemplatesDataAccess : BaseDataAccess
	{
		public List<Template> GetAll()
		{
			List<Template> list = new List<Template>();
			DbCommand comm = this.GetCommand("SPTemplatesGetAll");

			DataTable dt = this.GetTable(comm);
			foreach (DataRow dr in dt.Rows)
			{
				Template t = ParseTemplateDataRow(dr);
				t.IsCurrent = dr.Get<bool>("TemplateIsCurrent");
				list.Add(t);
			}

			return list;
		}

		public Template GetCurrent()
		{
			Template t = new Template();
			DbCommand comm = this.GetCommand("SPTemplatesGetCurrent");

			DataRow dr = this.GetFirstRow(comm);
			if (dr != null)
			{
				t = ParseTemplateDataRow(dr);
			}

			return t;
		}

		public Template Get(int id)
		{
			Template t = new Template();
			DbCommand comm = this.GetCommand("SPTemplatesGet");
			comm.AddParameter(this.Factory, "TemplateId", DbType.Int32, id);

			DataRow dr = this.GetFirstRow(comm);
			if (dr != null)
			{
				t = ParseTemplateDataRow(dr);
			}

			return t;
		}

		/// <summary>
		/// Sets the template as THE current one.
		/// </summary>
		public void SetCurrent(int id)
		{
			DbCommand comm = this.GetCommand("SPTemplatesUpdateCurrent");
			comm.AddParameter(this.Factory, "TemplateId", DbType.Int32, id);

			this.SafeExecuteNonQuery(comm);
		}

		private Template ParseTemplateDataRow(DataRow dr)
		{
			Template t = new Template();
			t.Id = dr.Get<int>("TemplateId");
			t.Key = dr.GetString("TemplateKey");
			t.Description = dr.GetString("TemplateDescription");
			return t;
		}

		public void Add(Template t)
		{
			DbCommand comm = this.GetCommand("SPTemplatesInsert");
			comm.AddParameter(this.Factory, "TemplateKey", DbType.String, t.Key);
			comm.AddParameter(this.Factory, "TemplateDescription", DbType.String, t.Description);

			DbParameter idParameter = comm.AddParameter(this.Factory, "TemplateId", DbType.Int32, null);
			idParameter.Direction = ParameterDirection.Output;

			this.SafeExecuteNonQuery(comm);


			if (idParameter.Value == null)
			{
				throw new DataException("No value for the output parameter: " + idParameter.ParameterName);
			}
			if (idParameter.Value != DBNull.Value)
			{
				t.Id = Convert.ToInt32(idParameter.Value);
			}
		}

		public void Delete(int id)
		{
			DbCommand comm = this.GetCommand("SPTemplatesDelete");
			comm.AddParameter(this.Factory, "TemplateId", DbType.Int32, id);
			this.SafeExecuteNonQuery(comm);
		}
	}
}
