using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NearForums.Web.Controllers.Filters;
using NearForums.ServiceClient;

namespace NearForums.Web.Controllers
{
	public class MessagesController : BaseController
	{
		#region Delete
		/// <summary>
		/// Removes a message
		/// </summary>
		/// <param name="mid">message id</param>
		/// <param name="id">topic id</param>
		[HttpPost]
		[RequireAuthorization(UserGroup.Moderator, RefuseOnFail = true)]
		public ActionResult Delete(int mid, int id, string forum, string name)
		{
			MessagesServiceClient.Delete(id, mid, this.User.Id);
			return Json(true);
		}
		#endregion

		#region Flag messages
		/// <summary>
		/// Marks a message as inapropriate
		/// </summary>
		/// <param name="mid">Message id</param>
		/// <param name="id">Topic id</param>
		[HttpPost]
		public ActionResult Flag(int mid, int id, string forum, string name)
		{
			bool flagged = MessagesServiceClient.Flag(id, mid, Request.UserHostAddress);

			return Json(flagged);
		}
		#endregion
	}
}
