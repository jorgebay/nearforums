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
		private ConfigurationElementCollection<FilterElement> _globalFilters;
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
	}
}
