using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;

namespace NearForums.DataAccess
{
	public static class AdoExtensions
	{
		public static SqlParameter AddParameter(this SqlCommand comm, string parameterName, SqlDbType type, object value)
		{
			SqlParameter param = comm.Parameters.Add(new SqlParameter(parameterName, type));
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

			return param;
		}

		public static string GetNullableString(this SqlDataReader reader, string columnName)
		{
			object value = reader[columnName];
			if (value == DBNull.Value)
			{
				return null;
			}
			return value.ToString();
		}

		public static string GetString(this SqlDataReader reader, string columnName)
		{
			object value = reader[columnName];
			return value.ToString();
		}

		public static T GetNullable<T>(this SqlDataReader reader, string columnName)
		{
			object value = reader[columnName];
			if (value == DBNull.Value)
			{
				return default(T);
			}
			return Get<T>(reader, columnName);
		}

		public static T Get<T>(this SqlDataReader reader, string columnName)
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

		public static int SafeExecuteNonQuery(this SqlCommand comm)
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
