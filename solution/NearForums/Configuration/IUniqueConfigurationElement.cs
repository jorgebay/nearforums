using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums.Configuration
{
	/// <summary>
	/// Defines a property (key) to uniquely identify a configuration element
	/// </summary>
	public interface IUniqueConfigurationElement
	{
		/// <summary>
		/// Unique key
		/// </summary>
		string Key 
		{ 
			get; 
		}
	}
}
