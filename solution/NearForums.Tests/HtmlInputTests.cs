using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NearForums.Web.Extensions;
using NearForums.Tests;
using HtmlAgilityPack;
using System.IO;

namespace NearForums.Tests
{
	/// <summary>
	/// Summary description for SpamPreventionTests
	/// </summary>
	[TestClass]
	public class HtmlInputTests
	{
		public HtmlInputTests()
		{
			//
			// TODO: Add constructor logic here
			//
		}

		private TestContext testContextInstance;

		/// <summary>
		///Gets or sets the test context which provides
		///information about and functionality for the current test run.
		///</summary>
		public TestContext TestContext
		{
			get
			{
				return testContextInstance;
			}
			set
			{
				testContextInstance = value;
			}
		}

		#region Additional test attributes
		//
		// You can use the following additional attributes as you write your tests:
		//
		// Use ClassInitialize to run code before running the first test in the class
		// [ClassInitialize()]
		// public static void MyClassInitialize(TestContext testContext) { }
		//
		// Use ClassCleanup to run code after all tests in a class have run
		// [ClassCleanup()]
		// public static void MyClassCleanup() { }
		//
		// Use TestInitialize to run code before running each test 
		// [TestInitialize()]
		// public void MyTestInitialize() { }
		//
		// Use TestCleanup to run code after each test has run
		// [TestCleanup()]
		// public void MyTestCleanup() { }
		//
		#endregion


		[TestMethod]
		public void HtmlSanitizer_Basic_Test()
		{
			var html = "";
			html = "<p>Hello World<object></object><script></script><iframe></iframe></p>".SafeHtml();
			Assert.IsTrue(html == "<p>Hello World</p>");

			html = "<p>Hello World <a href=\"http://argo.com/1.html\">argo</a></p>".SafeHtml();
			Assert.IsTrue(html.Contains("<a"));

			html = "<p>Hello World <a href=\"onclick:alert('XSS');\">argo</a></p>".SafeHtml();
			Assert.IsTrue(!html.Contains("<a"));

			html = "<p>Hello World <a href=\"#\" onclick=\"DoXss();\">argo</a></p>".SafeHtml();
			Assert.IsTrue(!html.Contains("onclick"));

			html = "<p>Hello World <img src=\"http://google.com/logo.gif\" onclick=\"DoXss();\" /></p>".SafeHtml();
			Assert.IsTrue(!html.Contains("onclick"));
			Assert.IsTrue(html.Contains("<p"));

			html = "<p>Accénted</p>".SafeHtml();
			Assert.IsTrue(html.Contains("Accénted"));

			html = "<p>Acc&eacute;nted</p>".SafeHtml();
			Assert.IsTrue(html.Contains("Acc&eacute;nted"));
		}

		[TestMethod]
		public void HtmlSanitizer_Images_Test()
		{
			var html = "";
			#region Image tags
			html = "<p>Hello World <img src=\"http://google.com/logo.gif\" height=\"10\" /></p>".SafeHtml();
			Assert.IsTrue(html.Contains("<img"));

			html = "<p>Hello World <img src=\"http://google.com/logo.gif\" height=\"10\" width=\"10\" /></p>".SafeHtml();
			Assert.IsTrue(html.Contains("<img"));

			html = "<p>Hello World <img src=\"http://google.com/logo.gif\" height=\"10\" width=\"10\" /></p>".SafeHtml();
			Assert.IsTrue(html.Contains("<img"));

			html = "<p>Hello World <img src=\"http://google.com/logo.gif\" /></p>".SafeHtml();
			Assert.IsTrue(html.Contains("<img"));
			#endregion
		}

		[TestMethod]
		public void HtmlSanitizer_Links_Test()
		{
			var html = "";
			#region Link tags
			html = "<a href=\"http://google.com\">normal google link</a>".SafeHtml();
			Assert.IsTrue(html.Contains("<a"));

			html = "<a href=\"#msg123\">[#1]</a>".SafeHtml();
			Assert.IsTrue(html.Contains("<a"));

			html = "<a href=\"#msg123\" title=\"Message!\">[#1]</a>".SafeHtml();
			Assert.IsTrue(html.Contains("<a"));

			html = "<a href=\"#msg123\" class=\"fastQuote\">[#1]</a>".SafeHtml();
			Assert.IsTrue(html.Contains("<a"));

			html = "<a href=\"http://google.com\" class=\"highlight\">google highlighted</a>".SafeHtml();
			Assert.IsTrue(html.Contains("<a"));
			Assert.IsTrue(html.Contains("rel=\"nofollow\""));

			html = "<a href=\"http://google.com\" rel=\"nofollow\">google nofollow</a>".SafeHtml();
			Assert.IsTrue(html.Contains("<a"));
			#endregion
		}

