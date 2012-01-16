using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NearForums.Web.Controllers.Helpers;
using NearForums.ServiceClient;
using NearForums.Web.Extensions;
using DotNetOpenAuth.OpenId;
using System.Net;
using DotNetOpenAuth.OpenId.RelyingParty;
using DotNetOpenAuth.Messaging;
using System.Web.Security;
using NearForums.Web.Extensions.FormsAuthenticationHelper;
using NearForums.Web.Extensions.FormsAuthenticationHelper.Impl;
using Facebook;
using NearForums.Web.State;
using System.Web.Routing;

namespace NearForums.Web.Controllers
{
	public class AuthenticationController : BaseController
	{
		public ActionResult Login(string returnUrl, UserGroup? group)
		{
			if (User != null)
			{
				if (group == null || User.Group >= group)
				{
					return Redirect(returnUrl);
				}
				ViewBag.UserGroup = group;
				ViewBag.UserGroupName = UsersServiceClient.GetGroupName(group.Value);
			}
			ViewBag.ReturnUrl = returnUrl;
			return View();
		}

		public ActionResult Logout(string returnUrl)
		{
			Session.User = null;
			IFormsAuthentication formsAuth = new FormsAuthenticationService();
			formsAuth.SignOut();

			return Redirect(returnUrl);
		}

		#region Twitter
		public ActionResult TwitterStartLogin(string returnUrl)
		{
			if (this.User != null)
			{
				return Redirect(returnUrl);
			}
			if (!this.Config.AuthenticationProviders.Twitter.IsDefined)
			{
				return ResultHelper.ForbiddenResult(this);
			}
			//Will redirect to twitter
			SecurityHelper.TwitterStartLogin(this.Cache);

			//Normally the twitter consumer will redirect but it does not end execution.
			return new EmptyResult();
		} 
		#endregion

		#region Facebook OAuth 2.0
		public ActionResult FacebookStartLogin(string returnUrl)
		{
			if (!this.Config.AuthenticationProviders.Facebook.IsDefined)
			{
				return ResultHelper.ForbiddenResult(this);
			}
			var oAuthClient = new FacebookOAuthClient();
			oAuthClient.AppId = this.Config.AuthenticationProviders.Facebook.ApiKey;
			oAuthClient.RedirectUri = new Uri(Request.Url, Url.Action("FacebookFinishLogin", "Authentication"));
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
			FacebookOAuthResult oauthResult;
			if (state == Session.SessionToken && FacebookOAuthResult.TryParse(Request.Url, out oauthResult))
			{
				if (oauthResult.IsSuccess)
				{
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
					
					User user = UsersServiceClient.GetByProviderId(AuthenticationProvider.Facebook, facebookUser.id);
					if (user == null)
					{
						//Its a new user for the application
						user = SecurityHelper.CreateUser(facebookUser);
						user = UsersServiceClient.Add(user, AuthenticationProvider.Facebook, facebookUser.id);
					}

					//Log the user in
					Session.User = new UserState(user, AuthenticationProvider.Facebook);
				}
			}

			return Redirect(Session.NextUrl);
		}
		#endregion

		#region OpenId
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
				#region Build openid return urls
				var returnAbsoluteUrl = new Uri(Request.Url, Url.Action("OpenIdFinishLogin", new
				{
					returnUrl = returnUrl
				}));

				var realmUrl = new Uri(Request.Url, "/");
				#endregion

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
					SecurityHelper.OpenIdFinishLogin(response, Session);

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
	}
}
