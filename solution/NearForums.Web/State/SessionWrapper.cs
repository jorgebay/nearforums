using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.SessionState;
using System.Web;

namespace NearForums.Web.State
{
	/// <summary>
	/// Encapsulates the ASP.NET session, 
	/// exposing typed properties / accessors to session items.
	/// </summary>
	public class SessionWrapper
	{
		public HttpSessionStateBase Session
		{
			get;
			set;
		}

		/// <summary>
		/// Gets typed values from the session
		/// </summary>
		/// <param name="key">The key name of the session value</param>
		public T GetItem<T>(string key)
		{
			return (T)Session[key];
		}

		/// <summary>
		/// Gets typed values from the session
		/// </summary>
		/// <param name="key">The key name of the session value</param>
		/// <param name="create">Determines if a new instance of the type T should be created in case it does not exist in session for that key</param>
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

		/// <summary>
		/// Sets a typed object into the session
		/// </summary>
		/// <typeparam name="T"></typeparam>
		/// <param name="key"></param>
		/// <param name="value"></param>
		public void SetItem<T>(string key, T value)
		{
			Session[key] = value;
		}

		/// <summary>
		/// Creates a new instance of the session wrapper
		/// </summary>
		public SessionWrapper(HttpSessionStateBase session)
		{
			Session = session;
		}

		/// <summary>
		/// Creates a new instance of the session wrapper
		/// </summary>
		/// <param name="context"></param>
		public SessionWrapper(HttpContextBase context)
			: this(context.Session)
		{

		} 

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
		}

		/// <summary>
		/// Sets the user related data in the current state.
		/// If the user is banned or suspended, session.user will be null.
		/// </summary>
		/// <param name="user"></param>
		/// <param name="provider"></param>
		/// <returns>The user stored in state (could be null)</returns>
		public UserState SetUser(User user, AuthenticationProvider provider)
		{
			if (user.Banned || user.Suspended)
			{
				SetItem<UserState>("User", null);
				return null;
			}
			var userState = new UserState(user, provider);
			SetItem<UserState>("User", userState);
			return userState;
		}

		/// <summary>
		/// Removes user information from session
		/// </summary>
		public void ClearUser()
		{
			SetItem<UserState>("User", null);
		}

		/// <summary>
		/// Gets or sets the current executing action (When used).
		/// </summary>
		public string CurrentAction
		{
			get
			{
				return GetItem<string>("CurrentAction");
			}
			set
			{
				SetItem<string>("CurrentAction", value);
			}
		}

		/// <summary>
		/// Gets or sets the current Captcha hash for captcha validation
		/// </summary>
		public string CaptchaHash
		{
			get
			{
				return GetItem<string>("CaptchaHash");
			}
			set
			{
				SetItem<string>("CaptchaHash", value);
			}
		}

		/// <summary>
		/// Determines if the current session is meant for password reset
		/// </summary>
		public bool IsPasswordReset
		{
			get
			{
				return GetItem<bool>("IsPasswordReset", true);
			}
			set
			{
				SetItem<bool>("IsPasswordReset", value);
			}
		}

		/// <summary>
		/// Determines if the user confirmed on this session that he is human, correctly filling in the captcha
		/// </summary>
		public bool IsHuman
		{
			get
			{
				return GetItem<bool>("IsPasswordReset", true);
			}
			set
			{
				SetItem<bool>("IsPasswordReset", value);
			}
		}

		/// <summary>
		/// Determines if the current session is previewing templates
		/// </summary>
		public bool IsTemplatePreview
		{
			get
			{
				return GetItem<bool>("IsTemplatePreview", true);
			}
			set
			{
				SetItem<bool>("IsTemplatePreview", value);
			}
		}

		/// <summary>
		/// Gets or sets the current template beeing previewed
		/// </summary>
		public TemplateState TemplatePreviewed
		{
			get
			{
				return GetItem<TemplateState>("TemplatePreviewed");
			}
			set
			{
				SetItem<TemplateState>("TemplatePreviewed", value);
			}
		}

		/// <summary>
		/// Gets a unique private token for this session. This token is not related to session id.
		/// </summary>
		public string SessionToken
		{
			get
			{
				const string sessionTokenKey = "SessionToken";
				if (GetItem<string>(sessionTokenKey) == null)
				{
					SetItem<string>(sessionTokenKey, Guid.NewGuid().ToString("N"));
				}
				return GetItem<string>(sessionTokenKey);
			}
		}

		/// <summary>
		/// Gets or set a next Url to go to. Generally used for flows like authentication.
		/// </summary>
		public string NextUrl
		{
			get
			{
				return GetItem<string>("NextUrl");
			}
			set
			{
				SetItem<string>("NextUrl", value);
			}
		}
	}
}
