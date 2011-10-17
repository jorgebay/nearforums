using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Routing;
using System.Text.RegularExpressions;
using System.Globalization;

namespace NearForums.Web.Routing
{
	public class RegexConstraint : IRouteConstraint
	{
		protected Regex regex;

		public RegexConstraint(string pattern, RegexOptions options = RegexOptions.CultureInvariant | RegexOptions.Compiled | RegexOptions.IgnoreCase)
		{
			regex = new Regex(pattern, options);
		}

		public bool Match(System.Web.HttpContextBase httpContext, Route route, string parameterName, RouteValueDictionary values, RouteDirection routeDirection)
		{
			object val;
			values.TryGetValue(parameterName, out val);
			string input = Convert.ToString(val, CultureInfo.InvariantCulture);
			return regex.IsMatch(input);
		}
	}
}
