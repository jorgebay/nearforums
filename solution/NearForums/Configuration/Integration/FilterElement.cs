﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration.Integration
{
	public class FilterElement : ConfigurationElement, IUniqueConfigurationElement
	{
		/// <summary>
		/// Gets or sets a action filter Type name.
		/// A comma-separated list containing the module type name and the assembly information.
		/// </summary>
		[ConfigurationProperty("type", IsRequired = true)]
		public string Type
		{
			get
			{
				return (string)this["type"];
			}
			set
			{
				this["type"] = value;
			}
		}

		/// <summary>
		/// Name of the controller which actions will be filtered
		/// </summary>
		[ConfigurationProperty("controller", IsRequired = false, DefaultValue = "")]
		public string Controller
		{
			get
			{
				return (string)this["controller"];
			}
			set
			{
				this["controller"] = value;
			}
		}

		/// <summary>
		/// Name of the controller action in which the actionfilter will be executed.
		/// </summary>
		[ConfigurationProperty("action", IsRequired = false, DefaultValue = "")]
		public string Action
		{
			get
			{
				return (string)this["action"];
			}
			set
			{
				this["action"] = value;
			}
		}

		/// <summary>
		/// Order relative to the other action filters
		/// </summary>
		[ConfigurationProperty("order", IsRequired = false)]
		public int? Order
		{
			get
			{
				return (int?)this["order"];
			}
			set
			{
				this["order"] = value;
			}
		}

		#region IUniqueConfigurationElement Members
		public string Key
		{
			get 
			{
				return Type + "-" + Controller + "-" + Action;
			}
		}
		#endregion
	}
}
