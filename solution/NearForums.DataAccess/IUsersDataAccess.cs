using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums;

namespace NearForums.DataAccess
{
	/// <summary>
	/// Represents the repository for the user
	/// </summary>
	public interface IUsersDataAccess
	{
		void AddEmail(int id, string email, EmailPolicy policy);
		User AddUser(User user, AuthenticationProvider provider, string providerId);
		bool Ban(int id, int moderatorId, ModeratorReason reason, string reasonText);
		void Delete(int id);
		void Demote(int id);
		void Edit(User user);
		User Get(int userId);
		List<User> GetAll();
		List<User> GetByName(string userName);
		User GetByPasswordResetGuid(AuthenticationProvider provider, string PasswordResetGuid);
		User GetByProviderId(AuthenticationProvider provider, string providerId);
		string GetRoleName(UserRole userRole);
		System.Collections.Generic.Dictionary<UserRole, string> GetRoles();
		User GetTestUser();
		void Promote(int id);
		bool Suspend(int id, int moderatorId, ModeratorReason reason, string reasonText, DateTime endDate);
		void UpdatePasswordResetGuid(int id, string Guid, DateTime expireDate);
		bool Warn(int id, int moderatorId, ModeratorReason reason, string reasonText);
	}
}
