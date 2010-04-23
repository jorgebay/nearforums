using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using NearForums.Configuration;

namespace NearForums.Web.Extensions
{
	public static class StringExtensions
	{
		public static string ReplaceValues(this string value)
		{
			if (SiteConfiguration.Current != null)
			{
				ReplacementCollection replacements = SiteConfiguration.Current.Replacements;
				foreach (ReplacementItem item in replacements)
				{
					value = Regex.Replace(value, item.Pattern, item.Replacement, item.RegexOptions);
				}
			}
			return value;
		}

		public static string FirstUpperCase(this string value)
		{
			if (!String.IsNullOrEmpty(value))
			{
				string result = value.Substring(0, 1);
				result = result.ToUpper();

				if (value.Length > 1)
				{
					result += value.Substring(1);
				}
				return result;
			}
			return value;
		}
	}
}
