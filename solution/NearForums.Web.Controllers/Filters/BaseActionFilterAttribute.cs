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
using NearForums.Web.Integration;

namespace NearForums.Web.Controllers.Filters
{
	/// <summary>
	/// Defines a base class containing common properties and methods used.
	/// </summary>
	public class BaseActionFilterAttribute : NearForumsActionFilter
	{
		/// <summary>
		/// Gets or sets the current site configuration.
		/// </summary>
		private SiteConfiguration _config;
		public SiteConfiguration Config
		{
			get
			{
				if (_config == null)
				{
					Config = SiteConfiguration.Current;
				}
				return _config;
			}
			set
			{
				_config = value;
			}
		}
	}
}
