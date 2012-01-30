using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.Validation;

namespace NearForums
{
	public class Forum : Entity, IAccessRightContainer
	{
		public Forum()
		{
			PostAccessRole = UserRole.Member;
		}

		public int Id
		{
			get;
			set;
		}

		[RequireField]
		[Length(255)]
		public string Name
		{
			get;
			set;
		}

		[RequireField]
		[Length(32)]
		public string ShortName
		{
			get;
			set;
		}

		[RequireField]
		/// <summary>
		/// Plain text forum description
		/// </summary>
		public string Description
		{
			get;
			set;
		}

		[RequireField]
		public ForumCategory Category
		{
			get;
			set;
		}

		public List<Topic> Topics
		{
			get;
			set;
		}

		/// <summary>
		/// Amount of topics posted in this forum
		/// </summary>
		public int TopicCount
		{
			get;	
			set;
		}

		public int MessageCount
		{
			get;
			set;
		}

		#region IAccessRightContainer Members
		/// <summary>
		/// Minimal role to view this forum and its posts
		/// </summary>
		public UserRole? ReadAccessRole
		{
			get;
			set;
		}

		/// <summary>
		/// Minimal role to post a topic in this forum
		/// </summary>
		public UserRole PostAccessRole
		{
			get;
			set;
		}
		#endregion
	}
}
