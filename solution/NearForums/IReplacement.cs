using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace NearForums
{
	/// <summary>
	/// Represents an item to replace
	/// </summary>
	public interface IReplacement
	{
		/// <summary>
		/// Regex pattern
		/// </summary>
		string Pattern { get;}
		/// <summary>
		/// Regex replacement
		/// </summary>
		string Replacement { get;}
		RegexOptions RegexOptions { get;}
	}
}
