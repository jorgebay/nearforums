using System;
using System.Collections.Generic;
using System.Web;
using System.Text.RegularExpressions;
using NearForums.Configuration;
using NearForums.Configuration.Redirector;

namespace NearForums.Web.Modules
{
	public class RedirectorModule : IHttpModule
	{
		public void Dispose()
		{

		}

		public void Init(HttpApplication context)
		{
			context.BeginRequest += new EventHandler(context_BeginRequest);
		}

		void context_BeginRequest(object sender, EventArgs e)
		{
			HttpApplication application = (HttpApplication)sender;
			HttpContextBase context = new HttpContextWrapper(application.Context);

			RedirectorConfiguration config = RedirectorConfiguration.Current;

			if (config != null)
			{
				RedirectRequest(context, config);
			}
		}

		#region Redirect Request
		public void RedirectRequest(HttpContextBase context, RedirectorConfiguration config)
		{
			HttpRequestBase request = context.Request;
			HttpResponseBase response = context.Response;

			string rawUrl = request.Url.AbsoluteUri;

			//Ignore FORM requests
			if (request.HttpMethod.ToUpper() != "GET" && request.HttpMethod.ToUpper() != "HEAD")
			{
				return;
			}

			#region Ignores
			//Ignore urls defined in config in order to avoid evaluation of this urls (performance).
			if (!String.IsNullOrEmpty(config.IgnoreRegex))
			{
				if (Regex.IsMatch(rawUrl, config.IgnoreRegex))
				{
					return;
				}
			}
			#endregion

			//Check every url group, if a group matches (only then) evaluate the individual url patterns
			foreach (RedirectorUrlGroup group in config.UrlGroups)
			{
				//For each group of regular expression, check if the url matches
				if (Regex.IsMatch(rawUrl, group.Regex))
				{
					foreach (RedirectorUrl url in group.Urls)
					{
						//For each regular expression in the group check if it matches
						if (Regex.IsMatch(rawUrl, url.Regex))
						{
							string headers = HttpUtility.UrlDecode(request.Headers.ToString());
							if (url.HeaderRegex == null || Regex.IsMatch(headers, url.HeaderRegex, RegexOptions.IgnoreCase))
							{
								string urlResult = Regex.Replace(rawUrl, url.Regex, url.Replacement);
								response.StatusCode = url.ResponseStatus; // 301: Moved permanently or 302: Found redirect
								response.AddHeader("Location", urlResult);
								response.End();
								break;
							}
						}
					}
					break;
				}
			}
		}
		#endregion
	}
}
