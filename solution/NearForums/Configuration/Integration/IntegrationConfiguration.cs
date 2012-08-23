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
		#region Current
		private static IntegrationConfiguration _config;
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
	}
}
