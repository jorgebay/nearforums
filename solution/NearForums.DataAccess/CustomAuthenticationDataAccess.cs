using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.Common;
using System.Configuration;

namespace NearForums.DataAccess
{
	/// <summary>
	/// Represents a set of method to access the custom authentication providers database.
	/// </summary>
	public class CustomAuthenticationDataAccess : BaseDataAccess, ICustomAuthenticationDataAccess
	{
		private ConnectionStringSettings _connectionString;
		/// <summary>
		/// Gets the forums connection string
		/// </summary>
		protected override ConnectionStringSettings ConnectionString
		{
			get
			{
				if (!Config.AuthenticationProviders.CustomDb.IsDefined)
				{
					throw new ConfigurationErrorsException("Custom Authentication Provider is not defined in the site configuration.");
				}
				if (_connectionString == null)
				{
					var conn = Config.AuthenticationProviders.CustomDb.ConnectionString;
					_connectionString = EnsureProvider(conn);
				}
				return _connectionString;
			}
		}

		public User GetUser(string userName, string password)
		{
			User user = null;
			DbCommand comm = GetCommand(Config.AuthenticationProviders.CustomDb.StoredProcedure);
			comm.AddParameter<string>(this.Factory, "username", userName);
			comm.AddParameter<string>(this.Factory, "password", password);

			var dr = GetFirstRow(comm);
			if (dr != null)
			{
				user = new User();
				user.Id = dr.Get<int>("userid");
				user.UserName = dr.GetString("username");
				user.Email = dr.GetString("useremail");
			}
			return user;
		}
	}
}