		[TestMethod]
		public void HtmlSanitizer_WordTexts_Test()
		{
			var html = "";
			#region Word copy-pasting
			html = "<p style=\"mso-layout-grid-align: none; text-autospace: none;\"><span style=\"mso-bidi-font-family: Arial; mso-ansi-language: EN-GB;\" lang=\"EN-GB\">Text inside a p</span></p>".SafeHtml();
			Assert.IsTrue(html.Contains("<p>Text inside a p"));

			html = "<p class=\"MsoNormal\"><span style=\"mso-ansi-language: EN-GB;\" lang=\"EN-GB\">Text inside a p</span></p>".SafeHtml();
			Assert.IsTrue(html.Contains("<p"));
			Assert.IsTrue(!html.Contains("MsoNormal"));
			Assert.IsTrue(html.Contains("Text inside a p"));

			html = "<p>Some comments<!-- sdjsdhsdj -- --></p>".SafeHtml();
			Assert.IsTrue(!html.Contains("<!--"));
			#endregion
		}

		[TestMethod]
		public void HtmlSanitizer_CommonInternet_Test()
		{
			var html = "";
			#region Tests from http://ha.ckers.org/xss.html
			html = "<SCRIPT SRC=http://ha.ckers.org/xss.js></SCRIPT>".SafeHtml();
			Assert.IsTrue(!html.Contains("script"));

			html = "<IMG SRC=javascript:alert('XSS')>".SafeHtml();
			Assert.IsTrue(!html.Contains("img"));

			html = "<META HTTP-EQUIV=\"refresh\" CONTENT=\"0; URL=http://;URL=javascript:alert('XSS');\">".SafeHtml();
			Assert.IsTrue(!html.Contains("meta"));

			html = "<IFRAME SRC=\"javascript:alert('XSS');\"></IFRAME>".SafeHtml();
			Assert.IsTrue(!html.Contains("iframe"));

			html = "<TABLE><TD BACKGROUND=\"javascript:alert('XSS')\">".SafeHtml();
			Assert.IsTrue(!html.Contains("table"));

			html = "<OBJECT TYPE=\"text/x-scriptlet\" DATA=\"http://ha.ckers.org/scriptlet.html\"></OBJECT>".SafeHtml();
			Assert.IsTrue(!html.Contains("object"));

			html = "<OBJECT TYPE=\"text/x-scriptlet\" DATA=\"http://ha.ckers.org/scriptlet.html\"></OBJECT>".SafeHtml();
			Assert.IsTrue(!html.Contains("object"));

			html = "".SafeHtml();
			Assert.IsTrue(html == "");
			#endregion
		}

		[TestMethod]
		public void HtmlSanitizer_Replacement_Test()
		{
			var html = "";

			//Smiley
			html = ":)".SafeHtml().ReplaceValues();
			Assert.IsTrue(html.Contains("<img"));

			//Check interaction with replacements
			//Safe + Replacements + SAfe + Replacements
			html = "<p>#200: Hey man!</p>".SafeHtml().ReplaceValues().SafeHtml().ReplaceValues().SafeHtml().ReplaceValues();
			Assert.IsTrue(html.Contains("[#200]</a>: Hey man!"));
			Assert.IsTrue(html.Contains("fastQuote"));


			html = "<a href=\"#msg10\" class=\"fastQuote\">Something</a>".SafeHtml();
			Assert.IsTrue(html.Contains("class="));
		}

		[TestMethod]
		public void HtmlErrors_Fix_Test()
		{
			#region Auto close mallformed paragraphs
			var outputWriter = new StringWriter();
			var doc = new HtmlDocument();
			string output;
			doc.LoadHtml("<div class=\"wrapper\"><p><strong>This paragraph <br>is not closed</strong></div>");
			doc.OptionWriteEmptyNodes = true;
			doc.Save(outputWriter);
			output = outputWriter.ToString();
			Assert.IsTrue(output.Contains("<p />"));
			#endregion

			#region Include childs in mallformed lists
			outputWriter = new StringWriter();
			doc = new HtmlDocument();
			doc.LoadHtml("<div class=\"wrapper\"><ul><li>Item of the list</li></div>");
			doc.OptionWriteEmptyNodes = true;
			doc.Save(outputWriter);
			output = outputWriter.ToString();
			Assert.IsTrue(output.Contains("</ul>"));
			#endregion

			#region Upper case elements
			outputWriter = new StringWriter();
			doc = new HtmlDocument();
			doc.LoadHtml("<div class=\"wrapper\"><UL><li>Item of the list</li></div>");
			doc.OptionWriteEmptyNodes = true;
			doc.Save(outputWriter);
			output = outputWriter.ToString();
			Assert.IsTrue(output.Contains("<ul>"));
			#endregion
		}
	}
}
