using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
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

			SqlCommand command = GetCommand("SPUsersGetByFacebookId");
			command.AddParameter("@uid", SqlDbType.BigInt, uid);

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

			SqlCommand command = GetCommand("SPUsersGetTestUser");

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
			user.Guid = dr.Get<Guid>("UserGuid");

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

			SqlCommand comm = GetCommand("SPUsersInsertFromFacebook");
			comm.AddParameter("@FacebookUserId", SqlDbType.BigInt, uid);
			comm.AddParameter("@FacebookFirstName", SqlDbType.VarChar, firstName);
			comm.AddParameter("@FacebookLastName", SqlDbType.VarChar, lastName);
			comm.AddParameter("@FacebookProfileUrl", SqlDbType.VarChar, profileUrl);
			comm.AddParameter("@FacebookAbout", SqlDbType.VarChar, about);
			comm.AddParameter("@FacebookBirthDate", SqlDbType.DateTime, toSaveBirthDate);
			comm.AddParameter("@FacebookLocale", SqlDbType.VarChar, locale);
			comm.AddParameter("@FacebookPic", SqlDbType.VarChar, pic);
			comm.AddParameter("@FacebookTimeZone", SqlDbType.Decimal, timeZone.Value);
			comm.AddParameter("@FacebookWebsite", SqlDbType.VarChar, website);
			comm.AddParameter("@UserGuid", SqlDbType.UniqueIdentifier, Guid.NewGuid());

			DataRow dr = GetFirstRow(comm);
			user = ParseUserLoginInfo(dr);

			return user;
		}
	}
}
