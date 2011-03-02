using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.Validation;

namespace NearForums
{
	public class ForumCategory
	{
		public ForumCategory()
		{

		}

		public ForumCategory(int id, string name)
			: this()
		{
			this.Id = id;
			this.Name = name;
		}

		[Range(1, Int32.MaxValue)]
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

		public List<Forum> Forums
		{
			get;
			set;
		}
	}
}
