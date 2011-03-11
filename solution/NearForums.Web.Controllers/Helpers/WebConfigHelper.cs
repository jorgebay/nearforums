using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Xml.Linq;
using NearForums.ServiceClient;

namespace NearForums.Web.Controllers.Helpers
{
	public static class WebConfigHelper
	{
		/// <summary>
		/// Determines is FormsAuthentication is enabled in the Web.Config
		/// </summary>
		/// <returns>bool</returns>
		public static bool IsFormsAuthenticationEnabled()
		{
			try
			{
				//We are obtaining this configuration value parsing the XML
				//instead of using the ConfigurationManager class because the web.config
				//can't be read entirely with medium or low trust security
				string webConfigPath = HttpContext.Current.Server.MapPath("~/Web.Config");

				XDocument webConfig = XDocument.Load(webConfigPath);
				var authMode = (from config in webConfig.Descendants("configuration").Descendants("system.web").Elements("authentication")
								select new
								{
									AuthMode = config.Attribute("mode").Value
								}
							 ).First().AuthMode;

				return authMode == "Forms" ? true : false;
			}
			catch (Exception ex)
			{
				LoggerServiceClient.LogError(ex);
				return false;
			}
		}

	}
}
