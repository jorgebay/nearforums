using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using System.Web;
using System.Web.Security;
using NearForums.Web.State;
using NearForums;
using NearForums.Web.Extensions;
using System.Web.Routing;
using NearForums.Configuration;

namespace NearForums.Web.Controllers.Filters
{
	/// <summary>
	/// Defines a base class containing common properties and methods used.
	/// </summary>
	public abstract class BaseActionFilterAttribute : ActionFilterAttribute
	{
		/// <summary>
		/// Gets or sets the current site configuration.
		/// </summary>
		/// <remarks>To ensure testability</remarks>
		public SiteConfiguration Config
		{
			get;
			set;
		}

		public BaseActionFilterAttribute()
		{
			Config = SiteConfiguration.Current;
		}
	}
}
