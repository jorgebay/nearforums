using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Autofac;
using Autofac.Integration.Mvc;
using System.Web.Mvc;
using NearForums.Configuration.Integration;

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

			AddIntegrationFilters(filters);

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

		/// <summary>
		/// Adds the filters that are included in the configuration
		/// </summary>
		/// <param name="filters">the filter list to add the integration filters to</param>
		protected virtual void AddIntegrationFilters(List<Filter> filters)
		{
			foreach (var filterElement in IntegrationConfiguration.Current.GlobalFilters)
			{
				var f = Activator.CreateInstance(filterElement.Type);
				if (!(f is NearForumsActionFilter))
				{
					throw new NotSupportedException("Registering action filters of type '" + filterElement.Type.FullName + "' is not supported. Action filter extensions must inherit from NearForumsActionFilter.");
				}
				filters.Add(new Filter(f, FilterScope.Action, null));
			}
		}
	}
}
