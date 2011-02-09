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

		#region Sanitize Html
		/// <summary>
		/// sanitize any potentially dangerous tags from the provided raw HTML input using 
		/// a whitelist based approach, leaving the "safe" HTML tags
		/// CODESNIPPET:4100A61A-1711-4366-B0B0-144D1179A937 / http://refactormycode.com/codes/333-sanitize-html
		/// </summary>
		public static string Sanitize(string html)
		{
			Regex cleanupRegex = new Regex("(?<=<\\w+[^>]*)(?!\\shref|\\sclass|\\srel|\\stitle|\\sclass|\\swidth|\\sheight|\\salt|\\ssrc)(\\s[\\w-]+)=[\"']?((?:.(?![\"']?\\s+(?:\\S+)=|[>\"']))+.)[\"']?",
				RegexOptions.Singleline | RegexOptions.ExplicitCapture);
			Regex tagsRegex = new Regex("<[^>]*(>|$)",
				RegexOptions.Singleline | RegexOptions.ExplicitCapture);
			Regex whitelistRegex = new Regex(@"
			^</?(b(lockquote)?|code|d(d|t|l|el)|em|h(1|2|3)|i|kbd|li|ol|p(re)?|s(ub|up|trong|trike)?|ul)>$|
			^<(b|h)r\s?/?>$",
				RegexOptions.Singleline | RegexOptions.ExplicitCapture | RegexOptions.IgnorePatternWhitespace);
			Regex whitelistAnchorRegex = new Regex(@"
			^<a\s
			href=""(\#\w+|(https?|ftp)://[-a-z0-9+&@#/%?=~_|!:,.;\(\)]+)""
			(
			(\sclass=""(fastquote|highlight)"")|(\stitle=""[^""<>]+"")|
			(\srel=""nofollow""))*
			\s?>$|
			^</a>$",
				RegexOptions.Singleline | RegexOptions.ExplicitCapture | RegexOptions.IgnorePatternWhitespace);
			Regex whitelistImageRegex = new Regex(@"
			^<img\s
			src=""https?://[-a-z0-9+&@#/%?=~_|!:,.;\(\)]+""
			((\swidth=""\d{1,3}"")|
			(\sheight=""\d{1,3}"")|
			(\salt=""[^""<>]*"")|
			(\stitle=""[^""<>]*""))*
			\s?/?>$",
				RegexOptions.Singleline | RegexOptions.ExplicitCapture | RegexOptions.IgnorePatternWhitespace);

			if (String.IsNullOrEmpty(html)) return html;

			//Do a previous cleanup, for not not allowed attributes included comming from word
			html = cleanupRegex.Replace(html, "");

			string tagname;
			Match tag;

			// match every HTML tag in the input
			MatchCollection tags = tagsRegex.Matches(html);
			for (int i = tags.Count - 1; i > -1; i--)
			{
				tag = tags[i];
				tagname = tag.Value.ToLowerInvariant();
        
				if(!(whitelistRegex.IsMatch(tagname) || whitelistAnchorRegex.IsMatch(tagname) || whitelistImageRegex.IsMatch(tagname)))
				{
					html = html.Remove(tag.Index, tag.Length);
					System.Diagnostics.Debug.WriteLine("tag sanitized: " + tagname);
				}
			}

			return html;
		}

		#endregion
	}
}
