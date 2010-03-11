using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.Validation;

namespace NearForums
{
	public class Template : Entity
	{
		public int Id
		{
			get;
			set;
		}

		[RequireField]
		[Length(16)]
		public string Key
		{
			get;
			set;
		}

		public string Description
		{
			get;
			set;
		}

		public bool IsCurrent
		{
			get;
			set;
		}
	}
}
