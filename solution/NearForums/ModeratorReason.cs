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
		/// <summary>
		/// Flam / bash
		/// </summary>
		Flaming = 0,
		/// <summary>
		/// Sending spam
		/// </summary>
		Spamming = 1,
		/// <summary>
		/// Offensive behaviour
		/// </summary>
		Harassing = 2,
		Other = 100
	}
}
