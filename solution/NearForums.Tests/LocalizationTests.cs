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
		public void LocalizationParser_GetValue_Test()
		{
			Assert.AreEqual("key", LocalizationParser.GetValue("msgid \"key\""));
			Assert.AreEqual("value", LocalizationParser.GetValue("\"value\""));
			Assert.AreEqual("This is a \\\"quoted\\\" value", LocalizationParser.GetValue("\"This is a \\\"quoted\\\" value\""));
		}

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
		public void Localizer_Load_Test()
		{
			var cultureFilePath = ConfigurationManager.AppSettings["FakeApplicationRoot"];
			cultureFilePath = Path.Combine(cultureFilePath, @"content\localization\es-es.po");

			var localizer = new Localizer("es-ES", cultureFilePath);
			localizer.LoadCulture();

			Assert.AreEqual("Eliminar", localizer.Get("Delete"));
			Assert.IsTrue(localizer.Get("Multiline").Contains("\n"));
		}
	}
}
