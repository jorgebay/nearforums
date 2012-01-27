using System;
using System.Collections.Specialized;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.SessionState;

namespace NearForums.Tests.Fakes
{

    public class FakeControllerContext : ControllerContext
    {
		public FakeControllerContext(IController controller)
			: this(controller, "http://localhost")
		{

		}

        public FakeControllerContext(IController controller, string url)
            : this(controller, url, null, null, new NameValueCollection(), new NameValueCollection(), new HttpCookieCollection(), new SessionStateItemCollection())
        {
        }

        public FakeControllerContext
            (
                IController controller,
				string url,
                string userName,
                string[] roles,
                NameValueCollection formParams,
                NameValueCollection queryStringParams,
                HttpCookieCollection cookies,
                SessionStateItemCollection sessionItems
            )
            : base(new FakeHttpContext(url, new FakePrincipal(new FakeIdentity(userName), roles), formParams, queryStringParams, cookies, sessionItems), new RouteData(), (ControllerBase)controller)
        {
		}

		public void SetUri(string url)
		{
			((FakeHttpRequest)this.HttpContext.Request).SetUri(url);
		}

    }
}