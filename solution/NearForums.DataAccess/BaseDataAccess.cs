using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;
using System.Data;
using System.Configuration;
using System.Data.Common;

namespace NearForums.DataAccess
{
	public class BaseDataAccess
	{
		protected const string _connectionKey = "Forums";

		protected BaseDataAccess()
		{
			if (ConfigurationManager.ConnectionStrings[_connectionKey] == null)
			{
				throw new ConfigurationErrorsException("You must specify a SQL Connection string in the configuration, with the key 'Forums'.");
			}
			this.Factory = DbProviderFactories.GetFactory(ConfigurationManager.ConnectionStrings[_connectionKey].ProviderName);
		}

		/// <summary>
		/// Gets a new connection.
		/// </summary>
		/// <returns></returns>
		protected DbConnection GetConnection()
		{
			DbConnection conn = this.Factory.CreateConnection();
			conn.ConnectionString = ConfigurationManager.ConnectionStrings[_connectionKey].ConnectionString;
			return conn;
		}


		protected DbProviderFactory Factory
		{
			get;
			private set;
		}

		/// <summary>
		/// Gets a new command for procedure executing.
		/// </summary>
		/// <param name="procedureName"></param>
		/// <returns></returns>
		protected DbCommand GetCommand(string procedureName)
		{
			DbCommand comm = this.Factory.CreateCommand();
			comm.Connection = GetConnection();
			comm.CommandText = procedureName;
			comm.CommandType = CommandType.StoredProcedure;
			return comm;
		}

		protected DataTable GetTable(DbCommand command)
		{
			DataTable dt = new DataTable();
			DbDataAdapter da = this.Factory.CreateDataAdapter();
			da.SelectCommand = command;
			da.Fill(dt);

			return dt;
		}

		protected DataRow GetFirstRow(DbCommand command)
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
		protected void SafeDispose(DbDataReader reader)
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
