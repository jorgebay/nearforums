using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;
using NearForums.DataAccess;
using System.Data;
using System.Globalization;

namespace NearForums.DataAccess
{
	public class UsersDataAccess : BaseDataAccess
	{
		public User GetByFacebookId(long uid)
		{
			User user = null;

			DbCommand command = GetCommand("SPUsersGetByFacebookId");
			command.AddParameter(this.Factory, "uid", DbType.Int64, uid);

			DataRow dr = GetFirstRow(command);
			if (dr != null)
			{
				user = ParseUserLoginInfo(dr);
			}
			return user;
		}

		public User GetTestUser()
		{
			User user = null;

			DbCommand command = GetCommand("SPUsersGetTestUser");

			DataRow dr = GetFirstRow(command);
			if (dr != null)
			{
				user = ParseUserLoginInfo(dr);
			}
			return user;
		}

		protected virtual User ParseUserLoginInfo(DataRow dr)
		{
			User user = new User();
			user.Id = dr.Get<int>("UserId");
			user.UserName = dr.GetString("UserName");
			user.Group = dr.Get<UserGroup>("UserGroupId");
			user.Guid = new Guid(dr.GetString("UserGuid"));

			decimal offSet = dr.Get<decimal>("UserTimeZone");
			user.TimeZone = new TimeSpan((long)(offSet * (decimal)TimeSpan.TicksPerHour));

			return user;
		}

		protected virtual User ParseUserInfo(DataRow dr)
		{
			User user = new User();
			user.Id = dr.Get<int>("UserId");
			user.UserName = dr.GetString("UserName");
			user.Group = dr.Get<UserGroup>("UserGroupId");
			user.GroupName = dr.GetString("UserGroupName");
			user.RegistrationDate = dr.GetDate("UserRegistrationDate");

			decimal offSet = dr.Get<decimal>("UserTimeZone");
			user.TimeZone = new TimeSpan((long)(offSet * (decimal)TimeSpan.TicksPerHour));

			return user;
		}


		public User AddUserFromFacebook(long uid, string firstName, string lastName, string profileUrl, string about, string birthDate, string locale, string pic, decimal? timeZone, string website)
		{
			User user = null;
			#region TimeZone
			if (timeZone == null)
			{
				timeZone = Convert.ToDecimal(TimeZone.CurrentTimeZone.GetUtcOffset(DateTime.Now).TotalMilliseconds / 1000d);
			} 
			#endregion

			#region Birth date
			DateTime? toSaveBirthDate = null;
			if (birthDate != null)
			{
				DateTime parsedBirthDate = DateTime.MinValue;
				if (DateTime.TryParse(birthDate, new CultureInfo("en-US"), DateTimeStyles.AdjustToUniversal, out parsedBirthDate))
				{
					toSaveBirthDate = parsedBirthDate;
				}
			}
			#endregion

			DbCommand comm = GetCommand("SPUsersInsertFromFacebook");
			comm.AddParameter(this.Factory, "FacebookUserId", DbType.Int64, uid);
			comm.AddParameter(this.Factory, "FacebookFirstName", DbType.String, firstName);
			comm.AddParameter(this.Factory, "FacebookLastName", DbType.String, lastName);
			comm.AddParameter(this.Factory, "FacebookProfileUrl", DbType.String, profileUrl);
			comm.AddParameter(this.Factory, "FacebookAbout", DbType.String, about);
			comm.AddParameter(this.Factory, "FacebookBirthDate", DbType.DateTime, toSaveBirthDate);
			comm.AddParameter(this.Factory, "FacebookLocale", DbType.String, locale);
			comm.AddParameter(this.Factory, "FacebookPic", DbType.String, pic);
			comm.AddParameter(this.Factory, "FacebookTimeZone", DbType.Decimal, timeZone.Value);
			comm.AddParameter(this.Factory, "FacebookWebsite", DbType.String, website);
			comm.AddParameter(this.Factory, "UserGuid", DbType.String, Guid.NewGuid().ToString("N"));

			DataRow dr = GetFirstRow(comm);
			user = ParseUserLoginInfo(dr);

			return user;
		}

		public List<User> GetByName(string userName)
		{
			DbCommand comm = GetCommand("SPUsersGetByName");
			comm.AddParameter<string>(this.Factory, "UserName", userName);
			DataTable dt = GetTable(comm);

			List<User> users = new List<User>();
			foreach (DataRow dr in dt.Rows)
			{
				User u = ParseUserInfo(dr);
				users.Add(u);
			}
			return users;
		}

		public List<User> GetAll()
		{
			DbCommand comm = GetCommand("SPUsersGetAll");
			DataTable dt = GetTable(comm);

			List<User> users = new List<User>();
			foreach (DataRow dr in dt.Rows)
			{
				User u = ParseUserInfo(dr);
				users.Add(u);
			} 
			return users;
		}

		public void Delete(int id)
		{
			DbCommand comm = GetCommand("SPUsersDelete");
			comm.AddParameter<int>(this.Factory, "UserId", id);

			comm.SafeExecuteNonQuery();
		}

		/// <summary>
		/// Assigns the next (up) user group to the user
		/// </summary>
		/// <param name="id"></param>
		public void Promote(int id)
		{
			DbCommand comm = GetCommand("SPUsersPromote");
			comm.AddParameter<int>(this.Factory, "UserId", id);

			comm.SafeExecuteNonQuery();
		}

		/// <summary>
		/// Assigns the previous (down) user group to the user
		/// </summary>
		/// <param name="id"></param>
		public void Demote(int id)
		{
			DbCommand comm = GetCommand("SPUsersDemote");
			comm.AddParameter<int>(this.Factory, "UserId", id);

			comm.SafeExecuteNonQuery();
		}

		public User Get(int userId)
		{
			User user = null;
			DbCommand comm = GetCommand("SPUsersGet");
			comm.AddParameter<int>(this.Factory, "UserId", userId);

			DataRow dr = GetFirstRow(comm);
			if (dr != null)
			{
				user = ParseUserInfo(dr);
			}
			return user;
		}
	}
}
