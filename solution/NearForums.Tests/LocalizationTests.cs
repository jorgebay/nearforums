using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NearForums.Localization;
using System.Configuration;
using NearForums.Configuration;
using System.IO;

namespace NearForums.Tests
{
	[TestClass]
	public class LocalizationTests
	{
		[TestMethod]
		public void LocalizationParser_ParseString_Test()
		{
			string entriesText;
			Dictionary<string,string> translations;

			entriesText = "# Nearforums PO file - es-ES\n";
			entriesText += "msgid \"id\"\n";
			entriesText += "msgstr \"value\"\n";
			entriesText += "#: scope 2\n";
			entriesText += "msgid \"id2\"\n";
			entriesText += "msgstr \"\"\n";
			entriesText += "\"value2" + "\\" + "n" + "\"\n";
			entriesText += "\"multiline\"\n";

			translations = LocalizationParser.ParseString(entriesText);

			Assert.IsTrue(translations.Count == 2);
			Assert.IsTrue(translations["id"] == "value");
			Assert.IsTrue(translations["id2"] == "value2\nmultiline");

			var value = "value\nmultiline";
			Assert.AreEqual(value, LocalizationParser.Unescape(LocalizationParser.Escape(value)));
		}

		[TestMethod]
		public void LocalizationParser_Unescape_Test()
		{
			//Line breaks
			Assert.AreEqual("Line1\nLine2", LocalizationParser.Unescape("Line1\\nLine2"));
			Assert.AreEqual("FakeLine1\\nFakeLine2", LocalizationParser.Unescape("FakeLine1\\\\nFakeLine2"));

			//Quots
			Assert.AreEqual("start\"quoted\"", LocalizationParser.Unescape("start\\\"quoted\\\""));
		}

		[TestMethod]
		public void Localizer_Load_Test()
		{
			var cultureFilePath = ConfigurationManager.AppSettings["FakeApplicationRoot"];
			cultureFilePath = Path.Combine(cultureFilePath, @"content\localization\en-US.po");

			var localizer = new Localizer("en-US", cultureFilePath);
			localizer.LoadCulture();

			Assert.IsTrue(localizer.Count > 0);
			Assert.AreEqual("Delete", localizer.Get("Delete"));
			Assert.AreEqual("Forum", localizer.Get("Forum"));
		}
	}
}
