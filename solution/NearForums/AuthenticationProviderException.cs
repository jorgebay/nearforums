using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums
{
	/// <summary>
	/// Represent a generic error on the authentication provider
	/// </summary>
	public class AuthenticationProviderException : Exception
	{
		/// <summary>
		/// Represent a generic error on the authentication provider
		/// </summary>
		public AuthenticationProviderException(string message)
			: base(message)
		{

		}
	}
}
