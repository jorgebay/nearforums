using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums
{
	public class Forum
	{
		public int Id
		{
			get;
			set;
		}

		public string Name
		{
			get;
			set;
		}

		public string ShortName
		{
			get;
			set;
		}

		/// <summary>
		/// Plain text forum description
		/// </summary>
		public string Description
		{
			get;
			set;
		}

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
