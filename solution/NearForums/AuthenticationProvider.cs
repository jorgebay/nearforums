using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums
{
	public enum AuthenticationProvider
	{
		Facebook,
		Twitter,
		OpenId,
		/// <summary>
		/// ASP.NET Membership
		/// </summary>
		Membership,
		/// <summary>
		/// Custom database provider
		/// </summary>
		CustomDb
	}
}
