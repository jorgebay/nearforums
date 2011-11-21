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
		/* This class uses code written by Troy Goode
		 * Source code licensed by MS-PL
		 * Website: https://github.com/TroyGoode/MembershipStarterKit
		 */

		public FormsAuthenticationController()
			: this(null, null)
		{
		}

		// This constructor is not used by the MVC framework but is instead provided for ease
		// of unit testing this type. See the comments at the end of this file for more
		// information.
		public FormsAuthenticationController(IFormsAuthentication formsAuth, IMembershipService service)
		{
			FormsAuth = formsAuth ?? new FormsAuthenticationService();
			MembershipService = service ?? new AccountMembershipService();
		}

		public IFormsAuthentication FormsAuth
		{
			get;
			private set;
		}

		public IMembershipService MembershipService
		{
			get;
			private set;
		}

		[HttpGet]
		public ActionResult Login(string returnUrl)
		{
			if (this.User != null)
			{
				return Redirect(returnUrl);
			}
			ViewBag.ReturnUrl = returnUrl;

			return View();
		}

		[HttpPost]
		[System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1054:UriParametersShouldNotBeStrings",
			Justification = "Needs to take same parameter type as Controller.Redirect()")]
		public ActionResult Login(string userName, string password, bool rememberMe, string returnUrl)
		{
			if (!ValidateLogOn(userName, password))
			{
				ViewBag.ReturnUrl = returnUrl;
				return View();
			}

			FormsAuth.SignIn(userName, rememberMe);

			SecurityHelper.TryFinishMembershipLogin(base.Session, Membership.GetUser(userName));

			if (!String.IsNullOrEmpty(returnUrl))
			{
				return Redirect(returnUrl);
			}
			else
			{
				return RedirectToAction("List", "Forums");
			}
		}

		public ActionResult Register()
		{
			ViewData["PasswordLength"] = MembershipService.MinPasswordLength;

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

			MembershipUser membershipUser = Membership.GetUser(user.UserName);
			if (membershipUser == null)
			{
				return ResultHelper.ForbiddenResult(this);
			}

			MembershipProvider provider = Membership.Provider;
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
		[AcceptVerbs(HttpVerbs.Post)]
		public ActionResult ResetPassword(string email)
		{
			try
			{
				string userName = Membership.GetUserNameByEmail(email);

				ValidateRegistration(userName);
				MembershipUser membershipUser = Membership.GetUser(userName);
				User user = UsersServiceClient.GetByProviderId(AuthenticationProvider.Membership, membershipUser.ProviderUserKey.ToString());
				string guid = System.Guid.NewGuid().ToString("N");//GUID without hyphens
				UsersServiceClient.UpdatePasswordResetGuid(user.Id, guid, DateTime.Now.AddHours(Config.AuthorizationProviders.FormsAuth.TimeToExpireResetPasswordLink));
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
		public ActionResult Register(string userName, string email, string password, string confirmPassword)
		{
			ViewData["PasswordLength"] = MembershipService.MinPasswordLength;
			var createStatus = MembershipCreateStatus.Success;

			try
			{
				ValidateRegistration(userName, email, password, confirmPassword);
				// Attempt to register the user in the membership db
				createStatus = MembershipService.CreateUser(userName, password, email);
				ValidateCreateStatus(createStatus);
				SecurityHelper.TryFinishMembershipLogin(base.Session, Membership.GetUser(userName));
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
					Membership.DeleteUser(userName);
				}
				this.AddErrors(this.ModelState, ex);
			}

			return View();
		}

		[RequireAuthorization]
		public ActionResult ChangePassword()
		{
			ViewBag.PasswordLength = MembershipService.MinPasswordLength;

			return View();
		}

		[RequireAuthorization]
		[HttpPost]
		public ActionResult ChangePassword(string currentPassword, string newPassword, string confirmPassword)
		{
			var user = Membership.GetUser();
			try
			{
				ValidateChangePassword(currentPassword, newPassword, confirmPassword);
				if (Session.IsPasswordReset)
				{
					MembershipService.ChangePassword(user.UserName, newPassword);
				}
				else
				{
					if (!MembershipService.ChangePassword(user.UserName, currentPassword, newPassword))
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

			ViewBag.PasswordLength = MembershipService.MinPasswordLength;
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
			if (newPassword == null || newPassword.Length < MembershipService.MinPasswordLength)
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
		[NonAction]
		private bool ValidateLogOn(string userName, string password)
		{
			if (String.IsNullOrEmpty(userName))
			{
				ModelState.AddModelError("username", "You must specify a username.");
			}
			if (String.IsNullOrEmpty(password))
			{
				ModelState.AddModelError("password", "You must specify a password.");
			}
			if (!MembershipService.ValidateUser(userName, password))
			{
				ModelState.AddModelError("_FORM", "The username or password provided is incorrect.");
			}

			return ModelState.IsValid;
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
