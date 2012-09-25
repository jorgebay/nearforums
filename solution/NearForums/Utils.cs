using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.ComponentModel;
using System.Security.Cryptography;

namespace NearForums
{
	public static class Utils
	{
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

		#region Html strings
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
		/// Remove tags from a html string. Should not be used for critical html handling.
		/// </summary>
		/// <param name="value"></param>
		/// <returns></returns>
		public static string RemoveTags(string value)
		{
			if (value != null)
			{
				value = CleanHtmlComments(value);
				value = CleanHtmlBehaviour(value);
				value = Regex.Replace(value, @"</?[^>]+?>", " ");
				value = value.Trim();
			}
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

		/// <summary>
		/// Adds rel=nofollow to html anchors
		/// </summary>
		public static string HtmlLinkAddNoFollow(string value)
		{
			return Regex.Replace(value, "<a[^>]+href=\"?'?(?!#[\\w-]+)([^'\">]+)\"?'?[^>]*>(.*?)</a>", "<a href=\"$1\" rel=\"nofollow\" target=\"_blank\">$2</a>", RegexOptions.IgnoreCase | RegexOptions.Compiled);
		}

		#region Sanitize Html
		/// <summary>
		/// sanitize any potentially dangerous tags from the provided raw HTML input using 
		/// a whitelist based approach, leaving the "safe" HTML tags
		/// CODESNIPPET:4100A61A-1711-4366-B0B0-144D1179A937 / http://refactormycode.com/codes/333-sanitize-html
		/// </summary>
		/// <param name="html">Html to sanitize</param>
		/// <param name="whiteListTags">Regex containing the allowed name of the html elements. For example: em|h(2|3|4)|strong|p</param>
		public static string SanitizeHtml(string html, string whiteListTags = "b(lockquote)?|code|d(d|t|l|el)|em|h(1|2|3|4)|i|kbd|li|ol|p(re)?|s(ub|up|trong|trike)?|ul|a|img")
		{
			#region Regex definitions
			Regex tagsRegex = new Regex("<[^>]*(>|$)",
				RegexOptions.Singleline | RegexOptions.ExplicitCapture | RegexOptions.Compiled);

			Regex cleanupRegex = new Regex("((?<=<\\w+[^>]*)(?!\\shref|\\sclass|\\srel|\\stitle|\\sclass|\\swidth|\\sheight|\\salt|\\ssrc)(\\s[\\w-]+)=[\"']?((?:.(?![\"']?\\s+(?:\\S+)=|[>\"']))+.)[\"']?)|((?<=<p[^>]*)\\sclass=\"MsoNormal\")",
					RegexOptions.Singleline | RegexOptions.ExplicitCapture | RegexOptions.IgnoreCase | RegexOptions.Compiled);

			Regex whitelistRegex = new Regex("^</?(" + whiteListTags + ")>$|^<(b|h)r\\s?/?>$",
				RegexOptions.Singleline | RegexOptions.ExplicitCapture | RegexOptions.IgnorePatternWhitespace);

			Regex whitelistAnchorRegex = new Regex(@"
			^<a\s
			href=""(\#\w+|(https?|ftp)://[-a-z0-9+&@#/%?=~_|!:,.;\(\)]+)""
			(
			(\sclass=""([\w-]+)"")|(\stitle=""[^""<>]+"")|
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
			#endregion

			if (String.IsNullOrEmpty(html))
				return html;

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

				if (!(whitelistRegex.IsMatch(tagname) || whitelistAnchorRegex.IsMatch(tagname) || whitelistImageRegex.IsMatch(tagname)))
				{
					html = html.Remove(tag.Index, tag.Length);
					System.Diagnostics.Debug.WriteLine("tag sanitized: " + tagname);
				}
			}

			return html;
		}

		#endregion 
		#endregion

		public static string NullToEmpty(string value)
		{
			if (value == null)
			{
				return "";
			}
			return value;
		}

		public static string EmptyToNull(string value)
		{
			if (value != null && value.Trim() == "")
			{
				return null;
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

		public static string ReplaceBodyValues(string body, object container, string[] propertyNames)
		{
			var values = new Dictionary<string, string>();
			foreach (string property in propertyNames)
			{
				values.Add(property, Convert.ToString(GetPropertyValue(container, property)));
			}
			return ReplaceBodyValues(body, values);
		}

		public static string ReplaceBodyValues(string body, Dictionary<string, string> values)
		{
			if (values != null)
			{
				//replace all the template values with the object values.
				foreach (KeyValuePair<string, string> pair in values)
				{
					body = body.Replace("<!--!" + pair.Key.ToUpper() + "!-->", pair.Value);
				}
			}
			return body;
		}

		/// <summary>
		/// Gets a property value from an object
		/// </summary>
		/// <param name="container">Container to extract the value from.</param>
		/// <param name="propName">Property name.</param>
		public static object GetPropertyValue(object container, string propName)
		{
			PropertyDescriptor descriptor = null;
			if (container == null)
			{
				throw new ArgumentNullException("container");
			}
			if (string.IsNullOrEmpty(propName))
			{
				throw new ArgumentNullException("propName");
			}
			if (!propName.Contains('.'))
			{
				descriptor = TypeDescriptor.GetProperties(container).Find(propName, true);
			}
			else
			{
				string[] properties = propName.Split('.');
				container = GetPropertyValue(container, properties[0]);
				descriptor = TypeDescriptor.GetProperties(container).Find(properties[1], true);
			}
			if (descriptor == null)
			{
				throw new ArgumentException(propName + " property not found");
			}
			return descriptor.GetValue(container);
		}

		/// <summary>
		/// Gets a property value from an object
		/// </summary>
		/// <typeparam name="T">Type of the property.</typeparam>
		/// <param name="container">Container to extract the value from.</param>
		/// <param name="propName">Property name.</param>
		/// <returns></returns>
		public static T GetPropertyValue<T>(object container, string propName)
		{
			return (T)GetPropertyValue(container, propName);
		}

		/// <summary>
		/// Hash an input string and return the hash as a 32 character hexadecimal string
		/// </summary>
		/// <param name="input"></param>
		/// <returns></returns>
		public static string GetMd5Hash(string input, Encoding encoding)
		{
			var bytes = encoding.GetBytes(input.ToLower());
			HashAlgorithm md5Hasher = MD5.Create();
			return BitConverter.ToString(md5Hasher.ComputeHash(bytes)).ToLower().Replace("-", "");
		}
	}
}
