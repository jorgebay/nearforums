using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.Validation;

namespace NearForums
{
	public class User
	{
		public User()
		{
			this.Group = UserGroup.Level1;
		}

		public User(int id, string userName) : this()
		{
			this.Id = id;
			this.UserName = userName;
		}

		public int Id
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

		public UserGroup Group
		{
			get;
			set;
		}

		public string GroupName
		{
			get;
			set;
		}

		public TimeSpan TimeZone
		{
			get;
			set;
		}

		public DateTime RegistrationDate
		{
			get;
			set;
		}

		public Guid Guid
		{
			get;
			set;
		}

		public string Signature
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

		public string Profile
		{
			get;
			set;
		}

		public DateTime? BirthDate
		{
			get;
			set;
		}

		public string Website
		{
			get;
			set;
		}

		/// <summary>
		/// Photo absolut url
		/// </summary>
		public string Photo
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
	}
}
