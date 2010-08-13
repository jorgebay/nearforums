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
		#region Get by provider
		public User GetByProviderId(AuthenticationProvider provider, string providerId)
		{
			User user = null;

			DbCommand command = GetCommand("SPUsersGetByProvider");
			command.AddParameter<string>(this.Factory, "Provider", provider.ToString().ToUpper());
			command.AddParameter<string>(this.Factory, "ProviderId", providerId);

			DataRow dr = GetFirstRow(command);
			if (dr != null)
			{
				user = ParseUserLoginInfo(dr);
			}
			return user;
		} 
		#endregion

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

		#region Parse user
		protected virtual User ParseUserLoginInfo(DataRow dr)
		{
			User user = new User();
			user.Id = dr.Get<int>("UserId");
			user.UserName = dr.GetString("UserName");
			user.Group = dr.Get<UserGroup>("UserGroupId");
			user.Guid = new Guid(dr.GetString("UserGuid"));
			user.ExternalProfileUrl = dr.GetString("UserExternalProfileUrl");
			user.ProviderLastCall = dr.GetDate("UserProviderLastCall");

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
		#endregion

		#region Add user
		public User AddUser(User user, AuthenticationProvider provider, string providerId)
		{
			DbCommand comm = GetCommand("SPUsersInsertFromProvider");
			comm.AddParameter<string>(this.Factory, "UserName", user.UserName);
			comm.AddParameter<string>(this.Factory, "UserProfile", user.Profile);
			comm.AddParameter<string>(this.Factory, "UserSignature", user.Signature);
			comm.AddParameter<short>(this.Factory, "UserGroupId", (short)user.Group);
			comm.AddParameter(this.Factory, "UserBirthDate", DbType.DateTime, user.BirthDate);
			comm.AddParameter<string>(this.Factory, "UserWebsite", user.Website);
			comm.AddParameter<string>(this.Factory, "UserGuid", Guid.NewGuid().ToString("N"));
			comm.AddParameter<decimal>(this.Factory, "UserTimezone", (decimal)user.TimeZone.TotalHours);
			comm.AddParameter(this.Factory, "UserEmail", DbType.String, null);
			comm.AddParameter(this.Factory, "UserEmailPolicy", DbType.Int32, null);
			comm.AddParameter<string>(this.Factory, "UserPhoto", user.Photo);
			comm.AddParameter<string>(this.Factory, "UserExternalProfileUrl", user.ExternalProfileUrl);
			comm.AddParameter<string>(this.Factory, "UserProvider", provider.ToString().ToUpper());
			comm.AddParameter<string>(this.Factory, "UserProviderId", providerId.ToUpper());

			DataRow dr = GetFirstRow(comm);
			user = ParseUserLoginInfo(dr);

			return user;
		} 
		#endregion

		#region Edit
		public void Edit(User user)
		{
			DbCommand comm = GetCommand("SPUsersUpdate");
			comm.AddParameter<int>(this.Factory, "UserId", user.Id);
			comm.AddParameter<string>(this.Factory, "UserName", user.UserName);
			comm.AddParameter<string>(this.Factory, "UserProfile", user.Profile);
			comm.AddParameter<string>(this.Factory, "UserSignature", user.Signature);
			comm.AddParameter(this.Factory, "UserBirthDate", DbType.DateTime, user.BirthDate);
			comm.AddParameter<string>(this.Factory, "UserWebsite", user.Website);
			comm.AddParameter<decimal>(this.Factory, "UserTimezone", (decimal)user.TimeZone.TotalHours);
			comm.AddParameter(this.Factory, "UserEmail", DbType.String, user.Email);
			comm.AddParameter(this.Factory, "UserEmailPolicy", DbType.Int32, (int) user.EmailPolicy);
			comm.AddParameter<string>(this.Factory, "UserPhoto", user.Photo);
			comm.AddParameter<string>(this.Factory, "UserExternalProfileUrl", user.ExternalProfileUrl);

			comm.SafeExecuteNonQuery();
		} 
		#endregion

		#region Get list
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
		#endregion

		#region Promote / Demote / Delete
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
		#endregion

		public User Get(int userId)
		{
			User user = null;
			DbCommand comm = GetCommand("SPUsersGet");
			comm.AddParameter<int>(this.Factory, "UserId", userId);

			DataRow dr = GetFirstRow(comm);
			if (dr != null)
			{
				user = ParseUserInfo(dr);
				user.ExternalProfileUrl = dr.GetString("UserExternalProfileUrl");
				user.Email = dr.GetString("UserEmail");
				user.EmailPolicy = (EmailPolicy)(dr.GetNullable<int?>("UserEmailPolicy") ?? (int)EmailPolicy.None);
				user.Photo = dr.GetString("UserPhoto");
				user.Website = dr.GetString("UserWebsite");
				user.BirthDate = dr.GetNullable<DateTime?>("UserBirthDate");
			}
			return user;
		}

		public string GetGroupName(UserGroup userGroup)
		{
			string result = null;
			DbCommand comm = GetCommand("SPUsersGroupsGet");
			comm.AddParameter<short>(this.Factory, "UserGroupId", (short) userGroup);

			DataRow dr = GetFirstRow(comm);
			if (dr != null)
			{
				result = dr.GetString("UserGroupName");
			}
			return result;
		}
	}
}
