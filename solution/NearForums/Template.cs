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

		private string _key;
		[RequireField]
		[RegexFormat("^[\\w-]{1,64}$")]
		public string Key
		{
			get
			{
				return _key;
			}
			set
			{
				if (value != null)
				{
					_key = value.ToLower();
				}
				else
				{
					_key = null;
				}
			}
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
