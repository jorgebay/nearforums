using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Html;
using ICSharpCode.SharpZipLib.Zip;
using System.Text.RegularExpressions;
using System.Text;
using NearForums.Validation;
using NearForums.ServiceClient;
using NearForums.Web.Controllers.Filters;

using System.Configuration;
using System.Web.Configuration;
using System.Net.Configuration;
using NearForums.Web.Controllers.Helpers;
using DotNetOpenAuth.OAuth.ChannelElements;
using DotNetOpenAuth.Messaging;
using DotNetOpenAuth.OpenId.RelyingParty;
using DotNetOpenAuth.OpenId;
using DotNetOpenAuth.OAuth;
using DotNetOpenAuth.OAuth.Messages;
using NearForums.Web.Controllers.Helpers.OAuth;
using System.Net;
using NearForums.Web.Extensions;

namespace NearForums.Web.Controllers
{
	public class AdminController : BaseController
	{
		#region Dashboard
		[RequireAuthorization(UserGroup.Moderator)]
		public ActionResult Dashboard()
		{
			return View();
		}
		#endregion
	}
}
