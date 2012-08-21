using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Autofac;
using Autofac.Integration.Mvc;
using System.Web.Mvc;

namespace NearForums.Web.Integration
{
	public class NearForumsFilterProvider : FilterAttributeFilterProvider
	{
		/// <summary>
		/// Initializes a new instance of the <see cref="NearForumsFilterProvider"/> class.
		/// </summary>
		public NearForumsFilterProvider()
			: base(false)
		{
		}

		/// <summary>
		/// Aggregates the filters from all of the filter providers into one collection.
		/// </summary>
		/// <returns>
		/// The collection filters from all of the filter providers with properties injected.
		/// </returns>
		public override IEnumerable<Filter> GetFilters(ControllerContext controllerContext, ActionDescriptor actionDescriptor)
		{
			var filters = base.GetFilters(controllerContext, actionDescriptor).ToList();

			//var f = Activator.CreateInstance(Type.GetType("NearForums.Web.Integration.DerivedActionFilter, NearForums.Web")) as NearForumsActionFilter;
			//filters.Add(new Filter(f, FilterScope.Action, null));
			
			var scope = AutofacDependencyResolver.Current.RequestLifetimeScope;
			if (scope != null)
			{
				foreach (var filter in filters)
				{
					scope.InjectProperties(filter.Instance);
				}
			}
			return filters;
		}
	}
}
