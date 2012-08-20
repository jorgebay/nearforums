using System;
using System.Collections.Specialized;
using System.Security.Principal;
using System.Web;
using System.Web.SessionState;
using System.Web.Caching;
using System.Collections.Generic;

namespace NearForums.Tests.Fakes
{


    public class FakeHttpContext : HttpContextBase
    {
        private readonly FakePrincipal _principal;
        private readonly NameValueCollection _formParams;
        private readonly NameValueCollection _queryStringParams;
        private readonly HttpCookieCollection _cookies;
		private readonly string _url;
		private FakeHttpRequest _request;

        public FakeHttpContext(string url, FakePrincipal principal, NameValueCollection formParams, NameValueCollection queryStringParams, HttpCookieCollection cookies, SessionStateItemCollection sessionItems )
        {
			_url = url;
            _principal = principal;
            _formParams = formParams;
            _queryStringParams = queryStringParams;
            _cookies = cookies;
			_session = new FakeHttpSessionState(sessionItems);
			_request = new FakeHttpRequest(_url, _formParams, _queryStringParams, _cookies);
			_server = new FakeHttpServerUtility();
			_items = new Dictionary<string, object>();
        }

		public FakeHttpContext(string url)
			: this(url, null, new NameValueCollection(), new NameValueCollection(), new HttpCookieCollection(), new SessionStateItemCollection())
		{

		}

        public override HttpRequestBase Request
        {
            get
            {
				return _request;
            }
        }

        public override IPrincipal User
        {
            get
            {
                return _principal;
            }
            set
            {
                throw new System.NotImplementedException();
            }
        }

		private HttpSessionStateBase _session;
        public override HttpSessionStateBase Session
        {
            get
            {
                return _session;
            }
        }

		private FakeHttpResponse _response = new FakeHttpResponse();
		public override HttpResponseBase Response
		{
			get
			{
				return _response;
			}
		}

		public override System.Web.Caching.Cache Cache
		{
			get
			{
				return HttpRuntime.Cache;
			}
		}

		/// <summary>
		/// Cleans the cache instance
		/// </summary>
		public void CleanCache()
		{
			var itemsToRemove = new List<string>();

			var enumerator = Cache.GetEnumerator();
			while (enumerator.MoveNext())
			{
				itemsToRemove.Add(enumerator.Key.ToString());
			}

			foreach (string itemToRemove in itemsToRemove)
			{
				Cache.Remove(itemToRemove);
			}
		}

		private FakeHttpServerUtility _server;
		public override HttpServerUtilityBase Server
		{
			get
			{
				return _server;
			}
		}

		private System.Collections.IDictionary _items;
		public override System.Collections.IDictionary Items
		{
			get
			{
				return _items;
			}
		}
    }
}
