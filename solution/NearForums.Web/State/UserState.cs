using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.Configuration;

namespace NearForums.Web.State
{
	/// <summary>
	/// Represents user account information that is going to persist on session state
	/// </summary>
	[Serializable]
	public class UserState
	{
		public UserState(User user, AuthenticationProvider provider)
			: this(user, provider, true, null)
		{

		}

		public UserState(User user, AuthenticationProvider provider, bool allowChangeEmail, string editAccountUrl)
		{
			Id = user.Id;
			UserName = user.UserName;
			Role = user.Role;
			Guid = user.Guid;
			TimeZone = user.TimeZone;
			ExternalProfileUrl = user.ExternalProfileUrl;
			Email = user.Email;
			ProviderInfo = new ProviderInfo()
			{
				Provider = provider,
				AllowChangeEmail = allowChangeEmail,
				EditAccountUrl = editAccountUrl
			};
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

		/// <summary>
		/// The hierarchical role of the user
		/// </summary>
		public UserRole Role
		{
			get;
			set;
		}

		/// <summary>
		/// Determines if the user is in role admin
		/// </summary>
		public bool IsAdmin 
		{
			get
			{
				return Role == UserRole.Admin;
			}
		}

		/// <summary>
		/// Determines if the user has the priviledges of a moderator (is moderator or admin)
		/// </summary>
		public bool HasModeratorPriviledges
		{
			get
			{
				return Role >= UserRole.Moderator;
			}
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
		/// Gets the info from the authentication provider that authenticated this account.
		/// </summary>
		public ProviderInfo ProviderInfo
		{
			get;
			protected set;
		}

		/// <summary>
		/// Determines if the user has been authenticated by the authentication provider
		/// </summary>
		/// <param name="provider"></param>
		/// <returns></returns>
		public bool AuthenticatedBy(AuthenticationProvider provider)
		{
			return ProviderInfo.Provider == provider;
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
