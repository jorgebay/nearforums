using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace NearForums
{
	public static class Utils
	{
		public static string ToUrlFragment(string value, int maxLength)
		{
			if (value == null)
			{
				return null;
			}
			value = value.ToLowerInvariant();
			value = Regex.Replace(value, @"[^a-z- ]+", "");
			value = Regex.Replace(value, @" ", "-");
			if (value.Length > maxLength)
			{
				value = value.Substring(0, maxLength);
			}
			return value;
		}

		/// <summary>
		/// Crops a given text
		/// </summary>
		/// <param name="value">the text to summarize</param>
		/// <param name="maxChars">maximum chars allowed</param>
		/// <param name="appendIfCropped">text to be appended if the text is cropped. For example: ...</param>
		/// <returns></returns>
		public static string Summarize(string value, int maxChars, string appendIfCropped)
		{
			if (value == null)
			{
				return null;
			}
			if (value.Length <= maxChars)
			{
				return value;
			}

			value = value.Substring(0, maxChars);
			Match match = Regex.Match(value, @"^.*\b(?=[ \.])", RegexOptions.Singleline);
			if (match.Success)
			{
				value = match.Value;
			}
			if (appendIfCropped != null)
			{
				value += appendIfCropped;
			}

			return value;
		}

		/// <summary>
		/// Crops a given html fragment
		/// </summary>
		/// <param name="value">the text to summarize</param>
		/// <param name="maxChars">maximum chars allowed</param>
		/// <param name="appendIfCropped">text to be appended if the text is cropped. For example: "..."</param>
		/// <returns></returns>
		public static string SummarizeHtml(string value, int maxChars, string appendIfCropped)
		{
			return Summarize(RemoveTags(value), maxChars, appendIfCropped);
		}

		public static bool IsHtmlFragment(string value)
		{
			return Regex.IsMatch(value, @"</?(p|div)>");
		}

		/// <summary>
		/// Remove tags from a html string
		/// </summary>
		/// <param name="value"></param>
		/// <returns></returns>
		public static string RemoveTags(string value)
		{
			value = CleanHtmlComments(value);
			value = CleanHtmlBehaviour(value);
			return Regex.Replace(value, @"</?[^>]+?>", "");
		}

		/// <summary>
		/// Removes dangerous html code.
		/// </summary>
		/// <param name="value"></param>
		/// <returns></returns>
		public static string CleanHtml(string value)
		{
			value = CleanHtmlComments(value);
			value = CleanHtmlBehaviour(value);

			//Remove disallowed html tags.
			value = Regex.Replace(value, "</?(param|(no)?script|object|i?frame|body|style|font|head|link|title|h1)[^>]*?>", "", RegexOptions.IgnoreCase);

			//Remove disallowed attributed.
			//value = Regex.Replace(value, " ?style=\"?'?[^'\">]*\"?'?", "", RegexOptions.IgnoreCase);
			value = RemoveHtmlAttribute(value, "style");

			//Replace links
			value = Regex.Replace(value, "<a[^>]+href=\"?'?([^'\">]+)\"?'?[^>]*>(.*?)</a>", "<a href=\"$1\" rel=\"nofollow\" target=\"_blank\">$2</a>", RegexOptions.IgnoreCase);

			return value;
		}

		/// <summary>
		/// Clean script and styles html tags and content
		/// </summary>
		/// <returns></returns>
		public static string CleanHtmlBehaviour(string value)
		{
			value = Regex.Replace(value, "(<style.+?</style>)|(<script.+?</script>)", "", RegexOptions.IgnoreCase | RegexOptions.Singleline);

			return value;
		}

		/// <summary>
		/// Replace the html commens (also html ifs of msword).
		/// </summary>
		public static string CleanHtmlComments(string value)
		{
			//Remove disallowed html tags.
			value = Regex.Replace(value, "<!--.+?-->", "", RegexOptions.IgnoreCase | RegexOptions.Singleline);

			return value;
		}

		public static string RemoveHtmlAttribute(string value, string attribute)
		{
			return Regex.Replace(value, " ?" + attribute + "=\"?'?[^'\">]*\"?'?", "", RegexOptions.IgnoreCase);
		}

		public static string NullToEmpty(string value)
		{
			if (value == null)
			{
				return "";
			}
			return value;
		}

		public static bool IsNullOrEmpty(string value)
		{
			if (value == null)
			{
				return true;
			}
			else if (value == "" || value.Trim() == "")
			{
				return true;
			}
			return false;
		}

		public static bool IsValidEmailAddress(string value)
		{
			return Regex.IsMatch(value, @"^[\w\.=-]+@[\w\.-]+\.[\w]{2,3}$");
		}

		/// <summary>
		/// It replaces line breaks with br tagsn and urls with links
		/// </summary>
		/// <param name="value"></param>
		/// <returns></returns>
		public static string TextToHtmlFragment(string value)
		{
			if (value == null)
			{
				throw new ArgumentNullException("value");
			}
			value = Regex.Replace(value, "\n", "<br />");
			value = Regex.Replace(value, @"\b(https?|ftp|file)://[-A-Z0-9+&@#/%?=~_|!:,.;]*[-A-Z0-9+&@#/%=~_|]", "<a href=\"$0\" rel=\"nofollow\" target=\"_blank\">$0</a>", RegexOptions.IgnoreCase);

			return value;
		}
	}
}
