using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.Validation;
using System.Text.RegularExpressions;

namespace NearForums
{
	public class Topic : Entity
	{
		public Topic()
		{
			this.Messages = new List<Message>();
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
		[RegexFormat(@"^[a-z\-0-9 ]+$", RegexOptions.IgnoreCase)]
		public TagList Tags
		{
			get;
			set;
		}

		public bool IsClosed
		{
			get;
			set;
		}

		public bool IsSticky
		{
			get;
			set;
		}
	}
}
