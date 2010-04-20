﻿using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Net;
using System.Configuration;

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
		public void Connectivity_Test()
		{
			WebRequest webRequest = HttpWebRequest.Create("http://www.facebook.com");
			if (ConfigurationManager.AppSettings["Proxy"] != null)
			{
				string[] proxyParams = ConfigurationManager.AppSettings["Proxy"].Split('|');
				if (proxyParams.Length != 5)
				{
					throw new ConfigurationErrorsException("The Proxy configuration must have 5 params separated by | char. v3");
				}
				webRequest.Proxy = new WebProxy(proxyParams[0], Convert.ToInt32(proxyParams[1]));
				webRequest.Proxy.Credentials = new NetworkCredential(proxyParams[2], proxyParams[3], proxyParams[4]);

			}
			webRequest.Headers.Add("Accept-Encoding", "gzip, deflate");

			webRequest.GetResponse();
		}
	}
}