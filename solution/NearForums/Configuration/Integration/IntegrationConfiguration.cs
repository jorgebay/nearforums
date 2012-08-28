using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration.Integration
{
	/// <summary>
	/// Provides access to Nearforums integration (extensions) configuration
	/// </summary>
	public class IntegrationConfiguration : ConfigurationSection
	{
		/// <summary>
		/// Holds the list of filters for all actions
		/// </summary>
		private ConfigurationElementCollection<FilterElement> _globalFilters;
		/// <summary>
		/// Holds the list of filters that are declared at action level
		/// </summary>
		private Dictionary<string, ConfigurationElementCollection<FilterElement>> _actionFilters;
		private object _actionFiltersLock = new object();
		private static IntegrationConfiguration _config;

		#region Current
		/// <summary>
		/// Gets the current IntegrationConfiguration. 
		/// </summary>
		public static IntegrationConfiguration Current
		{
			get
			{
				if (_config == null)
				{
					_config = (IntegrationConfiguration)ConfigurationManager.GetSection("integration");
				}
				return _config;
			}
			set
			{
				_config = value;
			}
		}
		#endregion

		/// <summary>
		/// Configuration 
		/// </summary>
		[ConfigurationProperty("filters", IsRequired = false)]
		public ConfigurationElementCollection<FilterElement> Filters
		{
			get
			{
				return (ConfigurationElementCollection<FilterElement>)this["filters"];
			}
			set
			{
				this["filters"] = value;
			}
		}

		/// <summary>
		/// Gets the list of filters that are global (to be applied to all controllers)
		/// </summary>
		public ConfigurationElementCollection<FilterElement> GlobalFilters
		{
			get
			{
				if (_globalFilters == null)
				{
					_globalFilters = new ConfigurationElementCollection<FilterElement>();
					_globalFilters.AddRange(Filters.Where(f => String.IsNullOrEmpty(f.Controller)));
				}
				return _globalFilters;
			}
		}

		/// <summary>
		/// Gets the list of filters that are defined per action
		/// </summary>
		public ConfigurationElementCollection<FilterElement> GetActionFilters(string controllerName, string actionName)
		{
			lock (_actionFiltersLock)
			{
				if (_actionFilters == null)
				{
					_actionFilters = new Dictionary<string, ConfigurationElementCollection<FilterElement>>();
					var filters = Filters.Where(f => !(String.IsNullOrEmpty(f.Controller)) && !(String.IsNullOrEmpty(f.Action)));
					foreach (var f in filters)
					{
						var collection = new ConfigurationElementCollection<FilterElement>();
						if (_actionFilters.ContainsKey(GetActionFilterKey(controllerName, actionName)))
						{
							collection = _actionFilters[GetActionFilterKey(controllerName, actionName)];
						}
						else
						{
							_actionFilters.Add(GetActionFilterKey(controllerName, actionName), collection);
						}
						collection.Add(f);
					}
				}
			}
			ConfigurationElementCollection<FilterElement> result  = null;
			if (_actionFilters.ContainsKey(GetActionFilterKey(controllerName, actionName)))
			{
				result = _actionFilters[GetActionFilterKey(controllerName, actionName)];
			}
			return result;
		}

		protected virtual string GetActionFilterKey(string controllerName, string actionName)
		{
			return controllerName.ToUpper() + "-" + actionName.ToUpper();
		}
	}
}
