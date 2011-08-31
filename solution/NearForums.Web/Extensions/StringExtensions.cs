using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using NearForums.Configuration;
using System.Configuration;
using System.IO;
using HtmlAgilityPack;
using System.Web;

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
		/// Parses HTML to avoid XSS attacks, based on the site configuration
		/// </summary>
		/// <param name="value"></param>
		/// <returns></returns>
		public static string SafeHtml(this string value)
		{
			var htmlConfig = SiteConfiguration.Current.SpamPrevention.HtmlInput;
			if (String.IsNullOrEmpty(value))
			{
				return value;
			}
			var html = Utils.SanitizeHtml(value, htmlConfig.AllowedElements);
			if (htmlConfig.FixErrors && html.Length > 0)
			{
				const string wrapperStart = "<div class=\"htmlWrapper\">";
				const string wrapperEnd = "</div>";
				var outputWriter = new StringWriter();
				var doc = new HtmlDocument();
				doc.LoadHtml(wrapperStart + html + wrapperEnd);
				doc.OptionWriteEmptyNodes = true;
				doc.Save(outputWriter);
				html = outputWriter.ToString();
				html = html.Remove(html.Length - wrapperEnd.Length);
				html = html.Remove(0, wrapperStart.Length);
			}
			html = Utils.HtmlLinkAddNoFollow(html);
			return html;
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

		/// <summary>
		/// Returns a string that can be used in a url segment
		/// </summary>
		public static string ToUrlSegment(this string value, int maxLength)
		{
			if (value == null)
			{
				return null;
			}
			var segment = Regex.Replace(value, @"[^a-z- ]+", "");
			segment = Regex.Replace(segment, @" ", "-");
			segment = Regex.Replace(segment, @"-+", "-");
			segment = Regex.Replace(segment, @"^-+|-+$", "");

			//Handle alfabets that does not have contain ascii chars a-z
			if (segment == "" && Regex.IsMatch(value, @"\w+"))
			{
				segment = HttpUtility.UrlEncode(value);
			}
			else if (segment.Length > maxLength)
			{
				segment = segment.Substring(0, maxLength);
			}
			segment = segment.ToLowerInvariant();
			return segment;
		}

		public static int? ToNullableInt(this string value)
		{
			if (String.IsNullOrEmpty(value))
			{
				return (int?)null;
			}
			else
			{
				return Convert.ToInt32(value);
			}
		}
	}
}
