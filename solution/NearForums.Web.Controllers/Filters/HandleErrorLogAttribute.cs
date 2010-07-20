using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using System.Web;
using NearForums.ServiceClient;

namespace NearForums.Web.Controllers.Filters
{
	public class HandleErrorLogAttribute : HandleErrorAttribute
	{
		public override void OnException(ExceptionContext filterContext)
		{
			if ((!filterContext.ExceptionHandled) && filterContext.HttpContext.IsCustomErrorEnabled)
			{
				LoggerServiceClient.LogError(filterContext.Exception);
			}
			base.OnException(filterContext);
		}

		///// <summary>
		///// Based on with type of exception and stacktrace, 
		///// it determines if the exception should be logged as a warning
		///// </summary>
		//protected virtual bool IsWarning(Exception ex)
		//{
		//    bool isWarning = false;

		//    switch (ex.GetType().Name)
		//    {
		//        case "ArgumentException":
		//            if (ex.StackTrace.Contains("Mvc.ReflectedActionDescriptor.ExtractParameterFromDictionary"))
		//            {
		//                //The parameters of the action are incorrect (based on the constrains and parameter definition.
		//                isWarning = true;
		//            }
		//            break;
		//        case "HttpRequestValidationException":
		//            //A potentially dangerous request.form posted.
		//            isWarning = true;
		//            break;
		//    }

		//    return isWarning;
		//} 
	}
}
