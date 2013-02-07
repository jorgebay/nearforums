using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NearForums.Web.Controllers.Helpers;
using NearForums.Services;
using NearForums.Web.Extensions;
using DotNetOpenAuth.OpenId;
using System.Net;
using DotNetOpenAuth.OpenId.RelyingParty;
using DotNetOpenAuth.Messaging;
using System.Web.Security;
using Facebook;
using NearForums.Web.State;
using System.Web.Routing;
using NearForums.Validation;
using NearForums.Web.Controllers.Helpers.OAuth;
using DotNetOpenAuth.OAuth.ChannelElements;

namespace NearForums.Web.Controllers
{
	public class AuthenticationController : BaseController
	{
		/// <summary>
		/// User service
		/// </summary>
		private readonly IUsersService _service;
		/// <summary>
		/// App Logger
		/// </summary>
		public readonly ILoggerService _logger;


		public AuthenticationController(IUsersService service, ILoggerService logger)
		{
			_service = service;
			_logger = logger;
		}

		/// <summary>
		/// If the user is not logged in, it ask the user to login using any of the provider.
		/// If the user is logged in and not authorized, it shows a message to the user.
		/// </summary>
		/// <param name="returnUrl"></param>
		/// <param name="group"></param>
		/// <returns>ProviderSelect view result or </returns>
		[HttpGet]
		public ActionResult Login(string returnUrl, UserRole? role)
		{
			if (User != null)
			{
				if (role == null || User.Role >= role)
				{
					return Redirect(returnUrl);
				}
				ViewBag.UserRole = role;
				ViewBag.UserRoleName = _service.GetRoleName(role.Value);
				return View("NotAuthorized");
			}
			if (Config.AuthenticationProviders.CustomDb.IsDefined)
			{
				SpecifyParametersForCustom();
			}
			return View("ProviderSelect");
		}

		public ActionResult Logout(string returnUrl)
		{
			Session.ClearUser();
			FormsAuthentication.SignOut();

			return Redirect(returnUrl);
		}

		#region Twitter
		/// <summary>
		/// Starts the OAuth flow by requesting a token and redirecting to twitter
		/// </summary>
		public ActionResult TwitterStartLogin(string returnUrl)
		{
			if (!this.Config.AuthenticationProviders.Twitter.IsDefined)
			{
				return ResultHelper.ForbiddenResult(this);
			}
			if (this.User != null)
			{
				return Redirect(returnUrl);
			}
			//Set the return url in session
			Session.NextUrl = returnUrl;
			//Will redirect to twitter
			var tokenManager = SecurityHelper.GetTokenManager(Cache, AuthenticationProvider.Twitter, Config.AuthenticationProviders.Twitter);
			try
			{
				TwitterConsumer.StartOAuthFlow(tokenManager, new Uri(new Uri(Domain), Url.Action("TwitterFinishLogin", "Authentication")));
			}
			catch (ProtocolException ex)
			{
				_logger.LogError(ex);
			}

			//Normally the twitter consumer will redirect but it does not end execution.
			return View("TwitterFail");
		}

		/// <summary>
		/// Finish the twitter flow.
		/// </summary>
		/// <returns></returns>
		public ActionResult TwitterFinishLogin()
		{
			if (!this.Config.AuthenticationProviders.Twitter.IsDefined)
			{
				return ResultHelper.ForbiddenResult(this);
			}
			IConsumerTokenManager tokenManager = SecurityHelper.GetTokenManager(Cache, AuthenticationProvider.Twitter, Config.AuthenticationProviders.Twitter);
			long twitterUserId;
			string accessToken;
			if (!TwitterConsumer.TryFinishOAuthFlow(tokenManager, _logger, out twitterUserId, out accessToken))
			{
				return View("TwitterFail");
			}
			var user = _service.GetByProviderId(AuthenticationProvider.Twitter, twitterUserId.ToString());

			if (user == null)
			{
				var twitterUser = TwitterConsumer.GetUserFromCredentials(tokenManager, accessToken);
				user = SecurityHelper.CreateUser(twitterUser);

				user = _service.Add(user, AuthenticationProvider.Twitter, twitterUserId.ToString());
			}

			Session.SetUser(user, AuthenticationProvider.Twitter);
			if (Session.User == null)
			{
				//user is banned or suspended
				return RedirectToAction("Detail", "Users", new { id = user.Id });
			}
			return Redirect(Session.NextUrl);
		}
		#endregion

