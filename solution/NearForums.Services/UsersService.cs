using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;
using NearForums.Validation;
using System.Text.RegularExpressions;
using NearForums.Configuration;


namespace NearForums.Services
{
	public class UsersService : IUsersService
	{
		/// <summary>
		/// User repository
		/// </summary>
		private readonly IUsersDataAccess _dataAccess;
		/// <summary>
		/// Repository for custom authentication provider
		/// </summary>
		private readonly ICustomAuthenticationDataAccess _customAuthenticationDataAccess;
		/// <summary>
		/// Notifications service
		/// </summary>
		private readonly INotificationsService _notificationService;

		public UsersService(IUsersDataAccess da, ICustomAuthenticationDataAccess customAuthenticationDa, INotificationsService notificationService)
		{
			_dataAccess = da;
			_customAuthenticationDataAccess = customAuthenticationDa;
			_notificationService = notificationService;
		}

		public User GetByProviderId(AuthenticationProvider provider, string providerId)
		{
			return _dataAccess.GetByProviderId(provider, providerId);
		}

		public User GetByPasswordResetGuid(AuthenticationProvider provider, string PasswordResetGuid)
		{
			return _dataAccess.GetByPasswordResetGuid(provider, PasswordResetGuid);
		}

		public User GetTestUser()
		{
			return _dataAccess.GetTestUser();
		}

		/// <exception cref="ValidationException">
		/// Throws ValidationException when user fields are invalid
		/// </exception>
		public User Add(User user, AuthenticationProvider provider, string providerId)
		{
			user.ValidateFields();

			return _dataAccess.AddUser(user, provider, providerId);
		}

		/// <exception cref="ValidationException">
		/// Throws ValidationException when email is invalid (null or not email)
		/// </exception>
		public void AddEmail(int id, string email, EmailPolicy policy)
		{
			#region Validate Email
			//To get the same regex used in all the site.
			var regexAttribute = new EmailFormatAttribute();
			if (String.IsNullOrEmpty(email))
			{
				throw new ValidationException(new ValidationError("email", ValidationErrorType.NullOrEmpty));
			}
			else if (!Regex.IsMatch(email, regexAttribute.Regex, regexAttribute.RegexOptions))
			{
				throw new ValidationException(new ValidationError("email", ValidationErrorType.Format));
			}
			#endregion
			_dataAccess.AddEmail(id, email, policy);
		}

		/// <exception cref="ValidationException"></exception>
		public User AuthenticateWithCustomProvider(string userName, string password)
		{
			User user = null;
			ValidateUserAndPassword(userName, password);

			var providerUser = _customAuthenticationDataAccess.GetUser(userName, password);
			if (providerUser != null)
			{
				user = GetByProviderId(AuthenticationProvider.CustomDb, providerUser.Id.ToString());
				if (user == null)
				{
					user = Add(providerUser, AuthenticationProvider.CustomDb, providerUser.Id.ToString());
				}
			}
			else
			{
				throw new ValidationException(new ValidationError("userName", ValidationErrorType.CompareNotMatch));
			}

			return user;
		}

		public void Delete(int id)
		{
			UsersDataAccess da = new UsersDataAccess();
			_dataAccess.Delete(id);
		}

		public void Demote(int id)
		{
			_dataAccess.Demote(id);
		}

		/// <exception cref="ValidationException"></exception>
		public void Edit(User user)
		{
			user.ValidateFields();
			_dataAccess.Edit(user);
		}

		public List<User> GetAll()
		{
			return _dataAccess.GetAll();
		}

		public List<User> GetByName(string userName)
		{
			return _dataAccess.GetByName(userName);
		}

		public User Get(int userId)
		{
			return _dataAccess.Get(userId);
		}

		public string GetGravatarImageUrl(User user)
		{
			if (user == null)
			{
				throw new ArgumentNullException("user");
			}
			if (user.Email == null)
			{
				return null;
			}
			const string url = "https://www.gravatar.com/avatar/{0}?s=48&r=pg";
			var emailHash = Utils.GetMd5Hash(user.Email, Encoding.ASCII);

			return String.Format(url, emailHash);
		}

		public string GetRoleName(UserRole userRole)
		{
			return _dataAccess.GetRoleName(userRole);
		}

		public Dictionary<UserRole, string> GetRoles()
		{
			return _dataAccess.GetRoles();
		}

		/// <summary>
		/// Determines if a user exist of the application
		/// </summary>
		/// <returns></returns>
		public bool IsThereAnyUser()
		{
			bool result = false;
			try
			{
				if (GetTestUser() != null)
				{
					result = true;
				}
			}
			catch
			{
			}
			return result;
		}

		public void Promote(int id)
		{
			_dataAccess.Promote(id);
		}

		public void ResetPassword(string membershipKey, string guid, string linkUrl)
		{
			var user = GetByProviderId(AuthenticationProvider.Membership, membershipKey);
			_dataAccess.UpdatePasswordResetGuid(user.Id, guid, DateTime.Now.AddHours(SiteConfiguration.Current.AuthenticationProviders.FormsAuth.TimeToExpireResetPasswordLink));
			_notificationService.SendResetPassword(user, linkUrl);
		}

		public void ValidateUserAndPassword(string userName, string password)
		{
			var errors = new List<ValidationError>();
			if (String.IsNullOrWhiteSpace(userName))
			{
				errors.Add(new ValidationError("userName", ValidationErrorType.NullOrEmpty));
			}
			if (String.IsNullOrWhiteSpace(password))
			{
				errors.Add(new ValidationError("password", ValidationErrorType.NullOrEmpty));
			}
			if (errors.Count > 0)
			{
				throw new ValidationException(errors);
			}
		}
	}
}
