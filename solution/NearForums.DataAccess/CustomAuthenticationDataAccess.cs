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
		public CustomAuthenticationDataAccess()
		{
		}

		private DbProviderFactory _factory;
		/// <summary>
		/// Gets an instance of the db provider factory for the custom db authentication
		/// </summary>
		public override DbProviderFactory Factory
		{
			get
			{
				if (!Config.AuthenticationProviders.CustomDb.IsDefined)
				{
					throw new ConfigurationErrorsException("Custom Authentication Provider is not defined in the site configuration.");
				}
				if (_factory == null)
				{
					_factory = DbProviderFactories.GetFactory(Config.AuthenticationProviders.CustomDb.ConnectionString.ProviderName);
				}
				return _factory;
			}
			set
			{
				_factory = value;
			}
		}

		public override DbConnection GetConnection()
		{
			var conn = this.Factory.CreateConnection();
			conn.ConnectionString = Config.AuthenticationProviders.CustomDb.ConnectionString.ConnectionString;
			return conn;
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
