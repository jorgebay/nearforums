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

		/// <summary>
		/// Determines if with the role supplied has access to post
		/// </summary>
		/// <param name="userRole"></param>
		/// <returns></returns>
		bool HasPostAccess(UserRole? userRole);

		/// <summary>
		/// Determines if with the role supplied has access to read
		/// </summary>
		/// <param name="userRole"></param>
		/// <returns></returns>
		bool HasReadAccess(UserRole? userRole);
	}
}
