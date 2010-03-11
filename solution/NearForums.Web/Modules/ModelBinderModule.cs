using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;

namespace NearForums.Web.Modules
{
	public class ModelBinderModule : IHttpModule
	{
		#region IHttpModule Members
		public void Dispose()
		{

		}

		public void Init(HttpApplication context)
		{
			//ModelBinders.Binders[typeof(HttpPostedFileBase)] = new HttpPostedFileModelBinder();
			ModelBinders.Binders[typeof(TagList)] = new TagListModelBinder();
		}
		#endregion
	}

	#region Model binders
	//To be practical I will just include it in one file.

	public class TagListModelBinder : IModelBinder
	{
		public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
		{
			if (bindingContext.ValueProvider[bindingContext.ModelName] != null)
			{
				string attemptedValue = bindingContext.ValueProvider[bindingContext.ModelName].AttemptedValue;
				bindingContext.ModelState.SetModelValue(bindingContext.ModelName, new ValueProviderResult(bindingContext.ValueProvider[bindingContext.ModelName].RawValue, attemptedValue, System.Globalization.CultureInfo.CurrentCulture));
				if (attemptedValue.Trim() != "")
				{
					return new TagList(attemptedValue.Trim());
				}
				else
				{
					return null;
				}
			}
			return null;
		}
	} 
	#endregion
}
