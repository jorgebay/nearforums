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
            : this(controller, url, null, null, null, null, null, null)
        {
        }

        public FakeControllerContext(IController controller, string url, HttpCookieCollection cookies)
            : this(controller, url, null, null, null, null, cookies, null)
        {
        }

        public FakeControllerContext(IController controller, string url, SessionStateItemCollection sessionItems)
            : this(controller, url, null, null, null, null, null, sessionItems)
        {
        }


        public FakeControllerContext(IController controller, string url, NameValueCollection formParams) 
            : this(controller, url, null, null, formParams, null, null, null)
        {
        }


        public FakeControllerContext(IController controller, string url, NameValueCollection formParams, NameValueCollection queryStringParams)
            : this(controller, url, null, null, formParams, queryStringParams, null, null)
        {
        }



        public FakeControllerContext(IController controller, string url, string userName)
            : this(controller, url, userName, null, null, null, null, null)
        {
        }


        public FakeControllerContext(IController controller, string url, string userName, string[] roles)
            : this(controller, url, userName, roles, null, null, null, null)
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