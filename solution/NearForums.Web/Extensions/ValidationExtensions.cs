using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using System.Web.Mvc.Html;
using NearForums.Validation;
using System.Web.Routing;

namespace NearForums.Web.Extensions
{
	public static class ValidationExtensions
	{
		public static MvcHtmlString ValidationSummary(this HtmlHelper htmlHelper, Dictionary<string, object> errorMessages, object htmlAttributes)
		{
			return htmlHelper.ValidationSummary(null, errorMessages, htmlAttributes);

		}

		public static MvcHtmlString ValidationSummary(this HtmlHelper htmlHelper, string title, Dictionary<string, object> errorMessages, object htmlAttributes)
		{
			if (htmlHelper.ViewData.ModelState.IsValid)
			{
				return null;
			}
			TagBuilder ulTag = new TagBuilder("ul");
			StringBuilder ulChilds = new StringBuilder();
			ulTag.MergeAttributes<string, object>(((IDictionary<string, object>)new RouteValueDictionary(htmlAttributes)));
			ulTag.MergeAttribute("class", "validation-summary-errors");
			foreach (KeyValuePair<string, ModelState> modelEntry in htmlHelper.ViewData.ModelState)
			{
				foreach (ModelError modelError in modelEntry.Value.Errors)
				{
					TagBuilder liTag = new TagBuilder("li");
					if (modelError.Exception is ValidationError)
					{
						liTag.SetInnerText(GetMessage(errorMessages, modelEntry.Key, (ValidationError)modelError.Exception));
					}
					else if (errorMessages.Keys.Contains(modelEntry.Key))
					{
						liTag.SetInnerText(GetMessage(errorMessages, modelEntry.Key, modelError.Exception));
					}
					else
					{
						liTag.SetInnerText(modelError.ErrorMessage);
					}
					if (!String.IsNullOrEmpty(liTag.InnerHtml))
					{
						ulChilds.AppendLine(liTag.ToString(TagRenderMode.Normal));
					}
				}
			}
			ulTag.InnerHtml = ulChilds.ToString();

			StringBuilder result = new StringBuilder();
			if (title != null)
			{
				result.AppendLine(title);
			}
			result.AppendLine(ulTag.ToString(TagRenderMode.Normal));

			return MvcHtmlString.Create(result.ToString());
		}

		public static string GetMessage(Dictionary<string, object> errorMessages, string key, Exception ex)
		{
			string result = key + " invalid.";
			if (errorMessages.Keys.Contains(key))
			{
				object messages = errorMessages[key];
				if (messages is string)
				{
					result = messages.ToString();
				}
				else if (messages is Dictionary<ValidationErrorType, string>)
				{
					Dictionary<ValidationErrorType, string> messagesTyped = (Dictionary<ValidationErrorType, string>)messages;
					if (ex is ValidationError)
					{
						ValidationError exTyped = (ValidationError)ex;
						if (messagesTyped.Keys.Contains(exTyped.Type))
						{
							result = messagesTyped[exTyped.Type];
						}
						else
						{
							throw new ArgumentException("Message not defined for type: " + exTyped.Type.ToString() + " and key: " + key);
						}
					}
				}
			}
			return result;
		}
	}
}
