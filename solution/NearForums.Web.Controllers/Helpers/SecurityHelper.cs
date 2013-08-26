using System;
using DotNetOpenAuth.OpenId.Extensions.SimpleRegistration;
using NearForums.Web.State;
using System.Web;
using NearForums.Configuration;
using System.Globalization;
using NearForums.Web.Controllers.Helpers.OAuth;
using DotNetOpenAuth.OAuth.ChannelElements;
using DotNetOpenAuth.OpenId.RelyingParty;
using System.Web.Security;
using NearForums.Services;

namespace NearForums.Web.Controllers.Helpers
{
	/// <summary>
	/// Helper for providers authentication. Required HttpContext.
	/// </summary>
	public static class SecurityHelper
	{
		#region Facebook

		#region Create user
		/// <summary>
		/// Creates a new instance of nearforums user with properties from a facebook User
		/// </summary>
		public static User CreateUser(dynamic facebookUser)
		{
			//Full facebook documentation: http://developers.facebook.com/docs/reference/api/user/
			User user = new User();
			user.UserName = facebookUser.first_name + " " + facebookUser.last_name;
			user.ExternalProfileUrl = facebookUser.link;
			user.Profile = facebookUser.about;
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
			#region Timezone
			if (facebookUser.timezone != null)
			{
				user.TimeZone = TimeSpan.FromHours((double)facebookUser.timezone);
			}
			else
			{
				user.TimeZone = new TimeSpan();
			}
			#endregion
			#region Picture
			user.Photo = String.Format("http://graph.facebook.com/{0}/picture?type=normal", facebookUser.id);
			#endregion

			return user;
		}
		#endregion
		#endregion

		#region OAuth
		#region Token manager
		internal static InMemoryTokenManager GetTokenManager(CacheWrapper cache, AuthenticationProvider provider, KeySecretElement providerConfiguration)
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
		//public static bool TryFinishLoginFromTwitter(SessionWrapper session, CacheWrapper cache, IUsersService service)
		//{
		//    bool logged = false;
		//    if (SiteConfiguration.Current.AuthenticationProviders.Twitter.IsDefined)
		//    {
		//        IConsumerTokenManager tokenManager = GetTokenManager(cache, AuthenticationProvider.Twitter, SiteConfiguration.Current.AuthenticationProviders.Twitter);
		//        long twitterUserId;
		//        string accessToken;
		//        if (TwitterConsumer.TryFinishOAuthFlow(tokenManager, true, out twitterUserId, out accessToken))
		//        {
		//            var user = service.GetByProviderId(AuthenticationProvider.Twitter, twitterUserId.ToString());

		//            if (user == null)
		//            {
		//                TwitterConsumer.TwitterUser twitterUser = TwitterConsumer.GetUserFromCredentials(tokenManager, accessToken);
		//                user = CreateUser(twitterUser);

		//                user = service.Add(user, AuthenticationProvider.Twitter, twitterUserId.ToString());
		//            }

		//            session.SetUser(user, AuthenticationProvider.Twitter);
		//            logged = true;
		//            //Redirect to the same page without oauth params.
		//            //Response.Redirect(Request.Url.StripQueryArgumentsWithPrefix("oauth_").ToString());
		//        }
		//    }
		//    return logged;
		//}

		public static User CreateUser(TwitterConsumer.TwitterUser twitterUser)
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
		public static int OpenIdFinishLogin(IAuthenticationResponse response, SessionWrapper session, IUsersService service, bool enableClaimsRequest)
		{
			string externalId = response.ClaimedIdentifier.ToString();
			User user = service.GetByProviderId(AuthenticationProvider.OpenId, externalId);
			
			var claimsResponse = response.GetExtension<ClaimsResponse>();
			string name = enableClaimsRequest ? claimsResponse.Nickname : response.FriendlyIdentifierForDisplay;

			if (user == null)
			{
				user = new User(0, name);

				if (enableClaimsRequest)
				{
					user.Email = claimsResponse.Email;
					user.BirthDate = claimsResponse.BirthDate;
				}

				user = service.Add(user, AuthenticationProvider.OpenId, externalId);
			}
			else 
			{
				if (enableClaimsRequest && !claimsResponse.Email.Equals(user.Email, StringComparison.CurrentCultureIgnoreCase))
				{
					user.Email = claimsResponse.Email;
					service.Edit(user);
				}
			}

			session.SetUser(user, AuthenticationProvider.OpenId);

			return user.Id;
		}
		#endregion

		#region Membership
		/// <summary>
		/// If enabled by configuration, tries to login the current membership user (reading cookie / identity) as nearforums user
		/// </summary>
		/// <returns>The user id of the authenticated user, if not -1</returns>
		public static int TryFinishMembershipLogin(HttpContextBase context, SessionWrapper session, MembershipProvider provider, IUsersService service)
		{
			if (provider == null || String.IsNullOrEmpty(context.User.Identity.Name))
			{
				return -1;
			}
			var membershipUser = provider.GetUser(context.User.Identity.Name, true);
			return TryFinishMembershipLogin(session, membershipUser, service);
		}

		/// <summary>
		/// Logs the user in or creates the a site user account if the user does not exist, based on membership user.
		/// Sets the logged user in the session.
		/// </summary>
		/// <exception cref="ValidationException"></exception>
		/// <returns>The user id of the authenticated user</returns>
		public static int TryFinishMembershipLogin(SessionWrapper session, MembershipUser membershipUser, IUsersService service)
		{
			if (membershipUser == null)
			{
				throw new ArgumentNullException("Can not finish membership signin with membership not set.");
			}
			var siteUser = service.GetByProviderId(AuthenticationProvider.Membership, membershipUser.ProviderUserKey.ToString());

			if (siteUser == null)
			{
				//User does not exist on Nearforums db
				siteUser = new User();
				siteUser.UserName = membershipUser.UserName;
				siteUser.Email = membershipUser.Email;
				siteUser = service.Add(siteUser, AuthenticationProvider.Membership, membershipUser.ProviderUserKey.ToString());
			}
			session.SetUser(siteUser, AuthenticationProvider.Membership);

			return siteUser.Id;
		}
		#endregion
	}
}
