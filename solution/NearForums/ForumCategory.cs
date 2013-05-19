using System;
using System.Collections.Generic;
using NearForums.Validation;

namespace NearForums
{
	public class ForumCategory : Entity
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


		public int Id
		{
			get;
			set;
		}

		public int Order
		{
			get;
			set;
		}

		[RequireField]
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
