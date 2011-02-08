using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.Validation;

namespace NearForums
{
	public class Forum : Entity
	{
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
	}
}
