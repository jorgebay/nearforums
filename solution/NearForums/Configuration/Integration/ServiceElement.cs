using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration.Integration
{
	public class ServiceElement: TypeElement, IUniqueConfigurationElement
	{
		#region IUniqueConfigurationElement Members
		public string Key
		{
			get { return TypeName; }
		}
		#endregion

		/// <summary>
		/// Gets or sets the service it will provide.
		/// A comma-separated list containing the module type name and the assembly information.
		/// </summary>
		[ConfigurationProperty("as", IsRequired = false)]
		public string AsName
		{
			get
			{
				return (string)this["as"];
			}
			set
			{
				this["as"] = value;
			}
		}

		/// <summary>
		/// Gets the type for which the service will be provided (specified on the AsName)
		/// </summary>
		/// <exception cref="TypeLoadException">Throws a TypeLoadException when the type can not be loaded</exception>
		public Type As
		{
			get
			{
				Type type = null;
				if (!String.IsNullOrEmpty(AsName))
				{
					type = Type.GetType(AsName);
					if (type == null)
					{
						throw new TypeLoadException("Could not load Type: " + AsName);
					}
				}
				return type;
			}
		}
	}
}
