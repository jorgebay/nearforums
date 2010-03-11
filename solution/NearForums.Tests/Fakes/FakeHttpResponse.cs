using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Collections.Specialized;

namespace NearForums.Tests.Fakes
{
	public class FakeHttpResponse : HttpResponseBase
	{
		public override void End()
		{
			
		}

		public override int StatusCode
		{
			get;
			set;
		}

		public override void Clear()
		{
			StatusCode = 0;
		}

		public override void AddHeader(string name, string value)
		{
			this.Headers[name] = value;
		}

		public override string ApplyAppPathModifier(string virtualPath)
		{
			return virtualPath;
		}

		private NameValueCollection _headers = new NameValueCollection();
		public override NameValueCollection Headers
		{
			get
			{
				return _headers;
			}
		}

		private HttpCookieCollection _cookies = new HttpCookieCollection();
		public override HttpCookieCollection Cookies
		{
			get
			{
				return _cookies;
			}
		}
	}
}
