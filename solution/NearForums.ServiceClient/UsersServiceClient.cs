using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;
using NearForums.Validation;
using System.Text.RegularExpressions;

namespace NearForums.ServiceClient
{
	public static class UsersServiceClient
	{
		public static User GetByProviderId(AuthenticationProvider provider, string providerId)
		{
			UsersDataAccess da = new UsersDataAccess();
			return da.GetByProviderId(provider, providerId);
		}

		public static User GetByPasswordResetGuid(AuthenticationProvider provider, string PasswordResetGuid)
		{
			UsersDataAccess da = new UsersDataAccess();
			return da.GetByPasswordResetGuid(provider, PasswordResetGuid);
		}

		public static User GetTestUser()
		{
			UsersDataAccess da = new UsersDataAccess();
			return da.GetTestUser();
		}

		/// <exception cref="ValidationException"></exception>
		public static User Add(User user, AuthenticationProvider provider, string providerId)
		{
			user.ValidateFields();

			UsersDataAccess da = new UsersDataAccess();
			return da.AddUser(user, provider, providerId);
		}

		public static List<User> GetAll()
		{
			UsersDataAccess da = new UsersDataAccess();
			return da.GetAll();
		}

		public static List<User> GetByName(string userName)
		{
			UsersDataAccess da = new UsersDataAccess();
			return da.GetByName(userName);
		}

		public static void Delete(int id)
		{
			UsersDataAccess da = new UsersDataAccess();
			da.Delete(id);
		}

		/// <summary>
		/// Assigns the next (up) user group to the user
		/// </summary>
		public static void Promote(int id)
		{
			UsersDataAccess da = new UsersDataAccess();
			da.Promote(id);
		}

		/// <summary>
		/// Assigns the previous (down) user group to the user
		/// </summary>
		public static void Demote(int id)
		{
			UsersDataAccess da = new UsersDataAccess();
			da.Demote(id);
		}

		public static User Get(int userId)
		{
			UsersDataAccess da = new UsersDataAccess();
			return da.Get(userId);
		}

		public static string GetRoleName(UserRole userRole)
		{
			UsersDataAccess da = new UsersDataAccess();
			return da.GetRoleName(userRole);
		}
		
		/// <exception cref="ValidationException"></exception>
		public static void Edit(User user)
		{
			user.ValidateFields();
			UsersDataAccess da = new UsersDataAccess();

			da.Edit(user);
		}

		/// <summary>
		/// Add the email address to the user profile.
		/// </summary>
		/// <exception cref="ValidationException"></exception>
		public static void AddEmail(int id, string email, EmailPolicy policy)
		{
			#region Validate Email
			var regexAttribute = new EmailFormatAttribute(); //To get the same regex used in all the site.
			if (String.IsNullOrEmpty(email))
			{
				throw new ValidationException(new ValidationError("email", ValidationErrorType.NullOrEmpty));
			}
			else if (!Regex.IsMatch(email, regexAttribute.Regex, regexAttribute.RegexOptions))
			{
				throw new ValidationException(new ValidationError("email", ValidationErrorType.Format));
			} 
			#endregion
			UsersDataAccess da = new UsersDataAccess();
			da.AddEmail(id, email, policy);
		}

		/// <summary>
		/// Updates the user's password reset temporary Guid used for password reset purposes
		/// </summary>
		/// <param name="id">UserId</param>
		/// <param name="Guid">PasswordResetGuid</param>
		/// <param name="expireDate">PasswordResetGuidExpireDate</param>
		public static void UpdatePasswordResetGuid(int id, string Guid, DateTime expireDate)
		{
			UsersDataAccess da = new UsersDataAccess();
			da.UpdatePasswordResetGuid(id, Guid, expireDate);
		}

		/// <summary>
		/// Tries to authenticate against the custom provider. If success, it gets or creates an application user
		/// </summary>
		/// <returns></returns>
		/// <exception cref="ValidationException">Throws a ValidationException when userName and/or password are empty</exception>
		public static User AuthenticateWithCustomProvider(string userName, string password)
		{
			User user = null;
			ValidateUserAndPassword(userName, password);

			var customProviderDataAccess = new CustomAuthenticationDataAccess();
			var providerUser = customProviderDataAccess.GetUser(userName, password);
			if (providerUser != null)
			{
				user = GetByProviderId(AuthenticationProvider.Custom, providerUser.Id.ToString());
				if (user == null)
				{
					user = Add(providerUser, AuthenticationProvider.Custom, providerUser.Id.ToString());
				}
			}
			else
			{
				throw new ValidationException(new ValidationError("userName", ValidationErrorType.CompareNotMatch));
			}

			return user;
		}

		/// <summary>
		/// Validates username and password
		/// </summary>
		/// <exception cref="ValidationException">Throws a ValidationException when userName and/or password are empty</exception>
		public static void ValidateUserAndPassword(string userName, string password)
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

		/// <summary>
		/// Gets a dictionary containing the user roles and its names.
		/// </summary>
		/// <returns></returns>
		public static Dictionary<UserRole, string> GetRoles()
		{
			var da = new UsersDataAccess();
			return da.GetRoles();
		}
	}
}
