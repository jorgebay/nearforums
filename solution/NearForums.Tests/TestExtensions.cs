using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums;
using NearForums.Configuration;

namespace NearForums.Tests
{
	public static class TestExtensions
	{
		public static string SafeHtml(this string value)
		{
			return value.SafeHtml(SiteConfiguration.Current.SpamPrevention.HtmlInput.FixErrors, SiteConfiguration.Current.SpamPrevention.HtmlInput.AllowedElements);
		}

		public static string ReplaceValues(this string value)
		{
			return value.ReplaceValues(SiteConfiguration.Current.Replacements.Select<NearForums.Configuration.ReplacementItem, IReplacement>(r => r));
		}
	}
}
