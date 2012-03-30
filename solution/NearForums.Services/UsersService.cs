using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;
using NearForums.Validation;
using System.Text.RegularExpressions;


namespace NearForums.Services
{
	public class UsersService : IUsersService
	{
		/// <summary>
		/// User repository
		/// </summary>
		private readonly IUsersDataAccess dataAccess;
		/// <summary>
		/// Repository for custom authentication provider
		/// </summary>
		private readonly ICustomAuthenticationDataAccess customAuthenticationDataAccess;

		public UsersService(IUsersDataAccess da, ICustomAuthenticationDataAccess customAuthenticationDa)
		{
			dataAccess = da;
			customAuthenticationDataAccess = customAuthenticationDa;
		}

		public User GetByProviderId(AuthenticationProvider provider, string providerId)
		{
			return dataAccess.GetByProviderId(provider, providerId);
		}

		public User GetByPasswordResetGuid(AuthenticationProvider provider, string PasswordResetGuid)
		{
			return dataAccess.GetByPasswordResetGuid(provider, PasswordResetGuid);
		}

		public User GetTestUser()
		{
			return dataAccess.GetTestUser();
		}

		/// <exception cref="ValidationException"></exception>
		public User Add(User user, AuthenticationProvider provider, string providerId)
		{
			user.ValidateFields();

			return dataAccess.AddUser(user, provider, providerId);
		}

		public List<User> GetAll()
		{
			return dataAccess.GetAll();
		}

		public List<User> GetByName(string userName)
		{
			return dataAccess.GetByName(userName);
		}

		public void Delete(int id)
		{
			UsersDataAccess da = new UsersDataAccess();
			dataAccess.Delete(id);
		}

		public void Promote(int id)
		{
			dataAccess.Promote(id);
		}

		public void Demote(int id)
		{
			dataAccess.Demote(id);
		}

		public User Get(int userId)
		{
			return dataAccess.Get(userId);
		}

		public string GetRoleName(UserRole userRole)
		{
			return dataAccess.GetRoleName(userRole);
		}

		/// <exception cref="ValidationException"></exception>
		public void Edit(User user)
		{
			user.ValidateFields();
			dataAccess.Edit(user);
		}

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
			dataAccess.AddEmail(id, email, policy);
		}

		public void UpdatePasswordResetGuid(int id, string Guid, DateTime expireDate)
		{
			dataAccess.UpdatePasswordResetGuid(id, Guid, expireDate);
		}

		public User AuthenticateWithCustomProvider(string userName, string password)
		{
			User user = null;
			ValidateUserAndPassword(userName, password);

			var providerUser = customAuthenticationDataAccess.GetUser(userName, password);
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

		public Dictionary<UserRole, string> GetRoles()
		{
			return dataAccess.GetRoles();
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
	}
}
