using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;

namespace NearForums.Localization
{
	/// <summary>
	/// Parses PO formats
	/// </summary>
	public static class LocalizationParser
	{
		/// <summary>
		/// Parses PO file
		/// </summary>
		public static Dictionary<string, string> ParseFile(string filePath)
		{
			Dictionary<string, string> entries;
			using (var reader = File.OpenText(filePath))
			{
				entries = ParseString(reader);
			}
			return entries;
		}

		/// <summary>
		/// Parses strings from PO format (http://www.gnu.org/s/hello/manual/gettext/PO-Files.html) to a key/value pair dictionary
		/// </summary>
		public static Dictionary<string, string> ParseString(TextReader reader)
		{
			var entries = new Dictionary<string, string>();
			string entryKey = "";
			string entryValue = "";
			bool lineIsKey = false;
			var line = reader.ReadLine();
			while (line != null)
			{
				if (line.StartsWith("msgid"))
				{
					#region Add previous key / value
					if (entryKey != "" && !entries.ContainsKey(entryKey))
					{
						entries.Add(entryKey, entryValue);
					}
					#endregion

					lineIsKey = true;
					entryKey = GetValue(line);
				}
				else if (line.StartsWith("msgstr"))
				{
					lineIsKey = false;
					entryValue = GetValue(line);
				}
				else if (line.StartsWith("\""))
				{
					if (lineIsKey)
					{
						entryKey += GetValue(line);
					}
					else
					{
						entryValue += GetValue(line);
					}
				}
				line = reader.ReadLine();
				if (line == null)
				{
					#region Add previous key / value
					if (entryKey != "" && !entries.ContainsKey(entryKey))
					{
						entries.Add(entryKey, entryValue);
					}
					#endregion
				}
			}

			return entries;
		}

		/// <summary>
		/// Gets the unescaped value between "" chars. Example: In a line like this: msgid "Hello world" it returns Hello world
		/// </summary>
		/// <returns></returns>
		public static string GetValue(string line)
		{
			var value = "";
			var match = Regex.Match(line, "\"(.*)\"");
			if (match.Success && match.Groups.Count > 1)
			{
				value = match.Groups[1].Captures[0].Value;
			}
			return Unescape(value);
		}

		public static Dictionary<string, string> ParseString(string text)
		{
			Dictionary<string, string> entries;
			using (var reader = new StringReader(text))
			{
				entries = ParseString(reader);
			}
			return entries;
		}

		/// <summary>
		/// Replaces line break char with escaped version
		/// </summary>
		public static string Escape(string value)
		{
			value = Regex.Replace(value, "\r?\n", "\\n");
			return value;
		}

		/// <summary>
		/// Replaces line break escaped characters to line break char (\n)
		/// </summary>
		public static string Unescape(string value)
		{
			//	Replace \n (1 char \ + 1 char n)
			//	into
			//	line breaks (1 char \n)
			value = Regex.Replace(value, "(?<!\\\\)\\\\n", "\n");
			
			//	Replace \\n (1 char \ + 1 char \ + 1 char n)
			//	into 
			//	\n (1 char \ + 1 char n)
			value = Regex.Replace(value, "\\\\\\\\n", "\\n");
			
			//	Replace \" (1 char \ + 1 char ")
			//	into 
			//	" (1 char ")
			value = Regex.Replace(value, "\\\\\"", "\"");
			return value; 
		}
	}
}
