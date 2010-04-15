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

		public static List<User> GetAll()
		{
			UsersDataAccess da = new UsersDataAccess();
			return da.GetAll();
		}

		public static List<User> GetByName(string userName)
		{
			UsersDataAccess da = new UsersDataAccess();
			return da.GetByName(userName);
		}

		public static void Delete(int id)
		{
			UsersDataAccess da = new UsersDataAccess();
			da.Delete(id);
		}

		/// <summary>
		/// Assigns the next (up) user group to the user
		/// </summary>
		public static void Promote(int id)
		{
			UsersDataAccess da = new UsersDataAccess();
			da.Promote(id);
		}

		/// <summary>
		/// Assigns the previous (down) user group to the user
		/// </summary>
		public static void Demote(int id)
		{
			UsersDataAccess da = new UsersDataAccess();
			da.Demote(id);
		}

		public static User Get(int userId)
		{
			UsersDataAccess da = new UsersDataAccess();
			return da.Get(userId);
		}
	}
}
