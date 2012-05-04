using System;
using NearForums;
using System.Collections.Generic;

namespace NearForums.Services
{
	public interface IUsersService
	{
		User Add(User user, AuthenticationProvider provider, string providerId);
		/// <summary>
		/// Add the email address to the user profile.
		/// </summary>
		/// <exception cref="ValidationException"></exception>
		void AddEmail(int id, string email, EmailPolicy policy);
		/// <summary>
		/// Tries to authenticate against the custom provider. If success, it gets or creates an application user
		/// </summary>
		/// <returns></returns>
		/// <exception cref="ValidationException">Throws a ValidationException when userName and/or password are empty</exception>
		User AuthenticateWithCustomProvider(string userName, string password);
		void Delete(int id);
		/// <summary>
		/// Assigns the previous (down) user group to the user
		/// </summary>
		void Demote(int id);
		void Edit(User user);
		User Get(int userId);
		List<User> GetAll();
		List<User> GetByName(string userName);
		User GetByPasswordResetGuid(AuthenticationProvider provider, string PasswordResetGuid);
		User GetByProviderId(AuthenticationProvider provider, string providerId);
		string GetRoleName(UserRole userRole);
		/// <summary>
		/// Gets a dictionary containing the user roles and its names.
		/// </summary>
		/// <returns></returns>
		Dictionary<UserRole, string> GetRoles();
		User GetTestUser();
		bool IsThereAnyUser();
		/// <summary>
		/// Assigns the next (up) user group to the user
		/// </summary>
		void Promote(int id);
		/// <summary>
		/// Validates username and password
		/// </summary>
		/// <exception cref="ValidationException">Throws a ValidationException when userName and/or password are empty</exception>
		void ValidateUserAndPassword(string userName, string password);
		/// <summary>
		/// Determines that username is valid
		/// </summary>
		/// <exception cref="ValidationException">Throws a ValidationException when userName and/or password are empty</exception>
		void ValidateUsername(string userName);
		/// <summary>
		/// Updates the user's password reset temporary Guid used for password reset purposes and sends an email to the user
		/// </summary>
		/// <param name="membershipKey"></param>
		/// <param name="guid"></param>
		/// <param name="linkUrl">Url of the page to set the new password</param>
		void ResetPassword(string membershipKey, string guid, string linkUrl);
	}
}
