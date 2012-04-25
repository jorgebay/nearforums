using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Security.Principal;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using System.Web.UI;
using NearForums.Web.Controllers.Helpers;
using NearForums.Web.Extensions.FormsAuthenticationHelper;
using NearForums.Web.Extensions.FormsAuthenticationHelper.Impl;
using NearForums.Web.Extensions;
using NearForums.ServiceClient;
using NearForums.Validation;
using NearForums.Configuration;
using System.Configuration;
using NearForums.Web.Controllers.Filters;

namespace NearForums.Web.Controllers
{
	[HandleError]
	[ValidateFormsAuth]
	public class FormsAuthenticationController : BaseController
	{
		//TODO: Replace membership.getuser using provider key.
		//TODO: Extend so every provider is allowed (not only forms).

		private MembershipProvider _provider;
		protected virtual MembershipProvider Provider
		{
			get
			{
				if (_provider == null)
				{
					_provider = Membership.Provider;
				}
				return _provider;
			}
			set
			{
				_provider = value;
			}
		}

		//TODO: change implementation
		public IFormsAuthentication FormsAuth
		{
			get
			{
				throw new NotImplementedException();
			}
		}

		public FormsAuthenticationController()
		{

		}

		[HttpGet]
		public ActionResult Login(string returnUrl)
		{
			if (this.User != null)
			{
				return Redirect(returnUrl);
			}

			return View("LoginFormFull");
		}

		[HttpPost]
		public ActionResult Login(string userName, string password, bool rememberMe, string returnUrl)
		{
			try
			{
				ValidateLogOn(userName, password);
				FormsAuth.SignIn(userName, rememberMe);
				SecurityHelper.TryFinishMembershipLogin(base.Session, Provider.GetUser(userName, true));
				return Redirect(returnUrl);
			}
			catch (ValidationException ex)
			{
				AddErrors(ModelState, ex);
				ViewBag.ReturnUrl = returnUrl;
			}
			return View("LoginFormFull");
		}

		public ActionResult Register()
		{
			ViewData["PasswordLength"] = Provider.MinRequiredPasswordLength;

			return View();
		}

		/// <summary>
		/// Action executed when a user clicks on the reset password email
		/// </summary>
		public ActionResult NewPassword(string guid)
		{
			Guid pwdResetGuid;
			if (Guid.TryParseExact(guid, "N", out pwdResetGuid) == false)
			{
				return ResultHelper.NotFoundResult(this);
			}

			User user = UsersServiceClient.GetByPasswordResetGuid(AuthenticationProvider.Membership, pwdResetGuid.ToString("N"));
			if (user == null || user.PasswordResetGuidExpireDate < DateTime.Now)
			{
				return ResultHelper.ForbiddenResult(this);
			}

			var membershipUser = Provider.GetUser(user.UserName, true);
			if (membershipUser == null)
			{
				return ResultHelper.ForbiddenResult(this);
			}

			FormsAuth.SignIn(membershipUser.UserName, false);
			SecurityHelper.TryFinishMembershipLogin(base.Session, membershipUser);
			Session.IsPasswordReset = true;

			return RedirectToAction("ChangePassword");
		}

		/// <summary>
		/// Show the form to send the email to the user to reset the password
		/// </summary>
		public ActionResult ResetPassword()
		{
			return View();
		}

		/// <summary>
		/// Sends the email to the user to reset the password
		/// </summary>
		[HttpPost]
		public ActionResult ResetPassword(string email)
		{
			try
			{
				string userName = Provider.GetUserNameByEmail(email);
				ValidateRegistration(userName);
				MembershipUser membershipUser = Provider.GetUser(userName, true);
				User user = UsersServiceClient.GetByProviderId(AuthenticationProvider.Membership, membershipUser.ProviderUserKey.ToString());
				string guid = System.Guid.NewGuid().ToString("N");//GUID without hyphens
				UsersServiceClient.UpdatePasswordResetGuid(user.Id, guid, DateTime.Now.AddHours(Config.AuthenticationProviders.FormsAuth.TimeToExpireResetPasswordLink));
				if (ModelState.IsValid)
				{
					string linkUrl = this.Domain + this.Url.RouteUrl(new
					{
						controller = "FormsAuthentication",
						action = "NewPassword",
						guid = guid
					});
					NotificationsServiceClient.SendResetPassword(user, linkUrl);
					return View("ResetPasswordEmailConfirmation");
				}
			}
			catch (ValidationException ex)
			{
				this.AddErrors(this.ModelState, ex);
			}
			return View();
		}

		[AcceptVerbs(HttpVerbs.Post)]
		public ActionResult Register(string userName, string email, string password, string confirmPassword, bool agreeTerms)
		{
			ViewData["PasswordLength"] = Provider.MinRequiredPasswordLength;
			var createStatus = MembershipCreateStatus.ProviderError;

			try
			{
				ValidateRegistration(userName, email, password, confirmPassword);
				ValidateRegistration(agreeTerms);
				// Attempt to register the user in the membership db
				var membershipUser = Provider.CreateUser(userName, password, email, null, null, true, null, out createStatus);
				ValidateCreateStatus(createStatus);
				SecurityHelper.TryFinishMembershipLogin(Session, membershipUser);
				FormsAuth.SignIn(userName, false);
				if (ModelState.IsValid)
				{
					return RedirectToAction("List", "Forums");
				}
			}
			catch (ValidationException ex)
			{
				if (createStatus == MembershipCreateStatus.Success)
				{
					//The membership succeded but the creation of the site user failed / Model constraint.
					Provider.DeleteUser(userName, true);
				}
				this.AddErrors(this.ModelState, ex);
			}

			return View();
		}

