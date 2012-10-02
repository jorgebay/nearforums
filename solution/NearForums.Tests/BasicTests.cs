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
using NearForums.DataAccess;

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
		public void IAccessRightContainer_HasReadAccess_Test()
		{
			IAccessRightContainer container = new Topic();
			UserRole? userRole = null;

			container.ReadAccessRole = null;
			userRole = null;
			Assert.IsTrue(container.HasReadAccess(userRole));

			container.ReadAccessRole = UserRole.Member;
			userRole = null;
			Assert.IsFalse(container.HasReadAccess(userRole));

			container.ReadAccessRole = UserRole.Member;
			userRole = UserRole.TrustedMember;
			Assert.IsTrue(container.HasReadAccess(userRole));

			container.ReadAccessRole = UserRole.TrustedMember;
			userRole = UserRole.Member;
			Assert.IsFalse(container.HasReadAccess(userRole));
		}
	}
}
