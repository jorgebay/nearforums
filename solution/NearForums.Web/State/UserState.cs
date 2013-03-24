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
		{
			Id = user.Id;
			UserName = user.UserName;
			Role = user.Role;
			Guid = user.Guid;
			TimeZone = user.TimeZone;
			ExternalProfileUrl = user.ExternalProfileUrl;
			Email = user.Email;
			Warned = user.Warned;
			ProviderInfo = new ProviderInfo()
			{
				Provider = provider,
				AllowChangeEmail = true
			};
		}

		public string Email
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
		/// Private GUID, dot not send over the wire
		/// </summary>
		public Guid Guid
		{
			get;
			set;
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

		/// <summary>
		/// public identifier of the user
		/// </summary>
		public int Id
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
		/// Gets the info from the authentication provider that authenticated this account.
		/// </summary>
		public ProviderInfo ProviderInfo
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

		public TimeSpan? TimeZone
		{
			get;
			set;
		}

		/// <summary>
		/// public user name
		/// </summary>
		public string UserName
		{
			get;
			set;
		}

		/// <summary>
		/// Determines if the user has been warned by a moderator
		/// </summary>
		public bool Warned
		{
			get;
			set;
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

		/// <summary>
		/// Returns an instance of Nearforums.User with the current UserState id, username, role and guid
		/// </summary>
		/// <returns></returns>
		public User ToUser()
		{
			return new User
			{
				Id=this.Id,
				UserName = this.UserName,
				Role = this.Role,
				Guid = this.Guid
			};
		}
	}
}
