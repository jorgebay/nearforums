using System;
using System.Configuration;
using System.Data;
using System.Data.Common;
using NearForums.Configuration;

namespace NearForums.DataAccess
{
	/// <summary>
	/// Represents a set of methods to get data from the db and convert into app entities
	/// </summary>
	public abstract class BaseDataAccess
	{
		private ConnectionStringSettings _connectionString;
		private DbProviderFactory _factory;

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
		/// <summary>
		/// Gets the forums connection string
		/// </summary>
		protected virtual ConnectionStringSettings ConnectionString
		{
			get
			{
				if (_connectionString == null)
				{
					var conn = Config.DataAccess.ConnectionString;
					conn = EnsureProvider(conn);
					_connectionString = conn;
				}
				return _connectionString;
			}
		}

		/// <summary>
		/// Ensures that the connection strings contains a provider
		/// </summary>
		/// <param name="conn"></param>
		/// <returns></returns>
		protected ConnectionStringSettings EnsureProvider(ConnectionStringSettings conn)
		{
			if (String.IsNullOrEmpty(conn.ProviderName))
			{
				//Fallback to default provider: sql server
				conn = new ConnectionStringSettings(conn.Name, conn.ConnectionString, "System.Data.SqlClient");
			}
			return conn;
		}

		/// <summary>
		/// The database provider factory to create the connections and commands to access the db.
		/// </summary>
		public virtual DbProviderFactory Factory
		{
			get
			{
				if (_factory == null)
				{
					_factory = DbProviderFactories.GetFactory(ConnectionString.ProviderName);
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
			var comm = this.Factory.CreateCommand();
			comm.Connection = GetConnection();
			comm.CommandText = procedureName;
			comm.CommandType = CommandType.StoredProcedure;
			return comm;
		}

		/// <summary>
		/// Gets a new connection.
		/// </summary>
		/// <returns></returns>
		public virtual DbConnection GetConnection()
		{
			var conn = Factory.CreateConnection();
			conn.ConnectionString = ConnectionString.ConnectionString;
			return conn;
		}

		/// <summary>
		/// Gets a datatable filled with the first result of executing the command.
		/// </summary>
		protected DataRow GetFirstRow(DbCommand command)
		{
			DataRow dr = null;
			var dt = GetTable(command);
			if (dt.Rows.Count > 0)
			{
				dr = dt.Rows[0];
			}
			return dr;
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
