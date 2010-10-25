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
using NearForums.Web.Controllers.Helpers.OAuth;
using DotNetOpenAuth.OAuth.ChannelElements;
using DotNetOpenAuth.Messaging;
using DotNetOpenAuth.OpenId.RelyingParty;
using DotNetOpenAuth.OpenId;

namespace NearForums.Web.Controllers.Helpers
{
	/// <summary>
	/// Helper for providers authentication. Required HttpContext.
	/// </summary>
	public static class SecurityHelper
	{
		/// <summary>
		/// Checks if a external provider is trying to post a login on this website.
		/// </summary>
		public static bool TryLoginFromProviders(SessionWrapper session, CacheWrapper cache, HttpRequestBase request, HttpResponseBase response)
		{
			bool logged = false;

			if (TryLoginFromFake(session))
			{
				logged = true;
			}
			else if (TryLoginFromFacebook(session, request, response))
			{
				logged = true;
			}
			else if (TryFinishLoginFromTwitter(session, cache))
			{
				logged = true;
			}
			return logged;
		}

		#region Fake login
		/// <summary>
		/// Register/login (if the user exists or not) from a fake user of facebook
		/// </summary>
		/// <param name="session"></param>
		/// <returns></returns>
		private static bool TryLoginFromFake(SessionWrapper session)
		{
			if (SiteConfiguration.Current.AuthorizationProviders.FakeProvider)
			{
				//Fake facebook id
				const int fakeFacebookUserId = -1000;

				User user = UsersServiceClient.GetByProviderId(AuthenticationProvider.Facebook, fakeFacebookUserId.ToString());
				if (user == null)
				{
					//Autoregister
					user = new User(0, "fake user");
					user = UsersServiceClient.Add(user, AuthenticationProvider.Facebook, fakeFacebookUserId.ToString());
				}
				//Log in
				session.User = new UserState(user, AuthenticationProvider.Facebook);
			}
			
			return SiteConfiguration.Current.AuthorizationProviders.FakeProvider;
		} 
	#endregion

		#region Facebook
		public static bool TryLoginFromFacebook(SessionWrapper session, HttpRequestBase request, HttpResponseBase response)
		{
			bool logged = false;
			if (SiteConfiguration.Current.AuthorizationProviders.Facebook != null)
			{
				string apiKey = SiteConfiguration.Current.AuthorizationProviders.Facebook.ApiKey;
				string secretKey = SiteConfiguration.Current.AuthorizationProviders.Facebook.SecretKey;
				ConnectSession connectSession = new ConnectSession(apiKey, secretKey);
				//Checks facebook cookies
				if (connectSession.IsConnected())
				{
					Api facebookApi = new Api(connectSession);
					User user = UsersServiceClient.GetByProviderId(AuthenticationProvider.Facebook, connectSession.UserId.ToString());
					//Check if exist user from facebook
					if (user != null)
					{
						if (IsValidFacebookSignature(apiKey, secretKey, request))
						{
							session.User = new UserState(user, AuthenticationProvider.Facebook);
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

							user = CreateUser(facebookUser);

							user = UsersServiceClient.Add(user, AuthenticationProvider.Facebook, facebookUser.uid.Value.ToString());

							//Log in
							session.User = new UserState(user, AuthenticationProvider.Facebook);
							logged = true;
						}
						catch (FacebookException)
						{
							//The session is not valid / has expired.
							ClearFacebookCookies(request.Cookies, response.Cookies);
						}
					}
				}
			}
			return logged;
		}

