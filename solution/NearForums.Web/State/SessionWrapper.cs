using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.SessionState;
using System.Web;

namespace NearForums.Web.State
{
	public class SessionWrapper
	{
		public HttpSessionStateBase Session
		{
			get;
			set;
		}

		public T GetItem<T>(string key)
		{
			return (T)Session[key];
		}

		public T GetItem<T>(string key, bool create) where T : new()
		{

			if (Session[key] == null)
			{
				if (create)
				{
					T value = new T();
					Session[key] = value;
					return value;
				}
				else
				{
					return (T)Session[key];
				}
			}
			else
			{
				return (T)Session[key];
			}
		}

		public void SetItem<T>(string key, T value)
		{
			Session[key] = value;
		}

		public SessionWrapper(HttpSessionStateBase session)
		{
			Session = session;
		}

		public SessionWrapper(HttpContextBase context) : this(context.Session)
		{

		}

		#region Props
		/// <summary>
		/// Current logged user. If the user is not logged in, its null.
		/// </summary>
		public UserState User
		{
			get
			{
				//return new UserState(1);
				return GetItem<UserState>("User");
			}
			set
			{
				SetItem<UserState>("User", value);
			}
		} 
		#endregion
	}
}
