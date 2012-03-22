using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums;

namespace NearForums.DataAccess
{
	public interface IUsersDataAccess
	{
		void AddEmail(int id, string email, EmailPolicy policy);
		User AddUser(User user, AuthenticationProvider provider, string providerId);
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
		void UpdatePasswordResetGuid(int id, string Guid, DateTime expireDate);
	}
}
