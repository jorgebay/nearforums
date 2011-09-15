using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace NearForums
{
	public class TagList : List<string>
	{
		public TagList()
		{

		}

		/// <param name="tags">whitespace separated list</param>
		public TagList(string tags)
		{
			if (!String.IsNullOrEmpty(tags))
			{
				//Replace all whitespace separators to single space
				tags = Regex.Replace(tags, @"\s+", " ");

				string[] tagsSplitted = tags.Split(' ');

				//add all tags once and avoid empty strings
				foreach (string value in tagsSplitted)
				{
					if (!String.IsNullOrEmpty(value))
					{
						var v = value.ToLower();
						if (!Contains(v))
						{
							Add(v);
						}
					}
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
