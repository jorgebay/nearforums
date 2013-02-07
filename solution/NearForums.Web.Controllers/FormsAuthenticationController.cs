using System;
using System.Collections.Generic;
using System.Web.Mvc;
using System.Web.Security;
using NearForums.Web.Controllers.Helpers;
using NearForums.Validation;
using NearForums.Web.Controllers.Filters;
using NearForums.Services;

namespace NearForums.Web.Controllers
{
	[HandleError]
	[ValidateFormsAuth]
	public class FormsAuthenticationController : BaseController
	{
		/// <summary>
		/// User service
		/// </summary>
		private readonly IUsersService _service;

		public FormsAuthenticationController(IUsersService service)
		{
			_service = service;
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
				var userId = SecurityHelper.TryFinishMembershipLogin(Session, MembershipProvider.GetUser(userName, true), _service);
				if (Session.User == null)
				{
					//User is banned or suspended
					return RedirectToAction("Detail", "Users", new { id = userId });
				}
				FormsAuthentication.SetAuthCookie(userName, rememberMe);
				return Redirect(returnUrl);
			}
			catch (ValidationException ex)
			{
				AddErrors(ModelState, ex);
				ViewBag.ReturnUrl = returnUrl;
			}
			return View("LoginFormFull");
		}

		[HttpGet]
		public ActionResult Register()
		{
			ViewData["PasswordLength"] = MembershipProvider.MinRequiredPasswordLength;

			return View();
		}

		[HttpPost]
		public ActionResult Register(string userName, string email, string password, string confirmPassword, bool agreeTerms)
		{
			ViewData["PasswordLength"] = MembershipProvider.MinRequiredPasswordLength;
			var createStatus = MembershipCreateStatus.ProviderError;

			try
			{
				ValidateRegistration(userName, email, password, confirmPassword);
				ValidateRegistration(agreeTerms);
				// Attempt to register the user in the membership db
				if (ModelState.IsValid)
				{
					var membershipUser = MembershipProvider.CreateUser(userName, password, email, null, null, true, null, out createStatus);
					ValidateCreateStatus(createStatus);
					SecurityHelper.TryFinishMembershipLogin(Session, membershipUser, _service);
					FormsAuthentication.SetAuthCookie(userName, false);

					return RedirectToAction("List", "Forums");
				}
			}
			catch (ValidationException ex)
			{
				if (createStatus == MembershipCreateStatus.Success)
				{
					//The membership succeded but the creation of the site user failed / Model constraint.
					MembershipProvider.DeleteUser(userName, true);
				}
				this.AddErrors(this.ModelState, ex);
			}

			return View();
		}

		/// <summary>
		/// This action is executed inside the reset password / forgot password flow:
		/// When a user clicks on the reset password email
		/// </summary>
		public ActionResult NewPassword(string guid)
		{
			Guid pwdResetGuid;
			if (!Guid.TryParseExact(guid, "N", out pwdResetGuid))
			{
				return ResultHelper.NotFoundResult(this);
			}

			var user = _service.GetByPasswordResetGuid(AuthenticationProvider.Membership, pwdResetGuid.ToString("N"));
			if (user == null || user.PasswordResetGuidExpireDate < DateTime.Now)
			{
				return ResultHelper.ForbiddenResult(this);
			}

			var membershipUserName = MembershipProvider.GetUserNameByEmail(user.Email);
			if (membershipUserName == null)
			{
				throw new Exception("No user was found for email " + user.Email);
			}
			var membershipUser = MembershipProvider.GetUser(membershipUserName, true);
			SecurityHelper.TryFinishMembershipLogin(Session, membershipUser, _service);
			FormsAuthentication.SetAuthCookie(membershipUser.UserName, false);
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
				var userName = MembershipProvider.GetUserNameByEmail(email);
				if (userName == null)
				{
					throw new ValidationException(new ValidationError("email", ValidationErrorType.CompareNotMatch));
				}
				var membershipUser = MembershipProvider.GetUser(userName, true);
				string guid = System.Guid.NewGuid().ToString("N");//GUID without hyphens
				string linkUrl = this.Domain + this.Url.RouteUrl(new
				{
					controller = "FormsAuthentication",
					action = "NewPassword",
					guid = guid
				});
				_service.ResetPassword(membershipUser.ProviderUserKey.ToString(), guid, linkUrl);
				return View("ResetPasswordEmailConfirmation");
			}
			catch (ValidationException ex)
			{
				this.AddErrors(this.ModelState, ex);
			}
			return View();
		}

		[RequireAuthorization]
		public ActionResult ChangePassword()
		{
			ViewBag.PasswordLength = MembershipProvider.MinRequiredPasswordLength;

			return View();
		}

		[RequireAuthorization]
		[HttpPost]
		public ActionResult ChangePassword(string currentPassword, string newPassword, string confirmPassword)
		{
			var user = MembershipProvider.GetUser(HttpContext.User.Identity.Name, true);
			try
			{
				ValidateChangePassword(currentPassword, newPassword, confirmPassword);
				if (Session.IsPasswordReset)
				{
					currentPassword = user.ResetPassword();
					MembershipProvider.ChangePassword(user.UserName, currentPassword, newPassword);
				}
				else
				{
					if (!MembershipProvider.ChangePassword(user.UserName, currentPassword, newPassword))
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

			ViewBag.PasswordLength = MembershipProvider.MinRequiredPasswordLength;
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
			if (newPassword == null || newPassword.Length < MembershipProvider.MinRequiredPasswordLength)
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
			if (errors.Count == 0 && !MembershipProvider.ValidateUser(userName, password))
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
		#endregion
	}
}
