using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;

namespace NearForums.Web.Extensions
{
	public static class ViewDataExtensions
	{
		public static T Get<T>(this ViewDataDictionary viewData, string key)
		{
			return (T)viewData[key];
		}

		public static T Get<T>(this ViewDataDictionary viewData, string key, T valueIfNull)
		{
			if (viewData[key] == null)
			{
				return valueIfNull;
			}
			return viewData.Get<T>(key);
		}

		public static T GetDefault<T>(this ViewDataDictionary viewData, string key)
		{
			if (viewData[key] == null)
			{
				return default(T);
			}
			return viewData.Get<T>(key);
		}

		public static string WriteIf(this ViewDataDictionary viewData, string key, string textIfTrue, string textIfFalse)
		{
			if (GetDefault<bool>(viewData, key))
			{
				return textIfTrue;
			}
			else
			{
				return textIfFalse;
			}
		}
	}
}
