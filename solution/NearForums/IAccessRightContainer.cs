using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums
{
	/// <summary>
	/// Represents an object that has read and post access rights
	/// </summary>
	public interface IAccessRightContainer
	{
		/// <summary>
		/// Minimal role to read
		/// </summary>
		UserRole? ReadAccessRole{get;set;}

		/// <summary>
		/// Minimal role to post
		/// </summary>
		UserRole PostAccessRole { get; set;}
	}
}
