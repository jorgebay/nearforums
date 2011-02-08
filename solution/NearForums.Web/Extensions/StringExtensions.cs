using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using NearForums.Configuration;
using org.owasp.validator.html;
using System.Configuration;
using System.IO;

namespace NearForums.Web.Extensions
{
	public static class StringExtensions
	{
		/// <summary>
		/// Replace pattern (determined by the configuration files) of in the text
		/// </summary>
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

		/// <summary>
		/// Parses HTML to avoid XSS attacks
		/// </summary>
		/// <param name="value"></param>
		/// <returns></returns>
		public static string SafeHtml(this string value)
		{
			AntiSamy antiSamy = new AntiSamy();
			var results = antiSamy.scan(value, Policy.getInstance(SiteConfiguration.Current.AntiSamyPolicyFile));
			return results.getCleanHTML();
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
