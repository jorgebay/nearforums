using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums.Web.State
{
	public class UserState
	{
		public UserState(User user, AuthenticationProvider provider)
		{
			this.Id = user.Id;
			this.UserName = user.UserName;
			this.Group = user.Group;
			this.Guid = user.Guid;
			this.TimeZone = user.TimeZone;
			this.ExternalProfileUrl = user.ExternalProfileUrl;
			this.Provider = provider;
			this.Email = user.Email;
		}

		public int Id
		{
			get;
			set;
		}

		public string UserName
		{
			get;
			set;
		}

		public UserGroup Group
		{
			get;
			set;
		}

		public string Email
		{
			get;
			set;
		}

		public TimeSpan? TimeZone
		{
			get;
			set;
		}

		public Guid Guid
		{
			get;
			set;
		}

		public string ExternalProfileUrl
		{
			get;
			set;
		}

		/// <summary>
		/// Determines the authentication provider used by the user
		/// </summary>
		public AuthenticationProvider Provider
		{
			get;
			set;
		}

		public User ToUser()
		{
			return new User
			{
				Id=this.Id
			};
		}
	}
}
