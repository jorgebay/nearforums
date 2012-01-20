using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	/// <summary>
	/// Represents a configuration element for a custom Authorization Provider.
	/// </summary>
	public class CustomAuthenticationProviderElement : ConfigurationElement, IOptionalElement
	{
		#region Connection string
		/// <summary>
		/// Gets and sets the name of the connection string of the db.
		/// </summary>
		[ConfigurationProperty("connectionStringName", IsRequired=true)]
		public string ConnectionStringName
		{
			get
			{
				return (string)this["connectionStringName"];
			}
			set
			{
				this["connectionStringName"] = value;
			}
		}

		private ConnectionStringSettings _connectionString;
		public ConnectionStringSettings ConnectionString
		{
			get
			{
				if (_connectionString == null)
				{
					//Default provider
					var providerName = "System.Data.SqlClient";
					ConnectionStringSettings conn = ConfigurationManager.ConnectionStrings[ConnectionStringName];

					if (conn == null)
					{
						throw new ConfigurationErrorsException("A connection string with the name '" + ConnectionStringName + "' was not found in the web configuration file.");
					}

					if (!String.IsNullOrEmpty(conn.ProviderName))
					{
						providerName = conn.ProviderName;
					}
					_connectionString = new ConnectionStringSettings(ConnectionStringName, conn.ConnectionString, providerName);
				}
				return _connectionString;
			}
		} 
		#endregion

		/// <summary>
		/// Gets / sets the name stored procedure string of the custom authorization provider.
		/// </summary>
		[ConfigurationProperty("storedProcedure", IsRequired = true)]
		public string StoredProcedure
		{
			get
			{
				return (string)this["storedProcedure"];
			}
			set
			{
				this["storedProcedure"] = value;
			}
		}

		/// <summary>
		/// Gets / sets the url to create a new account.
		/// </summary>
		[ConfigurationProperty("registerUrl", IsRequired = true)]
		public string RegisterUrl
		{
			get
			{
				return (string)this["registerUrl"];
			}
			set
			{
				this["registerUrl"] = value;
			}
		}

		/// <summary>
		/// Gets / sets the url of the page to recover the password of the account.
		/// </summary>
		[ConfigurationProperty("forgotPasswordUrl", IsRequired = true)]
		public string ForgotPasswordUrl
		{
			get
			{
				return (string)this["forgotPasswordUrl"];
			}
			set
			{
				this["forgotPasswordUrl"] = value;
			}
		}

		#region IOptionalElement Members
		public bool IsDefined
		{
			get 
			{
				return !String.IsNullOrEmpty(ConnectionStringName);
			}
		}
		#endregion
	}
}
