using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;

namespace NearForums.ServiceClient
{
	public static class UsersServiceClient
	{
		public static User GetByFacebookId(long uid)
		{
			UsersDataAccess da = new UsersDataAccess();
			return da.GetByFacebookId(uid);
		}

		public static User GetTestUser()
		{
			UsersDataAccess da = new UsersDataAccess();
			return da.GetTestUser();
		}

		public static User AddUserFromFacebook(long uid, string firstName, string lastName, string profileUrl, string about, string birthDate, string locale, string pic, decimal? timeZone, string website)
		{

			UsersDataAccess da = new UsersDataAccess();
			return da.AddUserFromFacebook(uid, firstName, lastName, profileUrl, about, birthDate, locale, pic, timeZone, website);
		}
	}
}
