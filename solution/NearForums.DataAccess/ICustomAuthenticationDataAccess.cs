using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums.DataAccess
{
	public interface ICustomAuthenticationDataAccess
	{
		User GetUser(string userName, string password);
	}
}
