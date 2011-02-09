using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Net;
using System.Configuration;
using System.Net.Mail;
using NearForums.Configuration;
using NearForums.Web.Extensions;
using HtmlAgilityPack;
using System.IO;

namespace NearForums.Tests
{
	/// <summary>
	/// Summary description for BasicTests
	/// </summary>
	[TestClass]
	public class BasicTests
	{
		public BasicTests()
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

		/// <summary>
		/// In order to determine if a webrequest to facebook or any http host can be made.
		/// </summary>
		[TestMethod]
		public void WebRequest_Test()
		{
			try
			{
				WebRequest webRequest = HttpWebRequest.Create("http://www.facebook.com");
				webRequest.Headers.Add("Accept-Encoding", "gzip, deflate");

				webRequest.GetResponse();
			}
			catch
			{
				Assert.Fail("Web request to a website failed. You probably are behind a proxy / firewall preventing. Place special network configuration in system.net/defaultProxy section in app.config or machine.config. http://msdn.microsoft.com/en-us/library/6484zdc1.aspx");
			}
		}

		[TestMethod]
		public void SmtpSend_Test()
		{
			try
			{
				SmtpClient smtp = new SmtpClient();
				MailMessage message = new MailMessage("someone@someone.com", "somebody@somebody.com");
				message.Subject = message.Body = "Testing";
				smtp.Send(message);
			}
			catch
			{
				Assert.Fail("Sending a test mail failed. You should configure the smtp in system.net/mailSettings section in app.config or machine.config. http://msdn.microsoft.com/en-us/library/6484zdc1.aspx");
			}
		}

		[TestMethod]
		public void Configuration_Test()
		{
			var configFilePath = AppDomain.CurrentDomain.SetupInformation.ConfigurationFile;

			Assert.IsTrue(configFilePath.ToUpper().EndsWith(".DLL.CONFIG"));

			Assert.IsNotNull(SiteConfiguration.Current);

			Assert.IsNotNull(SiteConfiguration.Current.DataAccess.ParameterPrefix);

			Assert.IsNotNull(SiteConfiguration.Current.DataAccess.ConnectionString);

			Assert.IsTrue(!String.IsNullOrEmpty(SiteConfiguration.Current.DataAccess.ConnectionString.ProviderName));
		}

		[TestMethod]
		public void SafeHtml_Test()
		{
			var html = "";
			html = "<p>Hello World<object></object><script></script><iframe></iframe></p>".SafeHtml();
			Assert.AreEqual(html, "<p>Hello World</p>");

			//Add rel="nofollow" attribute to anchors
			html = "<p>Hello World <a href=\"http://argo.com/1.html\">argo</a></p>".SafeHtml();
			Assert.IsTrue(html.Contains("rel=\"nofollow\""));

			html = "<!-- test html comment -->".SafeHtml();
			Assert.IsTrue(html == "");

			html = "<a href=\"something.aspx\" class=\"fastQuote\">Something</a>".SafeHtml();
			Assert.IsTrue(html.Contains("class="));

			html = "<a href=\"something.aspx\" class=\"highlight\">Something</a>".SafeHtml();
			Assert.IsTrue(html.Contains("class="));

			html = "<a href=\"something.aspx\" class=\"anotherClass\">Something</a>".SafeHtml();
			Assert.IsTrue(!html.Contains("class="));

			//Smiley
			html = ":)".SafeHtml().ReplaceValues();
			Assert.IsTrue(html.Contains("<img"));
			
			//Check interaction with replacements
			//Safe + Replacements + SAfe + Replacements
			html = "<p>#200: Hey man!</p>".SafeHtml().ReplaceValues().SafeHtml().ReplaceValues().SafeHtml().ReplaceValues();
			Assert.IsTrue(html.Contains("[#200]</a>: Hey man!"));
		}

