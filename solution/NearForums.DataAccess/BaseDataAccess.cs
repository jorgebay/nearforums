using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Data.Common;

namespace NearForums.DataAccess
{
	public class BaseDataAccess
	{
		/// <summary>
		/// Gets a new connection.
		/// </summary>
		/// <returns></returns>
		protected SqlConnection GetConnection()
		{
			if (ConfigurationManager.ConnectionStrings["Forums"] == null)
			{
				throw new ConfigurationErrorsException("You must specify a SQL Connection string in the configuration, with the key 'Forums'.");
			}
			SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Forums"].ConnectionString);
			return conn;
		}

		/// <summary>
		/// Gets a new command for procedure executing.
		/// </summary>
		/// <param name="procedureName"></param>
		/// <returns></returns>
		protected SqlCommand GetCommand(string procedureName)
		{
			SqlCommand comm = new SqlCommand(procedureName, GetConnection());
			comm.CommandType = CommandType.StoredProcedure;
			return comm;
		}

		protected DataTable GetTable(SqlCommand command)
		{
			DataTable dt = new DataTable();
			SqlDataAdapter da = new SqlDataAdapter(command);
			da.Fill(dt);

			return dt;
		}

		protected DataRow GetFirstRow(SqlCommand command)
		{
			DataRow dr = null;
			DataTable dt = GetTable(command);
			if (dt.Rows.Count > 0)
			{
				dr = dt.Rows[0];
			}
			return dr;
		}

		/// <summary>
		/// Disposes the reader.
		/// </summary>
		/// <param name="reader"></param>
		protected void SafeDispose(SqlDataReader reader)
		{
			if (reader != null)
			{
				reader.Dispose();
			}
		}

		/// <summary>
		/// Opens the connection, executes and closes the connection
		/// </summary>
		/// <param name="comm"></param>
		/// <returns></returns>
		protected int SafeExecuteNonQuery(DbCommand comm)
		{
			int rowsAffected = 0;
			try
			{
				comm.Connection.Open();
				rowsAffected = comm.ExecuteNonQuery();
			}
			finally
			{
				comm.Connection.Close();
			}
			return rowsAffected;
		}
	}
}
