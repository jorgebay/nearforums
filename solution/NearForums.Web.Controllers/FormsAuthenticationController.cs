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

namespace NearForums.Web.Controllers
{

	[HandleError]
	public class FormsAuthenticationController : BaseController
	{
		/* This class uses code written by Troy Goode
		 * Source code licensed by MS-PL
		 * Website: https://github.com/TroyGoode/MembershipStarterKit
		 */

		// This constructor is used by the MVC framework to instantiate the controller using
		// the default forms authentication and membership providers.
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
			if (!Config.AuthorizationProviders.FormsAuth.IsDefined)
			{
				return ResultHelper.ForbiddenResult(this);
			}
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
			if (!Config.AuthorizationProviders.FormsAuth.IsDefined)
			{
				return ResultHelper.ForbiddenResult(this);
			}
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

		public ActionResult LogOff()
		{
			if (!Config.AuthorizationProviders.FormsAuth.IsDefined)
			{
				return ResultHelper.ForbiddenResult(this);
			}
			FormsAuth.SignOut();

			return RedirectToAction("List", "Forums");
		}

		public ActionResult Register()
		{
			if (!Config.AuthorizationProviders.FormsAuth.IsDefined)
			{
				return ResultHelper.ForbiddenResult(this);
			}
			ViewData["PasswordLength"] = MembershipService.MinPasswordLength;

			return View();
		}

		public ActionResult ResetPassword()
		{
			if (!Config.AuthorizationProviders.FormsAuth.IsDefined)
			{
				return ResultHelper.ForbiddenResult(this);
			}

			return View();
		}

		public ActionResult NewPassword(string guid)
		{
			if (!Config.AuthorizationProviders.FormsAuth.IsDefined)
			{
				return ResultHelper.ForbiddenResult(this);
			}

			//TODO: Write method to check guid against DB, verify GUID hasn't expired 
			//and redirect to change password for user associated with GUID.
			return ResultHelper.ForbiddenResult(this);
		}

		[AcceptVerbs(HttpVerbs.Post)]
		public ActionResult ResetPassword(string email)
		{
			if (!Config.AuthorizationProviders.FormsAuth.IsDefined)
			{
				return ResultHelper.ForbiddenResult(this);
			}
			try
			{
				string userName = Membership.GetUserNameByEmail(email);

				ValidateRegistration(userName);
				MembershipUser membershipUser = Membership.GetUser(userName);
				User user = UsersServiceClient.GetByProviderId(AuthenticationProvider.Membership, membershipUser.ProviderUserKey.ToString());
				string guid = System.Guid.NewGuid().ToString().Replace("-", string.Empty);
				UsersServiceClient.UpdatePasswordResetGuid(user.Id, guid, DateTime.Now.AddDays(2)); //Expire after 2 days. Maybe could be defined in config
				if (ModelState.IsValid)
				{
					string linkUrl = this.Domain + this.Url.RouteUrl(new
					{
						controller = "FormsAuthentication",
						action = "NewPassword",
						id = guid
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
			if (!Config.AuthorizationProviders.FormsAuth.IsDefined)
			{
				return ResultHelper.ForbiddenResult(this);
			}
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

		[Authorize]
		public ActionResult ChangePassword()
		{

			ViewData["PasswordLength"] = MembershipService.MinPasswordLength;

			return View();
		}

		[Authorize]
		[AcceptVerbs(HttpVerbs.Post)]
		[System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes",
			Justification = "Exceptions result in password not being changed.")]
		public ActionResult ChangePassword(string currentPassword, string newPassword, string confirmPassword)
		{

			ViewData["PasswordLength"] = MembershipService.MinPasswordLength;

			if (!ValidateChangePassword(currentPassword, newPassword, confirmPassword))
			{
				return View();
			}

			try
			{
				if (MembershipService.ChangePassword(Membership.GetUser().UserName, currentPassword, newPassword))
				{
					return RedirectToAction("ChangePasswordSuccess");
				}
				else
				{
					ModelState.AddModelError("_FORM", "The current password is incorrect or the new password is invalid.");
					return View();
				}
			}
			catch
			{
				ModelState.AddModelError("_FORM", "The current password is incorrect or the new password is invalid.");
				return View();
			}
		}

		[Authorize]
		//[AcceptVerbs(HttpVerbs.Post)]
		public ActionResult ChangePasswordSuccess()
		{
			return View();
		}

		#region Validation Methods
		[NonAction]
		private bool ValidateChangePassword(string currentPassword, string newPassword, string confirmPassword)
		{
			if (String.IsNullOrEmpty(currentPassword))
			{
				ModelState.AddModelError("currentPassword", "You must specify a current password.");
			}
			if (newPassword == null || newPassword.Length < MembershipService.MinPasswordLength)
			{
				ModelState.AddModelError("newPassword",
					String.Format(CultureInfo.CurrentCulture,
						 "You must specify a new password of {0} or more characters.",
						 MembershipService.MinPasswordLength));
			}

			if (!String.Equals(newPassword, confirmPassword, StringComparison.Ordinal))
			{
				ModelState.AddModelError("_FORM", "The new password and confirmation password do not match.");
			}

			return ModelState.IsValid;
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
