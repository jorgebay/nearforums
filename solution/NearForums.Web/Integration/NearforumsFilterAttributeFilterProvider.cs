using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Autofac;
using Autofac.Integration.Mvc;
using System.Web.Mvc;

namespace NearForums.Web.Integration
{
	public class NearforumsFilterAttributeFilterProvider : FilterAttributeFilterProvider
	{
		/// <summary>
		/// Initializes a new instance of the <see cref="NearforumsFilterAttributeFilterProvider"/> class.
		/// </summary>
		public NearforumsFilterAttributeFilterProvider()
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
			var filters = base.GetFilters(controllerContext, actionDescriptor).ToArray();
			//TODO: add filters
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
