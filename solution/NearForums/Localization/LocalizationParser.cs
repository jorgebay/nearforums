using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

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
			string text = "";
			return ParseString(text);
		}

		/// <summary>
		/// Parses strings from PO format (http://www.gnu.org/s/hello/manual/gettext/PO-Files.html) to a key/value pair dictionary
		/// </summary>
		public static Dictionary<string, string> ParseString(string text)
		{
			throw new NotImplementedException();
		}
	}
}
