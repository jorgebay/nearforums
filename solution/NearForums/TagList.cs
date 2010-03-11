using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums
{
	public class TagList : List<string>
	{
		public TagList()
		{

		}

		/// <param name="tags">space separated list</param>
		public TagList(string tags)
		{
			if (!String.IsNullOrEmpty(tags))
			{
				string[] tagsSplitted = tags.Split(' ');
				this.AddRange(tagsSplitted);

				while (this.Remove(""))
				{
				}
			}
		}

		/// <summary>
		/// Returns a string with space delimited values
		/// </summary>
		/// <returns></returns>
		public override string ToString()
		{
			return String.Join(" ", this.ToArray());
		}
	}
}
