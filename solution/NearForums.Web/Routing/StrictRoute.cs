using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Routing;
using System.Web;
using System.Text.RegularExpressions;

namespace NearForums.Web.Routing
{
	public class StrictRoute : Route
	{
		public bool LowerCaseOnly
		{
			get;
			set;
		}

		public StrictRoute(string url, IRouteHandler handler)
			: base(url, handler)
		{
			
		}

		public StrictRoute(string url, IRouteHandler handler, bool lowerCaseOnly)
			: this(url, handler)
		{
			LowerCaseOnly = lowerCaseOnly;
		}

		/// <summary>
		/// Checks that the route is a match, taking also in account case sensitivity and trailing slashes
		/// </summary>
		/// <returns>Returns null if the requested url and the route does not match</returns>
		public override RouteData GetRouteData(HttpContextBase httpContext)
		{
			RouteData data = base.GetRouteData(httpContext);
			if (data != null)
			{
				//Check for trailing slash and case sensitivity
				//if not set data to null
				var virtualPath = httpContext.Request.AppRelativeCurrentExecutionFilePath.Substring(2) + httpContext.Request.PathInfo;

				if (virtualPath.Length > 1)
				{
					//Count trailing slashes
					if (Regex.Matches(this.Url, "/").Count != Regex.Matches(virtualPath, "/").Count)
					{
						data = null;
					}
					else if (LowerCaseOnly && virtualPath.ToLower() != virtualPath)
					{
						data = null;
					}
				}
			}
			return data;
		}

		public override VirtualPathData GetVirtualPath(RequestContext requestContext, RouteValueDictionary values)
		{
			#region Remove default values
			if (values.Count > 2 && this.Defaults.Count > 2 && values.ContainsKey("Controller") && values.ContainsKey("Action"))
			{
				//It have more values than just controller/action
				if (this.Defaults["Controller"].ToString().ToUpper() == values["Controller"].ToString().ToUpper() && this.Defaults["Action"].ToString().ToUpper() == values["Action"].ToString().ToUpper())
				{
					//Possible route
					foreach (KeyValuePair<string, object> item in this.Defaults)
					{
						if (item.Key.ToUpper() != "CONTROLLER" && item.Key.ToUpper() != "ACTION")
						{
							if (values.ContainsKey(item.Key))
							{
								if (values[item.Key].ToString().ToUpper() == item.Value.ToString().ToUpper())
								{
									//If the value given is equal to a default value
									values.Remove(item.Key);

									//Remove also from the request context
									if (requestContext.RouteData.Values.ContainsKey(item.Key))
									{
										requestContext.RouteData.Values.Remove(item.Key);
									}
								}
							}
						}
					}
				}
				else
				{
					//Improve performance
					return null;
				}
			}
			#endregion

			VirtualPathData data =  base.GetVirtualPath(requestContext, values);
			if (data != null)
			{
				#region Trailing slash
				//If there is trailing slash in the route url, add it
				//Sample Url: "category/{category}/{page}"
				//Sample virtual: "/category/technology/"
				//Sample virtual: "/category/technology/1"
				//Sample virtual: "/category/technology/?extraParam=1"
				if (Regex.Matches(data.VirtualPath, "/").Count < Regex.Matches(this.Url, "/").Count)
				{
					if (!data.VirtualPath.Contains("?"))
					{
						data.VirtualPath += "/";
					}
					else
					{
						int position = data.VirtualPath.IndexOf("?");
						data.VirtualPath = data.VirtualPath.Substring(0, position) + "/" + data.VirtualPath.Substring(position);
					}
				} 
				#endregion

				//All to lower case
				if (LowerCaseOnly)
				{
					data.VirtualPath = data.VirtualPath.ToLower();
				}
			}

			return data;
		}
	}
}
