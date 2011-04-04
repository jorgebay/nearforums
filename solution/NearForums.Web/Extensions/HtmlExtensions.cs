using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using System.Globalization;
using System.Web.Routing;
using System.Web.Mvc.Html;
using System.Web.Mvc.ExpressionUtil;
using System.Text.RegularExpressions;
using System.Security;
using NearForums.Configuration;
using System.Collections;
using System.Linq.Expressions;

namespace NearForums.Web.Extensions
{
	public static class HtmlExtensions
	{
		public static string ImageStatic(this HtmlHelper htmlHelper, string src, string css)
		{
			if (src == null)
			{
				throw new NullReferenceException("The src cannot be null.");
			}
			else if (!src.StartsWith("/"))
			{
				throw new ArgumentException("The src should be absolute (starting with /)");
			}
			TagBuilder builder = new TagBuilder("img");
			if (css != null)
			{
				builder.AddCssClass(css);
			}
			builder.Attributes.Add("src", src);

			return builder.ToString();
		}

		public static string GetModelAttemptedValue(this HtmlHelper htmlHelper, string key)
		{
			ModelState state;
			if (htmlHelper.ViewData.ModelState.TryGetValue(key, out state))
			{
				return state.Value.AttemptedValue;
			}
			return null;
		}

		public static string EvalString(this HtmlHelper htmlHelper, string key)
		{
			return Convert.ToString(htmlHelper.ViewData.Eval(key), CultureInfo.CurrentCulture);
		}

		public static MvcHtmlString MetaDescription(this HtmlHelper htmlHelper, string content)
		{
			if (content != null)
			{
				TagBuilder builder = new TagBuilder("meta");
				builder.Attributes.Add("name", "description");
				content = Regex.Replace(content, "\r|\n", "");
				content = Regex.Replace(content, "(&nbsp;)+|(\t+)", " ");
				builder.Attributes.Add("content", SecurityElement.Escape(content));
				return MvcHtmlString.Create(builder.ToString(TagRenderMode.SelfClosing));
			}
			else
			{
				return null;
			}
		}

		public static MvcHtmlString DropDownListDefault(this HtmlHelper htmlHelper, string name, IEnumerable<SelectListItem> selectList, object defaultValue, string defaultText)
		{
			List<SelectListItem> list = new List<SelectListItem>(selectList);
			SelectListItem item = new SelectListItem();
			item.Text = defaultText;
			item.Value = defaultValue.ToString();
			list.Insert(0, item);
			return htmlHelper.DropDownList(name, list);
		}

		public static T GetStateValue<T>(this HtmlHelper htmlHelper, string key)
		{
			T value = default(T);
			ModelState state;
			if (htmlHelper.ViewData.ModelState.TryGetValue(key, out state))
			{
				value = (T)state.Value.ConvertTo(typeof(T), null);
			}
			else
			{
				value = (T)htmlHelper.ViewData.Eval(key);
			}
			return value;
		}

		/// <summary>
		/// Converts date to app datetime and applies the format
		/// </summary>
		public static MvcHtmlString Date(this HtmlHelper htmlHelper, DateTime date, string format)
		{
			DateTime appDate = date.ToApplicationDateTime();
			TagBuilder builder = new TagBuilder("span");
			builder.AddCssClass("date");
			builder.AddCssClass("d" + appDate.Year + "-" + appDate.Month + "-" + appDate.Day + "-" + appDate.Hour + "-" + appDate.Minute);
			builder.InnerHtml = appDate.ToString(format);
			return MvcHtmlString.Create(builder.ToString());
		}

		/// <summary>
		/// Converts date to app datetime and applies configuration defined date format
		/// </summary>
		public static MvcHtmlString Date(this HtmlHelper htmlHelper, DateTime date)
		{
			return htmlHelper.Date(date, SiteConfiguration.Current.DateFormat);
		}

		#region Link
		public static MvcHtmlString Link(this HtmlHelper htmlHelper, string url)
		{
			return htmlHelper.Link(url, null);
		}

		public static MvcHtmlString Link(this HtmlHelper htmlHelper, string url, object htmlAttributes)
		{
			return htmlHelper.Link(null, url, htmlAttributes);
		}

		public static MvcHtmlString Link(this HtmlHelper htmlHelper, string innerHtml, string url)
		{
			return htmlHelper.Link(innerHtml, url, null);
		}

		public static MvcHtmlString Link(this HtmlHelper htmlHelper, string innerHtml, string url, object htmlAttributes)
		{
			IDictionary<string, object> htmlAttributesDictionay = ((IDictionary<string, object>)new RouteValueDictionary(htmlAttributes));
			TagBuilder builder = new TagBuilder("a");
			builder.MergeAttributes<string, object>(htmlAttributesDictionay);
			if (innerHtml == null)
			{
				builder.InnerHtml = url.Replace("http://", "");
			}
			else
			{
				builder.InnerHtml = innerHtml;
			}
			builder.Attributes.Add("href", url);
			return MvcHtmlString.Create(builder.ToString(TagRenderMode.Normal));
		} 
		#endregion

		public static MvcHtmlString CheckBoxBit<T>(this HtmlHelper htmlHelper, string name, T value, T expectedBit) where T : struct, IConvertible
		{
			if (!typeof(T).IsEnum) 
			{
				throw new ArgumentException("T must be an enumerated type");
			}

			return htmlHelper.CheckBox(name, (Convert.ToInt32(value) & Convert.ToInt32(expectedBit)) > 0, new{value = Convert.ToInt32(expectedBit)});
		}


		#region Captcha
		/// <summary>
		/// Returns a formItem with the captcha image in case the user has to validate his "humanity".
		/// </summary>
		/// <param name="labelText">Text to be shown in the label of the captcha field</param>
		public static MvcHtmlString Captcha(this HtmlHelper htmlHelper, string labelText)
		{
			if (htmlHelper.ViewData.GetDefault<bool>("ShowCaptcha"))
			{
				var builder = new TagBuilder("div");
				builder.AddCssClass("formItem");
				builder.AddCssClass("floatContainer");
				builder.AddCssClass("captcha");
				builder.InnerHtml = htmlHelper.Label("captcha", labelText).ToString();
				builder.InnerHtml += htmlHelper.TextBox("captcha");
				var imageBuilder = new TagBuilder("img");
				builder.InnerHtml += "<img src=\"" + htmlHelper.GetUrl("Captcha", "Base", null) + "\" alt=\"\" />";
				return MvcHtmlString.Create(builder.ToString());
			}
			else
			{
				return null;
			}
		} 
		#endregion

		#region GetUrl
		/// <summary>
		/// Generates a url based on the routeValues
		/// </summary>
		public static string GetUrl(this HtmlHelper htmlHelper, string actionName, string controllerName, object routeValues)
		{
			return UrlHelper.GenerateUrl(null, actionName, controllerName, new RouteValueDictionary(routeValues), htmlHelper.RouteCollection, htmlHelper.ViewContext.RequestContext, true);
		} 
		#endregion

		#region Partial
		public static MvcHtmlString Partial(this HtmlHelper htmlHelper, string partialViewName, object viewDataValues, bool createViewData)
		{
			if (createViewData)
			{
				return htmlHelper.Partial(partialViewName, ViewDataExtensions.CreateViewData(viewDataValues));
			}
			else
			{
				return htmlHelper.Partial(partialViewName, htmlHelper.ViewData);
			}
		} 
		#endregion
	}
}
