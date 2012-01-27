using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.Configuration;

namespace NearForums.Web.State
{
	public class UserState
	{
		public UserState(User user, AuthenticationProvider provider) : this(user, provider, SiteConfiguration.Current.AuthenticationProviders)
		{

		}

		public UserState(User user, AuthenticationProvider provider, AuthenticationProvidersElement config)
		{
			Id = user.Id;
			UserName = user.UserName;
			Role = user.Role;
			Guid = user.Guid;
			TimeZone = user.TimeZone;
			ExternalProfileUrl = user.ExternalProfileUrl;
			Provider = provider;
			Email = user.Email;
			Config = config;
			ProviderInfo = new ProviderInfo();

			if (provider == AuthenticationProvider.Custom)
			{
				ProviderInfo.AllowChangeEmail = Config.Custom.AllowChangeEmail;
				ProviderInfo.EditAccountUrl = Config.Custom.AccountEditUrl;
			}
		}

		protected AuthenticationProvidersElement Config
		{
			get;
			set;
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
		/// Determines the authentication provider used by the user
		/// </summary>
		public AuthenticationProvider Provider
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

		public User ToUser()
		{
			return new User
			{
				Id=this.Id
			};
		}
	}
}
