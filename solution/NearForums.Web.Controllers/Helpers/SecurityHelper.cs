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

namespace NearForums.Web.Controllers.Helpers
{
	public static class SecurityHelper
	{
		/// <summary>
		/// Checks if a external provider is trying to post a login on this website.
		/// </summary>
		public static bool TryLoginFromProviders(SessionWrapper session)
		{
			return TryLoginFromFacebook(session);
		}

		private static bool TryLoginFromFacebook(SessionWrapper session)
		{
			string apiKey = SiteConfiguration.Current.Facebook.ApiKey;
			string secretKey = SiteConfiguration.Current.Facebook.SecretKey;
			ConnectSession connectSession = new ConnectSession(apiKey, secretKey);
			if (!connectSession.IsConnected())
			{
				//No params from facebook
				return false;
			}
			else
			{
				User user = UsersServiceClient.GetByFacebookId(connectSession.UserId); 
				//Check if exist user from facebook
				if (user != null)
				{
					//Log in
					session.User = new UserState(user);
				}
				else
				{
					//Autoregister
					Api facebookApi = new Api(connectSession);
					Facebook.Schema.user facebookUser = facebookApi.Users.GetInfo();

					user = UsersServiceClient.AddUserFromFacebook(facebookUser.uid.Value, facebookUser.first_name, facebookUser.last_name, facebookUser.profile_url, facebookUser.about_me, facebookUser.birthday, facebookUser.locale, facebookUser.pic, facebookUser.timezone, null);

					//Log in
					session.User = new UserState(user);

				}
				return true;

			}
		}
	}
}
