using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;
using System.Data;
using System.Configuration;

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
			//Default provider
			var providerName = "System.Data.SqlClient";
			if (!String.IsNullOrEmpty(ConfigurationManager.ConnectionStrings[_connectionKey].ProviderName))
			{
				providerName = ConfigurationManager.ConnectionStrings[_connectionKey].ProviderName;
			}
			this.Factory = DbProviderFactories.GetFactory(providerName);
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

		/// <summary>
		/// Gets a datatable filled with the results of executing the command.
		/// </summary>
		protected DataTable GetTable(DbCommand command)
		{
			DataTable dt = new DataTable();
			DbDataAdapter da = this.Factory.CreateDataAdapter();
			da.SelectCommand = command;
			da.Fill(dt);

			return dt;
		}

		/// <summary>
		/// Gets a datatable filled with the first result of executing the command.
		/// </summary>
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
		/// Safely opens the connection, executes and closes the connection
		/// </summary>
		/// <param name="comm"></param>
		/// <returns></returns>
		protected int SafeExecuteNonQuery(DbCommand comm)
		{
			return comm.SafeExecuteNonQuery();
		}
	}
}
