using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;
using System.Data;
using System.Data.SqlClient;
using NearForums.Configuration;

namespace NearForums.DataAccess
{
	public static class AdoExtensions
	{
		public static DbParameter AddParameter(this DbCommand comm, DbProviderFactory factory, string parameterName, DbType type, object value)
		{
			if (parameterName == null)
			{
				throw new ArgumentNullException("parameterName");
			}
			if (parameterName.StartsWith("@") || parameterName.StartsWith(":") || parameterName.StartsWith("?"))
			{
				throw new ArgumentException("Do not include prefix in parameter name.");
			}
			DbParameter param = factory.CreateParameter();
			param.DbType = type;
			param.ParameterName = SiteConfiguration.Current.DataAccess.ParameterPrefix + parameterName;
			if (value == null)
			{
				param.Value = DBNull.Value;
			}
			else if (value is string && Convert.ToString(value) == "")
			{
				param.Value = DBNull.Value;
			}
			else
			{
				param.Value = value;
			}

			comm.Parameters.Add(param);
			return param;
		}

		public static DbParameter AddParameter<T>(this DbCommand comm, DbProviderFactory factory, string parameterName, T value)
		{
			Type type = typeof(T);
			DbType dbType;
			switch (type.FullName)
			{
				case "System.String":
					dbType = DbType.String;
					break;
				case "System.Int32":
					dbType = DbType.Int32;
					break;
				case "System.DateTime":
					dbType = DbType.DateTime;
					break;
				case "System.Int64":
					dbType = DbType.Int64;
					break;
				case "System.Int16":
					dbType = DbType.Int16;
					break;
				case "System.Decimal":
					dbType = DbType.Decimal;
					break;
				case "System.Double":
					dbType = DbType.Double;
					break;
				case "System.Boolean":
					dbType = DbType.Boolean;
					break;
				default:
					throw new System.Data.DataException("Type not supported for implicit DbType mapping.");
			}
			return AddParameter(comm, factory, parameterName, dbType, value);
		}

		public static string GetNullableString(this DbDataReader reader, string columnName)
		{
			object value = reader[columnName];
			if (value == DBNull.Value)
			{
				return null;
			}
			return value.ToString();
		}

		public static string GetString(this DbDataReader reader, string columnName)
		{
			object value = reader[columnName];
			return value.ToString();
		}

		public static T GetNullable<T>(this DbDataReader reader, string columnName)
		{
			object value = reader[columnName];
			if (value == DBNull.Value)
			{
				return default(T);
			}
			return Get<T>(reader, columnName);
		}

		public static T Get<T>(this DbDataReader reader, string columnName)
		{
			try
			{
				return (T)reader[columnName];
			}
			catch (InvalidCastException ex)
			{
				throw new InvalidCastException("Specified cast is not valid, field: " + columnName, ex);
			}
		}

		public static string GetNullableString(this DataRow dr, string columnName)
		{
			object value = dr[columnName];
			if (value == DBNull.Value)
			{
				return null;
			}
			return value.ToString();
		}

		public static string GetString(this DataRow dr, string columnName)
		{
			object value = dr[columnName];
			return value.ToString();
		}

		public static T GetNullable<T>(this DataRow dr, string columnName)
		{
			object value = dr[columnName];
			if (value == DBNull.Value)
			{
				return default(T);
			}
			return Get<T>(dr, columnName);
		}

		/// <summary>
		/// Gets the date in UTC Kind
		/// </summary>
		/// <param name="dr"></param>
		/// <param name="columnName"></param>
		/// <returns></returns>
		public static DateTime GetDate(this DataRow dr, string columnName)
		{
			DateTime date = (DateTime)dr[columnName];
			return DateTime.SpecifyKind(date, DateTimeKind.Utc);
		}

		public static T Get<T>(this DataRow dr, string columnName)
		{
			try
			{
				if (dr[columnName] == DBNull.Value)
				{
					throw new NoNullAllowedException("Column " + columnName + " has a null value.");
				}
				else if (typeof(T) == typeof(DateTime))
				{
					throw new ArgumentException("Date time not supported.");
				}
				return (T)dr[columnName];
			}
			catch (InvalidCastException ex)
			{
				throw new InvalidCastException("Specified cast is not valid, field: " + columnName, ex);
			}
		}

		/// <summary>
		/// Safely opens the connection, executes and closes the connection
		/// </summary>
		/// <param name="comm"></param>
		/// <returns></returns>
		public static int SafeExecuteNonQuery(this DbCommand comm)
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