		[TestMethod]
		public void HtmlSanitizer_Test()
		{
			var html = "";
			html = StringExtensions.Sanitize("<p>Hello World<object></object><script></script><iframe></iframe></p>");
			Assert.AreEqual(html, "<p>Hello World</p>");

			html = StringExtensions.Sanitize("<p>Hello World <a href=\"http://argo.com/1.html\">argo</a></p>");
			Assert.IsTrue(html.Contains("<a"));

			html = StringExtensions.Sanitize("<p>Hello World <a href=\"onclick:alert('XSS');\">argo</a></p>");
			Assert.IsTrue(!html.Contains("<a"));

			html = StringExtensions.Sanitize("<p>Hello World <a href=\"#\" onclick=\"DoXss();\">argo</a></p>");
			Assert.IsTrue(!html.Contains("onclick"));

			html = StringExtensions.Sanitize("<p>Hello World <img src=\"http://google.com/logo.gif\" onclick=\"DoXss();\" /></p>");
			Assert.IsTrue(!html.Contains("onclick"));
			Assert.IsTrue(html.Contains("<p"));

			//Test common website html
			#region Image tags
			html = StringExtensions.Sanitize("<p>Hello World <img src=\"http://google.com/logo.gif\" height=\"10\" /></p>");
			Assert.IsTrue(html.Contains("<img"));

			html = StringExtensions.Sanitize("<p>Hello World <img src=\"http://google.com/logo.gif\" height=\"10\" width=\"10\" /></p>");
			Assert.IsTrue(html.Contains("<img"));

			html = StringExtensions.Sanitize("<p>Hello World <img src=\"http://google.com/logo.gif\" height=\"10\" width=\"10\" /></p>");
			Assert.IsTrue(html.Contains("<img"));

			html = StringExtensions.Sanitize("<p>Hello World <img src=\"http://google.com/logo.gif\" /></p>");
			Assert.IsTrue(html.Contains("<img")); 
			#endregion

			#region Link tags
			html = StringExtensions.Sanitize("<a href=\"http://google.com\">normal google link</a>");
			Assert.IsTrue(html.Contains("<a"));

			html = StringExtensions.Sanitize("<a href=\"#msg123\">[#1]</a>");
			Assert.IsTrue(html.Contains("<a"));

			html = StringExtensions.Sanitize("<a href=\"#msg123\" title=\"Message!\">[#1]</a>");
			Assert.IsTrue(html.Contains("<a"));

			html = StringExtensions.Sanitize("<a href=\"#msg123\" class=\"fastQuote\">[#1]</a>");
			Assert.IsTrue(html.Contains("<a"));

			html = StringExtensions.Sanitize("<a href=\"http://google.com\" class=\"highlight\">google highlighted</a>");
			Assert.IsTrue(html.Contains("<a"));

			html = StringExtensions.Sanitize("<a href=\"http://google.com\" rel=\"nofollow\">google nofollow</a>");
			Assert.IsTrue(html.Contains("<a")); 
			#endregion

			#region Word copy-pasting
			html = StringExtensions.Sanitize("<p style=\"mso-layout-grid-align: none; text-autospace: none;\"><span style=\"mso-bidi-font-family: Arial; mso-ansi-language: EN-GB;\" lang=\"EN-GB\">Text inside a p</span></p>");
			Assert.IsTrue(html.Contains("<p>Text inside a p"));
			#endregion

			#region Tests from http://ha.ckers.org/xss.html
			html = StringExtensions.Sanitize("<SCRIPT SRC=http://ha.ckers.org/xss.js></SCRIPT>");
			Assert.IsTrue(html == "");

			html = StringExtensions.Sanitize("<IMG SRC=javascript:alert('XSS')>");
			Assert.IsTrue(html == "");

			html = StringExtensions.Sanitize("<META HTTP-EQUIV=\"refresh\" CONTENT=\"0; URL=http://;URL=javascript:alert('XSS');\">");
			Assert.IsTrue(html == "");

			html = StringExtensions.Sanitize("<IFRAME SRC=\"javascript:alert('XSS');\"></IFRAME>");
			Assert.IsTrue(html == "");

			html = StringExtensions.Sanitize("<TABLE><TD BACKGROUND=\"javascript:alert('XSS')\">");
			Assert.IsTrue(html == "");

			html = StringExtensions.Sanitize("<OBJECT TYPE=\"text/x-scriptlet\" DATA=\"http://ha.ckers.org/scriptlet.html\"></OBJECT>");
			Assert.IsTrue(html == "");

			html = StringExtensions.Sanitize("<OBJECT TYPE=\"text/x-scriptlet\" DATA=\"http://ha.ckers.org/scriptlet.html\"></OBJECT>");
			Assert.IsTrue(html == "");

			html = StringExtensions.Sanitize("");
			Assert.IsTrue(html == ""); 
			#endregion
		}

		[TestMethod]
		public void HtmlDescendance_Test()
		{
			StringWriter outputWriter = new StringWriter();
			var doc = new HtmlDocument();
			doc.LoadHtml("<div class=\"wrapper\"><p><strong>This paragraph <br>is not closed</strong></div>");
			doc.OptionWriteEmptyNodes = true;
			doc.Save(outputWriter);
			string output = outputWriter.ToString();
			Assert.IsTrue(output.Contains("<p />"));
		}

		[TestMethod]
		public void NotificationsConfiguration_Test()
		{
			string value = SiteConfiguration.Current.Notifications.Subscription.Body.Value;
		}
	}
}
