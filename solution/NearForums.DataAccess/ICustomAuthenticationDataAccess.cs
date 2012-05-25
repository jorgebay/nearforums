using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums.DataAccess
{
	public interface ICustomAuthenticationDataAccess
	{
		/// <summary>
		/// Gets the user data from the custom authentication provider
		/// </summary>
		/// <returns>An instance of User type, with only the fields id, name, email filled in.</returns>
		User GetUser(string userName, string password);
	}
}
