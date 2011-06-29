using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Html;
using ICSharpCode.SharpZipLib.Zip;
using System.Text.RegularExpressions;
using System.Text;
using NearForums.Validation;
using NearForums.ServiceClient;
using NearForums.Web.Controllers.Filters;

using System.Configuration;
using System.Web.Configuration;
using System.Net.Configuration;
using NearForums.Web.Controllers.Helpers;
using DotNetOpenAuth.OAuth.ChannelElements;
using DotNetOpenAuth.Messaging;
using DotNetOpenAuth.OpenId.RelyingParty;
using DotNetOpenAuth.OpenId;
using DotNetOpenAuth.OAuth;
using DotNetOpenAuth.OAuth.Messages;
using NearForums.Web.Controllers.Helpers.OAuth;
using System.Net;
using NearForums.Web.Extensions;

namespace NearForums.Web.Controllers
{
	public class AdminController : BaseController
	{
		#region Dashboard
		[RequireAuthorization(UserGroup.Moderator)]
		public ActionResult Dashboard()
		{
			return View();
		}
		#endregion

		#region Status
		/// <summary>
		/// Shows the status of the website/webserver/db/configuration
		/// </summary>
		/// <returns></returns>
		[RequireAuthorization(UserGroup.Admin)]
		public ActionResult Status()
		{
			this.StatusFill();
			return View();
		}

		/// <summary>
		/// If there is no user created on the db= >gets the status of the website. 
		/// </summary>
		public ActionResult StatusFirst()
		{
			if (IsSiteSet)
			{
				return RedirectToAction("Status");
			}

			this.StatusFill();
			return View("Status");
		}

		/// <summary>
		/// Adds current status to the viewdata
		/// </summary>
		protected virtual void StatusFill()
		{
			try
			{
				Exception lastException = null;
				#region Server and Web.config
				var systemWeb = (SystemWebSectionGroup)ConfigurationManager.GetSection("system.web");
				var compilation = (CompilationSection)ConfigurationManager.GetSection("system.web/compilation");
				var customErrors = (CustomErrorsSection)ConfigurationManager.GetSection("system.web/customErrors");
				var smtp = (SmtpSection)ConfigurationManager.GetSection("system.net/mailSettings/smtp");
				var defaultProxy = (DefaultProxySection)ConfigurationManager.GetSection("system.net/defaultProxy");

				ViewData["Debug"] = compilation.Debug;
				ViewData["CustomErrors"] = customErrors.Mode;
				ViewData["MachineName"] = Server.MachineName;
				ViewData["Mail"] = (smtp != null && smtp.From != null) ? "Set" : "Not properly set";
				ViewData["Proxy"] = defaultProxy != null && defaultProxy.Enabled;
				if (defaultProxy != null && defaultProxy.Enabled)
				{
					try
					{
						ViewData["Proxy-Address"] = defaultProxy.Proxy.ProxyAddress;
					}
					catch
					{
					}
				}
				ViewData["Connectivity"] = "Failure";
				try
				{
					new WebClient().OpenRead("http://google.com");
					ViewData["Connectivity"] = "Success";
				}
				catch (Exception ex)
				{
					//No need to do nothing with the exception
					lastException = ex;
				}
				#endregion

				#region Database
				ConnectionStringSettings connString = Config.DataAccess.ConnectionString;
				ViewData["ConnectionString"] = connString == null ? "Not set" : "Set";
				ViewData["ConnectionStringProvider"] = connString != null ? connString.ProviderName : "";
				try
				{
					UsersServiceClient.GetTestUser();
					ViewData["DatabaseTest"] = "Success";
				}
				catch
				{
					ViewData["DatabaseTest"] = "Failure. Could not connect to database.";
					ViewData["WillNotRun"] = true;
				}
				#endregion

				#region Logging
				ViewData["LoggingEnabled"] = LoggerServiceClient.IsEnabled;
				#endregion

				#region Project
				ViewData["Version"] = System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString();
				#endregion

				#region Notifications
				ViewData["Subscriptions"] = Config.Notifications.Subscription.IsDefined;
				#endregion

				#region Authorization providers
				ViewData["Facebook"] = Config.AuthorizationProviders.Facebook.IsDefined;
				ViewData["Twitter"] = Config.AuthorizationProviders.Twitter.IsDefined;
				#region Test Twitter
				if (Config.AuthorizationProviders.Twitter.IsDefined)
				{
					try
					{
						ViewData["Twitter-Test"] = "Failure";
						var twitter = new WebConsumer(TwitterConsumer.ServiceDescription, new InMemoryTokenManager(Config.AuthorizationProviders.Twitter.ApiKey, Config.AuthorizationProviders.Twitter.SecretKey));
						UserAuthorizationRequest usr = twitter.PrepareRequestUserAuthorization();
						ViewData["Twitter-Test"] = "Success";
					}
					catch (Exception ex)
					{
						//There is no need to do nothing with the exception.
						//Is just to show a success or failure message.
						lastException = ex;
					}
				}
				#endregion

				#region Test SSOOpenId
				ViewData["SSOOpenId"] = Config.AuthorizationProviders.SSOOpenId.IsDefined;
				if (Config.AuthorizationProviders.SSOOpenId.IsDefined)
				{
					try
					{
						ViewData["SSOOpenId-Test"] = "Failure";
						OpenIdRelyingParty openid = new OpenIdRelyingParty();
						var authenticationRequest = openid.CreateRequest(Identifier.Parse(Config.AuthorizationProviders.SSOOpenId.Identifier), new Uri("http://dummyurl.com/"), new Uri("http://dummyurl.com/login"));
						ViewData["SSOOpenId-Test"] = "Success";
					}
					catch (Exception ex)
					{
						//There is no need to do nothing with the exception.
						//Is just to show a success or failure message.
						lastException = ex;
					}
				}
				#endregion
				#endregion
			}
			catch (Exception ex)
			{
				//There were errors while getting the webserver/database/config/website status
				LoggerServiceClient.LogError(ex);
				ViewData["StatusError"] = ex.Message;
			}
		}
		#endregion
	}
}