		#region Facebook OAuth 2.0
		/// <summary>
		/// Starts the authentication flow and redirects to Facebook
		/// </summary>
		public ActionResult FacebookStartLogin(string returnUrl)
		{
			if (!this.Config.AuthenticationProviders.Facebook.IsDefined)
			{
				return ResultHelper.ForbiddenResult(this);
			}
			var oAuthClient = new FacebookOAuthClient();
			oAuthClient.AppId = this.Config.AuthenticationProviders.Facebook.ApiKey;
			oAuthClient.RedirectUri = new Uri(new Uri(Domain), Url.Action("FacebookFinishLogin", "Authentication"));
			var loginUri = oAuthClient.GetLoginUrl(new Dictionary<string, object>(){{"state", Session.SessionToken}});

			Session.NextUrl = returnUrl;
			
			return new RedirectResult(loginUri.AbsoluteUri);
		}

		public ActionResult FacebookFinishLogin(string code, string state)
		{
			if (!this.Config.AuthenticationProviders.Facebook.IsDefined)
			{
				return ResultHelper.ForbiddenResult(this);
			}
			FacebookOAuthResult oauthResult = null;
			if (!(state == Session.SessionToken && FacebookOAuthResult.TryParse(Request.Url, out oauthResult)))
			{
				return ResultHelper.ForbiddenResult(this);
			}
			if (!oauthResult.IsSuccess)
			{
				return ResultHelper.ForbiddenResult(this);
			}
			var oAuthClient = new FacebookOAuthClient();
			oAuthClient.AppId = this.Config.AuthenticationProviders.Facebook.ApiKey;
			oAuthClient.AppSecret = this.Config.AuthenticationProviders.Facebook.SecretKey;
			oAuthClient.RedirectUri = new Uri(Request.Url, Url.Action("FacebookFinishLogin", "Authentication"));
					
			//Could throw an OAuth exception if validation fails.
			dynamic tokenResult = oAuthClient.ExchangeCodeForAccessToken(code);
			string accessToken = tokenResult.access_token;

			DateTime expiresOn = DateTime.MaxValue;
			if (tokenResult.ContainsKey("expires"))
			{
				expiresOn = DateTimeConvertor.FromUnixTime(tokenResult.expires);
			}

			FacebookClient fbClient = new FacebookClient(accessToken);
			dynamic facebookUser = fbClient.Get("me?fields=id,name,first_name,last_name,about,link,birthday,timezone");

			User user = _service.GetByProviderId(AuthenticationProvider.Facebook, facebookUser.id);
			if (user == null)
			{
				//Its a new user for the application
				user = SecurityHelper.CreateUser(facebookUser);
				user = _service.Add(user, AuthenticationProvider.Facebook, facebookUser.id);
			}

			//Log the user in
			Session.SetUser(user, AuthenticationProvider.Facebook);
			if (Session.User == null)
			{
				//user is banned or suspended
				return RedirectToAction("Detail", "Users", new {id=user.Id});
			}
			return Redirect(Session.NextUrl);
		}
		#endregion

