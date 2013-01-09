using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.Validation;

namespace NearForums
{
	public class User : Entity
	{
		public User()
		{
			this.Role = UserRole.Member;
		}

		public User(int id, string userName) : this()
		{
			this.Id = id;
			this.UserName = userName;
		}

		/// <summary>
		/// Determines if the user is banned from the site
		/// </summary>
		public bool Banned
		{
			get;
			set;
		}

		public DateTime? BirthDate
		{
			get;
			set;
		}

		[EmailFormat]
		/// <summary>
		/// User email
		/// </summary>
		public string Email
		{
			get;
			set;
		}

		public EmailPolicy EmailPolicy
		{
			get;
			set;
		}

		/// <summary>
		/// Profile url at the provider
		/// </summary>
		public string ExternalProfileUrl
		{
			get;
			set;
		}

		/// <summary>
		/// Guid of the user in the application (private)
		/// </summary>
		public Guid Guid
		{
			get;
			set;
		}

		/// <summary>
		/// Identifier of the user within the application
		/// </summary>
		public int Id
		{
			get;
			set;
		}

		/// <summary>
		/// Used for storing a temporary Guid used for password reset purposes
		/// </summary>
		public string PasswordResetGuid
		{
			get;
			set;
		}

		public DateTime PasswordResetGuidExpireDate
		{
			get;
			set;
		}

		[UrlFormat]
		/// <summary>
		/// Photo absolut url
		/// </summary>
		public string Photo
		{
			get;
			set;
		}

		/// <summary>
		/// User profile / bio
		/// </summary>
		public string Profile
		{
			get;
			set;
		}

		/// <summary>
		/// Determines the date of latest call to the provider.
		/// </summary>
		public DateTime ProviderLastCall
		{
			get;
			set;
		}

		public DateTime RegistrationDate
		{
			get;
			set;
		}

		public UserRole Role
		{
			get;
			set;
		}

		/// <summary>
		/// Name of the role the user is in (from db)
		/// </summary>
		public string RoleName
		{
			get;
			set;
		}

		/// <summary>
		/// Post signatures
		/// </summary>
		public string Signature
		{
			get;
			set;
		}

		/// <summary>
		/// Determines if the user has been suspended
		/// </summary>
		public bool Suspended
		{
			get;
			set;
		}

		/// <summary>
		/// Determines the date when the suspension ends
		/// </summary>
		public DateTime? SuspendedEnd
		{
			get;
			set;
		}

		public TimeSpan TimeZone
		{
			get;
			set;
		}

		[RequireField]
		public string UserName
		{
			get;
			set;
		}

		/// <summary>
		/// Determines if currently in warning state.
		/// </summary>
		public bool Warned
		{
			get;
			set;
		}

		/// <summary>
		/// Url of the user website
		/// </summary>
		[UrlFormat]
		public string Website
		{
			get;
			set;
		}
	}
}
