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
using NearForums.Localization;

namespace NearForums.Web.Extensions
{
	public static class HtmlExtensions
	{
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

		/// <summary>
		/// Evaluates the condition and returns the resulting expression.
		/// </summary>
		/// <param name="condition"></param>
		/// <param name="textIfTrue"></param>
		/// <param name="textIfFalse"></param>
		/// <returns></returns>
		public static MvcHtmlString If(this HtmlHelper htmlHelper, bool condition, string textIfTrue, string textIfFalse = null)
		{
			if (condition)
			{
				return MvcHtmlString.Create(textIfTrue);
			}
			else
			{
				return MvcHtmlString.Create(textIfFalse);
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
			builder.AddCssClass("datetime");
			builder.AddCssClass("d" + appDate.Year + "-" + appDate.Month + "-" + appDate.Day + "-" + appDate.Hour + "-" + appDate.Minute);
			builder.InnerHtml = appDate.ToString(format);
			return MvcHtmlString.Create(builder.ToString());
		}

		/// <summary>
		/// Converts date to app datetime and applies configuration defined date format
		/// </summary>
		public static MvcHtmlString Date(this HtmlHelper htmlHelper, DateTime date)
		{
			return htmlHelper.Date(date, SiteConfiguration.Current.UI.DateFormat);
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

		/// <summary>
		/// Returns an anchor element with the innerText localized
		/// </summary>
		public static MvcHtmlString LinkLocalized(this HtmlHelper htmlHelper, string innerHtml, string url, object htmlAttributes)
		{
			IDictionary<string, object> htmlAttributesDictionay = ((IDictionary<string, object>)new RouteValueDictionary(htmlAttributes));
			TagBuilder builder = new TagBuilder("a");
			builder.MergeAttributes<string, object>(htmlAttributesDictionay);
			builder.InnerHtml = Localizer.Current.Get(innerHtml);
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

		#region Script, style sheets and images
		/// <summary>
		/// Script tag, enforces to be app relative
		/// </summary>
		public static MvcHtmlString Script(this HtmlHelper htmlHelper, string url)
		{
			ValidateApplicationUrl(url);
			if (url[0] == '~')
			{
				url = url.ToLower();
			}
			
			TagBuilder builder = new TagBuilder("script");
			builder.Attributes.Add("type", "text/javascript");
			builder.Attributes.Add("src", UrlHelper.GenerateContentUrl(url, htmlHelper.ViewContext.HttpContext));
			return MvcHtmlString.Create(builder.ToString(TagRenderMode.Normal));
		}

		/// <summary>
		/// Jquery script tag (current version)
		/// </summary>
		public static MvcHtmlString ScriptjQuery(this HtmlHelper htmlHelper)
		{
			return htmlHelper.Script(SiteConfiguration.Current.UI.Resources.JQueryUrl);
		}

		/// <summary>
		/// Add a link tag referencing the stylesheet, enforcing the url to be app relative.
		/// </summary>
		public static MvcHtmlString Stylesheet(this HtmlHelper htmlHelper, string url)
		{
			ValidateApplicationUrl(url);
			if (url[0] == '~')
			{
				url = url.ToLower();
			}

			TagBuilder builder = new TagBuilder("link");
			builder.Attributes.Add("type", "text/css");
			builder.Attributes.Add("rel", "stylesheet");
			builder.Attributes.Add("href", UrlHelper.GenerateContentUrl(url, htmlHelper.ViewContext.HttpContext));
			return MvcHtmlString.Create(builder.ToString(TagRenderMode.SelfClosing));
		}

		/// <summary>
		/// Add a image tag referencing, enforcing the url to be app relative.
		/// </summary>
		public static MvcHtmlString Img(this HtmlHelper htmlHelper, string url, string alt)
		{
			ValidateApplicationUrl(url);
			if (url[0] == '~')
			{
				url = url.ToLower();
			}

			TagBuilder builder = new TagBuilder("img");
			builder.Attributes.Add("alt", alt);
			builder.Attributes.Add("src", UrlHelper.GenerateContentUrl(url, htmlHelper.ViewContext.HttpContext));
			return MvcHtmlString.Create(builder.ToString(TagRenderMode.SelfClosing));
		}

		/// <summary>
		/// Validates that the url is absolute or starts with tilde (~) char.
		/// </summary>
		/// <param name="url"></param>
		private static void ValidateApplicationUrl(string url)
		{
			if (String.IsNullOrEmpty(url))
			{
				throw new ArgumentNullException("url");
			}
			if (!(url.StartsWith("http://") || url.StartsWith("https://") || url.StartsWith("~/") || url.StartsWith("//")))
			{
				throw new ArgumentException("Url must start tilde character '~' or be absolute.", "url");
			}
		}
		#endregion

		#region ActionLink Localized
		/// <summary>
		/// Returns an anchor element (a element) that contains the virtual path of the specified action, with localized anchor text.
		/// </summary>
		public static MvcHtmlString ActionLinkLocalized(this HtmlHelper htmlHelper, string neutralLinkText, string actionName, string controllerName)
		{
			var linkText = Localizer.Current.Get(neutralLinkText);
			return htmlHelper.ActionLink(linkText, actionName, controllerName);
		}

		/// <summary>
		/// Returns an anchor element (a element) that contains the virtual path of the specified action, with localized anchortext.
		/// </summary>
		public static MvcHtmlString ActionLinkLocalized(this HtmlHelper htmlHelper, string neutralLinkText, string actionName)
		{
			var linkText = Localizer.Current.Get(neutralLinkText);
			return htmlHelper.ActionLink(linkText, actionName);
		}

		/// <summary>
		/// Returns an anchor element (a element) that contains the virtual path of the specified action, with localized anchor text.
		/// </summary>
		public static MvcHtmlString ActionLinkLocalized(this HtmlHelper htmlHelper, string neutralLinkText, string actionName, object routeValues)
		{
			var linkText = Localizer.Current.Get(neutralLinkText);
			return htmlHelper.ActionLink(linkText, actionName, routeValues);
		}

		/// <summary>
		/// Returns an anchor element (a element) that contains the virtual path of the specified action, with localized anchor text.
		/// </summary>
		public static MvcHtmlString ActionLinkLocalized(this HtmlHelper htmlHelper, string neutralLinkText, string actionName, string controllerName, object routeValues, object htmlAttributes)
		{
			var linkText = Localizer.Current.Get(neutralLinkText);
			return htmlHelper.ActionLink(linkText, actionName, controllerName, routeValues, htmlAttributes);
		}

		/// <summary>
		/// Returns an anchor element (a element) that contains the virtual path of the specified action, with localized anchor text.
		/// </summary>
		public static MvcHtmlString ActionLinkLocalized(this HtmlHelper htmlHelper, string neutralLinkText, string actionName, object routeValues, object htmlAttributes)
		{
			var linkText = Localizer.Current.Get(neutralLinkText);
			return htmlHelper.ActionLink(linkText, actionName, routeValues, htmlAttributes);
		}
		#endregion

		#region Localized Label
		/// <summary>
		/// An HTML label element and the property name of the property that is represented by the expression
		/// </summary>
		/// <typeparam name="TModel"></typeparam>
		/// <typeparam name="TValue"></typeparam>
		/// <param name="html"></param>
		/// <param name="expression"></param>
		/// <param name="neutralLabel">Neutral value of the label text that will be translated</param>
		/// <returns></returns>
		public static MvcHtmlString LocalizedLabelFor<TModel, TValue>(this HtmlHelper<TModel> html, string neutralLabel, Expression<Func<TModel, TValue>> expression)
		{
			return html.LabelFor(expression, Localizer.Current[neutralLabel]);
		}
		#endregion
	}
}
