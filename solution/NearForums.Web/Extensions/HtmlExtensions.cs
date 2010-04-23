using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using System.Globalization;
using System.Web.Routing;
using System.Web.Mvc.Html;
using System.Text.RegularExpressions;
using System.Security;
using NearForums.Configuration;
using System.Collections;

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

		public static string MetaDescription(this HtmlHelper htmlHelper, string content)
		{
			if (content != null)
			{
				TagBuilder builder = new TagBuilder("meta");
				builder.Attributes.Add("name", "description");
				content = Regex.Replace(content, "\r|\n", "");
				content = Regex.Replace(content, "(&nbsp;)+|(\t+)", " ");
				builder.Attributes.Add("content", SecurityElement.Escape(content));

				return builder.ToString(TagRenderMode.SelfClosing);
			}
			else
			{
				return null;
			}
		}

		public static string DropDownListDefault(this HtmlHelper htmlHelper, string name, IEnumerable<SelectListItem> selectList, object defaultValue, string defaultText)
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

		public static string Date(this HtmlHelper htmlHelper, DateTime date, string format)
		{
			DateTime appDate = date.ToApplicationDateTime();
			TagBuilder builder = new TagBuilder("span");
			builder.AddCssClass("date");
			builder.AddCssClass("d" + appDate.Year + "-" + appDate.Month + "-" + appDate.Day + "-" + appDate.Hour + "-" + appDate.Minute);
			builder.InnerHtml = appDate.ToString(format);
			return builder.ToString();
		}

		public static string Date(this HtmlHelper htmlHelper, DateTime date)
		{
			return htmlHelper.Date(date, SiteConfiguration.Current.DateFormat);
		}

		public static string Link(this HtmlHelper htmlHelper, string url)
		{
			return htmlHelper.Link(url, null);
		}

		public static string Link(this HtmlHelper htmlHelper, string url, object htmlAttributes)
		{
			IDictionary<string, object> htmlAttributesDictionay = ((IDictionary<string, object>) new RouteValueDictionary(htmlAttributes));
			TagBuilder builder = new TagBuilder("a");
			builder.MergeAttributes<string, object>(htmlAttributesDictionay);
			builder.InnerHtml = url.Replace("http://", "");
			builder.Attributes.Add("href", url);
			return builder.ToString(TagRenderMode.Normal);
		}
	}
}
