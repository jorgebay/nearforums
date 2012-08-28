using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration.Integration
{
	/// <summary>
	/// Represents a configuration element that has a property Type (System.Type)
	/// </summary>
	public class TypeElement: ConfigurationElement
	{
		/// <summary>
		/// Gets or sets a action filter Type name.
		/// A comma-separated list containing the module type name and the assembly information.
		/// </summary>
		[ConfigurationProperty("type", IsRequired = true)]
		public string TypeName
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
		/// Gets the Type specified on the TypeName
		/// </summary>
		/// <exception cref="TypeLoadException">Throws a TypeLoadException when the type can not be loaded</exception>
		public Type Type
		{
			get
			{
				var type = Type.GetType(TypeName);
				if (type == null)
				{
					throw new TypeLoadException("Could not load Type: " + TypeName);
				}
				return type;
			}
		}
	}
}
