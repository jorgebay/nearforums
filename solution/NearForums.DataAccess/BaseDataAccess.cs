using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;
using System.Data;
using System.Configuration;
using NearForums.Configuration;

namespace NearForums.DataAccess
{
	/// <summary>
	/// Represents a set of methods to get data from the db and convert into app entities
	/// </summary>
	public abstract class BaseDataAccess
	{
		/// <summary>
		/// Current configuration
		/// </summary>
		protected virtual SiteConfiguration Config
		{
			get
			{
				return SiteConfiguration.Current;
			}
		}

		public BaseDataAccess()
		{
			//Should be left empty
		}

		/// <summary>
		/// Gets a new connection.
		/// </summary>
		/// <returns></returns>
		public virtual DbConnection GetConnection()
		{
			DbConnection conn = this.Factory.CreateConnection();
			conn.ConnectionString = Config.DataAccess.ConnectionString.ConnectionString;
			return conn;
		}

		private DbProviderFactory _factory;
		/// <summary>
		/// The database provider factory to create the connections and commands to access the db.
		/// </summary>
		public virtual DbProviderFactory Factory
		{
			get
			{
				if (_factory == null)
				{
					_factory = DbProviderFactories.GetFactory(Config.DataAccess.ConnectionString.ProviderName);
				}
				return _factory;
			}
			set
			{
				_factory = value;
			}
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
			var dt = new DataTable();
			var da = this.Factory.CreateDataAdapter();
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