		[RequireAuthorization]
		public ActionResult ChangePassword()
		{
			ViewBag.PasswordLength = Provider.MinRequiredPasswordLength;

			return View();
		}

		[RequireAuthorization]
		[HttpPost]
		public ActionResult ChangePassword(string currentPassword, string newPassword, string confirmPassword)
		{
			var user = Provider.GetUser(User.UserName, true);
			try
			{
				ValidateChangePassword(currentPassword, newPassword, confirmPassword);
				if (Session.IsPasswordReset)
				{
					Provider.ChangePassword(user.UserName, currentPassword, newPassword);
				}
				else
				{
					if (!Provider.ChangePassword(user.UserName, currentPassword, newPassword))
					{
						throw new ValidationException(new ValidationError("currentPassword", ValidationErrorType.CompareNotMatch));
					}
				}

				//The time window to reset password ends
				Session.IsPasswordReset = false;
				return RedirectToAction("ChangePasswordSuccess");
			}
			catch (ValidationException ex)
			{
				this.AddErrors(ModelState, ex);
			}

			ViewBag.PasswordLength = Provider.MinRequiredPasswordLength;
			return View();
		}

		[RequireAuthorization]
		public ActionResult ChangePasswordSuccess()
		{
			return View();
		}

		#region Validation Methods
		/// <summary>
		/// Validates change password form params
		/// </summary>
		/// <exception cref="ValidationException"></exception>
		[NonAction]
		private void ValidateChangePassword(string currentPassword, string newPassword, string confirmPassword)
		{
			var errors = new List<ValidationError>();
			if ((!Session.IsPasswordReset) && String.IsNullOrEmpty(currentPassword))
			{
				errors.Add(new ValidationError("currentPassword", ValidationErrorType.NullOrEmpty));
			}
			if (newPassword == null || newPassword.Length < Provider.MinRequiredPasswordLength)
			{
				errors.Add(new ValidationError("newPassword", ValidationErrorType.NullOrEmpty));
			}
			else if (newPassword != confirmPassword)
			{
				errors.Add(new ValidationError("newPassword", ValidationErrorType.CompareNotMatch));
			}

			if (errors.Count > 0)
			{
				throw new ValidationException(errors);
			}
		}
		
		/// <summary>
		/// Validates the username and password, and check if the username exists
		/// </summary>
		/// <exception cref="ValidationException">Throws a ValidationException when any field is not valid.</exception>
		protected virtual void ValidateLogOn(string userName, string password)
		{
			var errors = new List<ValidationError>();
			if (String.IsNullOrEmpty(userName))
			{
				errors.Add(new ValidationError("userName", ValidationErrorType.NullOrEmpty));
			}
			if (String.IsNullOrEmpty(password))
			{
				errors.Add(new ValidationError("password", ValidationErrorType.NullOrEmpty));
			}
			if (errors.Count == 0 && !Provider.ValidateUser(userName, password))
			{
				errors.Add(new ValidationError("userName", ValidationErrorType.CompareNotMatch));
			}

			if (errors.Count > 0)
			{
				throw new ValidationException(errors);
			}
		}

		/// <summary>
		/// Maps MembershipCreateStatus values to model's ValidationException
		/// </summary>
		/// <exception cref="ValidationException"></exception>
		protected void ValidateCreateStatus(MembershipCreateStatus createStatus)
		{
			switch (createStatus)
			{
				case MembershipCreateStatus.Success:
					break;
				case MembershipCreateStatus.DuplicateUserName:
					throw new ValidationException(new ValidationError("username", ValidationErrorType.DuplicateNotAllowed));
				case MembershipCreateStatus.DuplicateEmail:
					throw new ValidationException(new ValidationError("email", ValidationErrorType.DuplicateNotAllowed));
				case MembershipCreateStatus.InvalidPassword:
					throw new ValidationException(new ValidationError("password", ValidationErrorType.Format));
				case MembershipCreateStatus.InvalidEmail:
					throw new ValidationException(new ValidationError("email", ValidationErrorType.Format));
				case MembershipCreateStatus.InvalidAnswer:
					throw new ValidationException(new ValidationError("answer", ValidationErrorType.Format));
				case MembershipCreateStatus.InvalidQuestion:
					throw new ValidationException(new ValidationError("question", ValidationErrorType.Format));
				case MembershipCreateStatus.InvalidUserName:
					throw new ValidationException(new ValidationError("username", ValidationErrorType.Format));
				default:
					throw new ValidationException(new ValidationError("__FORM", ValidationErrorType.Format));
			}
		}

		/// <summary>
		/// Validates fields that Membership does not.
		/// </summary>
		/// <exception cref="ValidationException"></exception>
		private void ValidateRegistration(string userName, string email, string password, string confirmPassword)
		{
			if (!String.Equals(password, confirmPassword, StringComparison.Ordinal))
			{
				throw new ValidationException(new ValidationError("password", ValidationErrorType.CompareNotMatch));
			}
		}

		private void ValidateRegistration(bool agreeTerms)
		{
			if (!agreeTerms)
			{
				throw new ValidationException(new ValidationError("agreeTerms", ValidationErrorType.NullOrEmpty));
			}
		}

		private void ValidateRegistration(string userName)
		{
			if (userName == null)
			{
				throw new ValidationException(new ValidationError("email", ValidationErrorType.CompareNotMatch));
			}
		}
		#endregion
	}
}
