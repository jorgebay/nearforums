using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums
{
	public enum UserRole : short
	{
		/// <summary>
		/// Represents a role of a registered user.
		/// </summary>
		Member = 1,
		/// <summary>
		/// Represents a role of a member that have been promoted by an admin or moderator.
		/// </summary>
		TrustedMember = 2,
		/// <summary>
		/// Forum moderator
		/// </summary>
		Moderator = 3,
		/// <summary>
		/// Admin role
		/// </summary>
		Admin = 10
	}
}
