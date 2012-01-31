using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.Validation;
using System.Text.RegularExpressions;

namespace NearForums
{
	public class Topic : Entity, IAccessRightContainer
	{
		public Topic()
		{
			Messages = new List<Message>();
			PostAccessRole = UserRole.Member;
		}

		public Topic(int id)
			: this()
		{
			this.Id = id;
		}

		public int Id
		{
			get;
			set;
		}

		[RequireField]
		[Length(256)]
		public string Title
		{
			get;
			set;
		}

		[RequireField]
		[Length(64)]
		public string ShortName
		{
			get;
			set;
		}

		/// <summary>
		/// Html description of the thread
		/// </summary>
		[RequireField]
		public string Description
		{
			get;
			set;
		}

		public DateTime Date
		{
			get;
			set;
		}

		[RequireField]
		public Forum Forum
		{
			get;
			set;
		}

		/// <summary>
		/// Amount of views
		/// </summary>
		public int Views
		{
			get;
			set;
		}

		/// <summary>
		/// Amount of reviews
		/// </summary>
		public int Replies
		{
			get;
			set;
		}

		[RequireField]
		/// <summary>
		/// Author of the topic
		/// </summary>
		public User User
		{
			get;
			set;
		}

		/// <summary>
		/// Las message posted
		/// </summary>
		public Message LastMessage
		{
			get;
			set;
		}

		public List<Message> Messages
		{
			get;
			set;
		}

		/// <summary>
		/// Related topics
		/// </summary>
		public List<Topic> Related
		{
			get;
			set;
		}

		[RequireField]
		[RegexFormat(@"^\s*([\w\-\.]+(\s+|$)){1,6}$", RegexOptions.IgnoreCase)]
		public TagList Tags
		{
			get;
			set;
		}

		/// <summary>
		/// Determines if the topic is closed for replies
		/// </summary>
		public bool IsClosed
		{
			get;
			set;
		}

		/// <summary>
		/// Determines if the topic is fixed ordered
		/// </summary>
		public bool IsSticky
		{
			get;
			set;
		}

		#region IAccessRightContainer Members
		/// <summary>
		/// Minimal role to view this topic and its posts (inherits read access from the forum if its higher)
		/// </summary>
		public UserRole? ReadAccessRole
		{
			get;
			set;
		}

		/// <summary>
		/// Minimal role to post a message in this topic (inherits post access from the forum read access if its higher)
		/// </summary>
		public UserRole PostAccessRole
		{
			get;
			set;
		}

		/// <summary>
		/// Determines if with the role supplied has access to post in this topic
		/// </summary>
		/// <returns></returns>
		public bool HasPostAccess(UserRole? userRole)
		{
			if (userRole >= PostAccessRole)
			{
				return true;
			}
			return false;
		}
		#endregion
	}
}
