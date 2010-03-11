using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums
{
	public class WeightTag
	{
		public WeightTag(string value, decimal weight)
		{
			this.Value = value;
			this.Weight = weight;
		}

		public string Value
		{
			get;
			set;
		}

		public decimal Weight
		{
			get;
			set;
		}
	}
}
