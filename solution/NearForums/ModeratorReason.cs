using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums
{
	/// <summary>
	/// Enumerates the reasons for a moderator to block a user
	/// </summary>
	public enum ModeratorReason
	{
		Flamming = 0,
		Spamming = 1,
		Harassing = 2,
		Other = 100
	}
}
