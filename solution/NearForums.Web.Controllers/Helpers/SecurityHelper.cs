using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.ServiceClient;
using Facebook.Session;
using Facebook.Rest;
using NearForums.Web.State;
using System.Web.SessionState;
using System.Web;
using NearForums.Configuration;
using Facebook.Utility;
using System.Configuration;
using System.Globalization;
using System.Security.Cryptography;

namespace NearForums.Web.Controllers.Helpers
{
	public static class SecurityHelper
	{
		/// <summary>
		/// Checks if a external provider is trying to post a login on this website.
		/// </summary>
		public static bool TryLoginFromProviders(SessionWrapper session, HttpRequestBase request, HttpResponseBase response)
		{
			return TryLoginFromFacebook(session, request, response);
		}

		private static bool TryLoginFromFacebook(SessionWrapper session, HttpRequestBase request, HttpResponseBase response)
		{
			bool logged = false;
			string apiKey = SiteConfiguration.Current.AuthorizationProviders.Facebook.ApiKey;
			string secretKey = SiteConfiguration.Current.AuthorizationProviders.Facebook.SecretKey;
			ConnectSession connectSession = new ConnectSession(apiKey, secretKey);
			//Checks facebook cookies
			if (connectSession.IsConnected())
			{
				Api facebookApi = new Api(connectSession);
				User user = UsersServiceClient.GetByFacebookId(connectSession.UserId);
				//Check if exist user from facebook
				if (user != null)
				{
					if (IsValidFacebookSignature(apiKey, secretKey, request))
					{
						session.User = new UserState(user);
						logged = true;
					}
					else
					{
						ClearFacebookCookies(request.Cookies, response.Cookies);
					}
				}
				else
				{
					try
					{
						Facebook.Schema.user facebookUser = facebookApi.Users.GetInfo();

						//Autoregister
						user = UsersServiceClient.AddUserFromFacebook(facebookUser.uid.Value, facebookUser.first_name, facebookUser.last_name, facebookUser.profile_url, facebookUser.about_me, facebookUser.birthday, facebookUser.locale, facebookUser.pic, facebookUser.timezone, null);

						//Log in
						session.User = new UserState(user);
						logged = true;
					}
					catch (FacebookException)
					{
						//The session is not valid / has expired.
						ClearFacebookCookies(request.Cookies, response.Cookies);
					}
				}
			}
			return logged;
		}

		#region Validate facebook signature
		/// <summary>
		/// Validates the facebook data agains secret key
		/// </summary>
		private static bool IsValidFacebookSignature(string apiKey, string secretKey, HttpRequestBase request)
		{
			//keys must remain in alphabetical order
			string[] keyArray = { "expires", "session_key", "ss", "user" };
			string signature = "";

			foreach (string key in keyArray)
			{
				signature += string.Format("{0}={1}", key, GetFacebookCookie(apiKey, key, request));
			}

			signature += secretKey; 

			MD5 md5 = MD5.Create();
			byte[] hash = md5.ComputeHash(Encoding.UTF8.GetBytes(signature.Trim()));

			StringBuilder sb = new StringBuilder();
			foreach (byte hashByte in hash)
			{
				sb.Append(hashByte.ToString("x2", CultureInfo.InvariantCulture));
			}

			return (GetFacebookCookie(apiKey, "", request) == sb.ToString());
		}

		private static string GetFacebookCookie(string apiKey, string cookieName, HttpRequestBase request)
		{
			//APIKey issued by FB
			string fullCookie = string.IsNullOrEmpty(cookieName) ? apiKey : apiKey + "_" + cookieName;

			return request.Cookies[fullCookie].Value;
		} 
		#endregion

		/// <summary>
		/// Clears all cookie information with the facebook apiKey + Name format.
		/// </summary>
		private static void ClearFacebookCookies(HttpCookieCollection requestCookies, HttpCookieCollection responseCookies)
		{
			//Set all cookies from the user browser as expired
			string[] cookieKeys = requestCookies.AllKeys;
			foreach (string key in cookieKeys)
			{
				if (key.Contains(SiteConfiguration.Current.AuthorizationProviders.Facebook.ApiKey))
				{
					HttpCookie cookie = requestCookies[key];

					cookie.Expires = DateTime.Now.AddDays(-1d);
					responseCookies.Add(cookie);
				}
			}
		}
	}
}