		#region OpenId
		/// <summary>
		/// Starts the OpenId flow
		/// </summary>
		public ActionResult OpenIdStartLogin(string openidIdentifier, string returnUrl)
		{
			if (!this.Config.AuthenticationProviders.SSOOpenId.IsDefined)
			{
				return ResultHelper.ForbiddenResult(this);
			}

			if (!String.IsNullOrEmpty(this.Config.AuthenticationProviders.SSOOpenId.Identifier))
			{
				openidIdentifier = this.Config.AuthenticationProviders.SSOOpenId.Identifier;
			}

			Identifier id;
			if (Identifier.TryParse(openidIdentifier, out id))
			{
				//Build openid return urls
				var returnAbsoluteUrl = new Uri(Request.Url, Url.Action("OpenIdFinishLogin", new
				{
					returnUrl = returnUrl
				}));

				var realmUrl = new Uri(Request.Url, "/");

				OpenIdRelyingParty openid = new OpenIdRelyingParty();
				var authenticationRequest = openid.CreateRequest(id, realmUrl, returnAbsoluteUrl);

				return authenticationRequest.RedirectingResponse.AsActionResult();
			}
			throw new FormatException("openid identifier not valid");
		}

		public ActionResult OpenIdFinishLogin(string returnUrl)
		{
			if (!this.Config.AuthenticationProviders.SSOOpenId.IsDefined)
			{
				return ResultHelper.ForbiddenResult(this);
			}

			OpenIdRelyingParty openid = new OpenIdRelyingParty();
			var response = openid.GetResponse();
			if (response == null)
			{
				throw new AuthenticationProviderException("Open Id provider didn't send an assertive response. response null.");
			}
			// OpenID Provider sending assertion response
			switch (response.Status)
			{
				case AuthenticationStatus.Authenticated:
					var userId = SecurityHelper.OpenIdFinishLogin(response, Session, _service);
					if (Session.User == null)
					{
						//User is banned or suspended
						return RedirectToAction("Detail", "Users", new { id = userId });
					}
					return Redirect(returnUrl);
				case AuthenticationStatus.Canceled:
					//Canceled at provider
					//Return to previous url without logged
					return Redirect(returnUrl);
				default:
					throw new AuthenticationProviderException("Authentication Failed. Status = " + response.Status.ToString());
			}
		}
		#endregion

		#region Custom provider
		[HttpGet]
		public ActionResult CustomLogin(string returnUrl)
		{
			if (!Config.AuthenticationProviders.CustomDb.IsDefined)
			{
				return ResultHelper.ForbiddenResult(this);
			}
			SpecifyParametersForCustom();

			return View("LoginFormFull");
		}

		[HttpPost]
		public ActionResult CustomLogin(string userName, string password, string returnUrl)
		{
			if (!Config.AuthenticationProviders.CustomDb.IsDefined)
			{
				return ResultHelper.ForbiddenResult(this);
			}

			try
			{
				var user = _service.AuthenticateWithCustomProvider(userName, password);
				if (user != null)
				{
					var userState = Session.SetUser(user, AuthenticationProvider.CustomDb);
					if (userState == null)
					{
						return RedirectToAction("Detail", "Users", new { id=user.Id});
					}
					userState.ProviderInfo.AllowChangeEmail = Config.AuthenticationProviders.CustomDb.AllowChangeEmail;
					userState.ProviderInfo.EditAccountUrl = Config.AuthenticationProviders.CustomDb.AccountEditUrl;

					return Redirect(returnUrl);
				}
			}
			catch (ValidationException ex)
			{
				AddErrors(ModelState, ex);
			}
			SpecifyParametersForCustom();

			return View("LoginFormFull");
		}

		/// <summary>
		/// Sets the parameters used by the custom authentication provider
		/// </summary>
		public void SpecifyParametersForCustom()
		{
			var provider = Config.AuthenticationProviders.CustomDb;
			ViewBag.ForgotPasswordUrl = provider.ForgotPasswordUrl;
			ViewBag.RegisterUrl = provider.RegisterUrl;
			ViewBag.LoginFormAction = Url.Action("CustomLogin");
			ViewBag.AllowRemember = false;
		}
		#endregion
	}
}
