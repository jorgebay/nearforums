using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums
{
	public class User
	{
		public User()
		{

		}

		public User(int id, string userName)
		{
			this.Id = id;
			this.UserName = userName;
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

		public string ExternalProfileUrl
		{
			get;
			set;
		}
	}
}
