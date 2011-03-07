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
					return Redirect(HttpUtility.UrlDecode(returnUrl ?? "/"));
				}
				ViewData["UserGroup"] = group;
				ViewData["UserGroupName"] = UsersServiceClient.GetGroupName(group.Value);
			}

			return View();
		}

		public ActionResult Logout(string returnUrl)
		{
			Session.User = null;
			IFormsAuthentication formsAuth = new FormsAuthenticationService();
			formsAuth.SignOut();

			if (String.IsNullOrEmpty(returnUrl))
			{
				returnUrl = "/";
			}
			return Redirect(HttpUtility.UrlDecode(returnUrl));
		}

		#region Twitter
		public ActionResult TwitterStartLogin(string returnUrl)
		{
			if (this.User != null)
			{
				return Redirect(returnUrl);
			}
			if (!this.Config.AuthorizationProviders.Twitter.IsDefined)
			{
				return ResultHelper.ForbiddenResult(this);
			}
			//Will redirect to twitter
			SecurityHelper.TwitterStartLogin(this.Cache);

			//Normally the twitter consumer will redirect but it does not end execution.
			return new EmptyResult();
		} 
		#endregion

		#region Facebook
		public ActionResult FacebookReceiver()
		{
			return Static("FacebookXDReceiver", false);
		} 
		#endregion

		#region OpenId
		public ActionResult OpenIdStartLogin(string openidIdentifier, string returnUrl)
		{
			if (!this.Config.AuthorizationProviders.SSOOpenId.IsDefined)
			{
				return ResultHelper.ForbiddenResult(this);
			}

			if (!String.IsNullOrEmpty(this.Config.AuthorizationProviders.SSOOpenId.Identifier))
			{
				openidIdentifier = this.Config.AuthorizationProviders.SSOOpenId.Identifier;
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
			if (!this.Config.AuthorizationProviders.SSOOpenId.IsDefined)
			{
				return ResultHelper.ForbiddenResult(this);
			}
			if (String.IsNullOrEmpty(returnUrl))
			{
				returnUrl = "/";
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
