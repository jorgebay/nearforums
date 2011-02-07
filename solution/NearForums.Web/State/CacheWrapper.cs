using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Caching;

namespace NearForums.Web.State
{
	public class CacheWrapper
	{
		#region Contructor and Get and Set
		public Cache Cache
		{
			get;
			set;
		}

		public T GetItem<T>(string key)
		{
			return (T)this.Cache[key];
		}

		public T GetItem<T>(string key, bool create) where T : new()
		{

			if (this.Cache[key] == null)
			{
				if (create)
				{
					T value = new T();
					this.Cache[key] = value;
					return value;
				}
				else
				{
					return (T)this.Cache[key];
				}
			}
			else
			{
				return (T)this.Cache[key];
			}
		}

		public void SetItem<T>(string key, T value)
		{
			if (value == null)
			{
				this.Cache.Remove(key);
			}
			else
			{
				this.Cache[key] = value;
			}
		}

		public CacheWrapper(Cache cache)
		{
			this.Cache = cache;
		}

		public CacheWrapper(HttpContextBase context)
			: this(context.Cache)
		{

		}


		#endregion

		#region Props
		public TemplateState Template
		{
			get
			{
				return this.GetItem<TemplateState>("Template");
			}
			set
			{
				this.SetItem<TemplateState>("Template", value);
			}
		}

		private Dictionary<string,List<string>> VisitedActions
		{
			get
			{
				return this.GetItem<Dictionary<string, List<string>>>("VisitedActions", true);
			}
		}
		#endregion

		#region Latest posting of an IP
		/// <summary>
		/// Stores the IP with the current time
		/// </summary>
		public void SetLatestPosting(string ip)
		{
			SetPostingTime(ip, DateTime.Now);
		}

		/// <summary>
		/// Sets the time the ip posted in the forum
		/// </summary>
		protected virtual void SetPostingTime(string ip, DateTime date)
		{
			var usersPostings = GetItem<Dictionary<string, DateTime>>("UsersPostings", true);
			if (!usersPostings.ContainsKey(ip))
			{
				usersPostings.Add(ip, DateTime.Now);
			}
			usersPostings[ip] = date;
		}

		/// <summary>
		/// Forces a timespan to the be substracted from the latest posting date
		/// </summary>
		public void SetTimePassed(string ip, TimeSpan amountPassed)
		{
			DateTime? lastPosting = GetLatestPosting(ip);
			if (lastPosting != null)
			{
				SetPostingTime(ip, lastPosting.Value.Subtract(amountPassed));
			}
		}

		/// <summary>
		/// Gets the date of the latest posting of the IP. If not found, it returns null.
		/// </summary>
		/// <param name="ip"></param>
		/// <returns></returns>
		public DateTime? GetLatestPosting(string ip)
		{
			DateTime? result = null;
			var usersPostings = GetItem<Dictionary<string, DateTime>>("UsersPostings", true);
			if (usersPostings.ContainsKey(ip))
			{
				result = usersPostings[ip];
			}
			return result;
		}
		#endregion

		#region VisitedActionAlready
		/// <summary>
		/// Determines if an IP already visited a method, and if not set as visited.
		/// </summary>
		/// <returns></returns>
		public bool VisitedActionAlready(string controller, string action, string param, string ip)
		{
			bool alreadyVisited = false;
			string key = controller + "." + action + ":" + param;
			if (!this.VisitedActions.ContainsKey(key))
			{
				this.VisitedActions[key] = new List<string>();
			}

			if (this.VisitedActions[key].Contains(ip))
			{
				alreadyVisited = true;
			}
			else
			{
				alreadyVisited = false;
				this.VisitedActions[key].Add(ip);
			}

			return alreadyVisited;
		} 
		#endregion
	}
}