		#region Create user
		private static User CreateUser(Facebook.Schema.user facebookUser)
		{
			//Pending field: facebookUser.locale
			User user = new User();
			user.UserName = facebookUser.first_name + " " + facebookUser.last_name;
			user.ExternalProfileUrl = facebookUser.profile_url;
			user.Profile = facebookUser.about_me;
			#region Birthdate
			DateTime? birthDate = null;
			if (birthDate != null)
			{
				DateTime parsedBirthDate = DateTime.MinValue;
				if (DateTime.TryParse(facebookUser.birthday, new CultureInfo("en-US"), DateTimeStyles.AdjustToUniversal, out parsedBirthDate))
				{
					birthDate = parsedBirthDate;
				}
			}
			user.BirthDate = birthDate;
			#endregion
			user.Photo = facebookUser.pic;
			#region Timezone
			if (facebookUser.timezone != null)
			{
				user.TimeZone = TimeSpan.FromHours((double)facebookUser.timezone.Value);
			}
			else
			{
				user.TimeZone = new TimeSpan();
			}
			#endregion

			return user;
		} 
		#endregion

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
		#endregion

		#region OAuth
		#region Token manager
		private static InMemoryTokenManager GetTokenManager(CacheWrapper cache, AuthenticationProvider provider, KeySecretElement providerConfiguration)
		{
			var tokenManager = (InMemoryTokenManager)cache.Cache[provider.ToString() + "TokenManager"];
			if (tokenManager == null)
			{
				tokenManager = new InMemoryTokenManager(providerConfiguration.ApiKey, providerConfiguration.SecretKey);
				cache.Cache[provider.ToString() + "TokenManager"] = tokenManager;
			}

			return tokenManager;
		} 
		#endregion

		#region Twitter
		public static void TwitterStartLogin(CacheWrapper cache)
		{
			IConsumerTokenManager tokenManager = GetTokenManager(cache, AuthenticationProvider.Twitter, SiteConfiguration.Current.AuthorizationProviders.Twitter);
			TwitterConsumer.StartOAuthFlow(tokenManager);
		}

		private static bool TryFinishLoginFromTwitter(SessionWrapper session, CacheWrapper cache)
		{
			bool logged = false;
			if (SiteConfiguration.Current.AuthorizationProviders.Twitter.IsDefined)
			{
				IConsumerTokenManager tokenManager = GetTokenManager(cache, AuthenticationProvider.Twitter, SiteConfiguration.Current.AuthorizationProviders.Twitter);
				long twitterUserId;
				string accessToken;
				if (TwitterConsumer.TryFinishOAuthFlow(tokenManager, true, out twitterUserId, out accessToken))
				{
					User user = UsersServiceClient.GetByProviderId(AuthenticationProvider.Twitter, twitterUserId.ToString());

					if (user == null)
					{
						TwitterConsumer.TwitterUser twitterUser = TwitterConsumer.GetUserFromCredentials(tokenManager, accessToken);
						user = CreateUser(twitterUser);

						user = UsersServiceClient.Add(user, AuthenticationProvider.Twitter, twitterUserId.ToString());
					}

					
					session.User = new UserState(user, AuthenticationProvider.Twitter);
					logged = true;
					//Redirect to the same page without oauth params.
					//Response.Redirect(Request.Url.StripQueryArgumentsWithPrefix("oauth_").ToString());
				}
			}
			return logged;
		}

		private static User CreateUser(TwitterConsumer.TwitterUser twitterUser)
		{
			User user = new User();
			user.UserName = twitterUser.Name;
			user.ExternalProfileUrl = twitterUser.ProfileUrl;
			user.Photo = twitterUser.ProfileImageUrl;
			user.Profile = twitterUser.Description;
			user.TimeZone = TimeSpan.FromHours((double)twitterUser.TimeZone);

			return user;
		}
		#endregion
		#endregion

		#region OpenId
		/// <summary>
		/// Logs the user in or creates the user account if the user does not exist.
		/// Sets the logged user in the session.
		/// </summary>
		public static bool OpenIdFinishLogin(IAuthenticationResponse response, SessionWrapper session)
		{
			string externalId = response.ClaimedIdentifier.ToString();
			string name = response.FriendlyIdentifierForDisplay;
			User user = UsersServiceClient.GetByProviderId(AuthenticationProvider.OpenId, externalId);

			if (user == null)
			{
				user = new User(0, name);
				user = UsersServiceClient.Add(user, AuthenticationProvider.OpenId, externalId);
			}
			
			session.User = new UserState(user, AuthenticationProvider.OpenId);

			return true;
		} 
		#endregion
	}
}
