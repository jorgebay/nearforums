using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using System.ComponentModel;
using System.Web;

namespace NearForums.Web.Extensions
{
	public static class ViewDataExtensions
	{
		#region Get
		/// <summary>
		/// Gets typed value from the ViewDataDictionary
		/// </summary>
		public static T Get<T>(this ViewDataDictionary viewData, string key)
		{
			return (T)viewData[key];
		}

		/// <summary>
		/// Gets typed value from the ViewDataDictionary or valueIfNull
		/// </summary>
		public static T Get<T>(this ViewDataDictionary viewData, string key, T valueIfNull)
		{
			if (viewData[key] == null)
			{
				return valueIfNull;
			}
			return viewData.Get<T>(key);
		}

		/// <summary>
		/// Gets typed value from the ViewDataDictionary or the type default
		/// </summary>
		public static T GetDefault<T>(this ViewDataDictionary viewData, string key)
		{
			if (viewData[key] == null)
			{
				return default(T);
			}
			return viewData.Get<T>(key);
		}
		#endregion

		#region WriteIf
		/// <summary>
		/// Returns textIfTrue if the key exists in the ViewDataDictionary and if its true
		/// </summary>
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

		/// <summary>
		/// Returns textIfTrue if the key exists in the ViewDataDictionary and if its true, otherwise empty string
		/// </summary>
		public static string WriteIf(this ViewDataDictionary viewData, string key, string textIfTrue)
		{
			return viewData.WriteIf(key, textIfTrue, string.Empty);
		}

		/// <summary>
		/// Returns textIfTrue if the key exists in the ViewDataDictionary and if its true, otherwise textIfFalse
		/// </summary>
		public static IHtmlString WriteIf(this ViewDataDictionary viewData, string key, IHtmlString textIfTrue, IHtmlString textIfFalse)
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

		/// <summary>
		/// Returns textIfTrue if the key exists in the ViewDataDictionary and if its true, otherwise empty MvcHtmlString
		/// </summary>
		public static IHtmlString WriteIf(this ViewDataDictionary viewData, string key, IHtmlString textIfTrue)
		{
			return viewData.WriteIf(key, textIfTrue, MvcHtmlString.Empty);
		} 
		#endregion

		#region ViewData Create Append
		/// <summary>
		/// Creates a ViewDataDictionary based on the properties of the values object, added as key/values
		/// </summary>
		public static ViewDataDictionary CreateViewData(object values)
		{
			ViewDataDictionary viewData = new ViewDataDictionary();
			viewData.Append(values);
			return viewData;
		}

		/// <summary>
		/// Adds the values object properties to the viewdata.
		/// </summary>
		public static ViewDataDictionary Append(this ViewDataDictionary viewData, object values)
		{
			if (values != null)
			{
				foreach (PropertyDescriptor descriptor in TypeDescriptor.GetProperties(values))
				{
					object value = descriptor.GetValue(values);
					viewData.Add(descriptor.Name, value);
				}
			}
			return viewData;
		} 
		#endregion
	}
}
