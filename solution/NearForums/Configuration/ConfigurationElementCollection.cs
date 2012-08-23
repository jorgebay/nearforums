using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.Collections;

namespace NearForums.Configuration
{
	/// <summary>
	/// Defines a generic collection for ConfigurationElement.
	/// The ConfigurationElement must contain a key (implementing IUniqueConfigurationElement)
	/// </summary>
	/// <typeparam name="T"></typeparam>
	public class ConfigurationElementCollection<T> : System.Configuration.ConfigurationElementCollection, IEnumerable<T> where T : ConfigurationElement, IUniqueConfigurationElement, new()
	{
		protected override ConfigurationElement CreateNewElement()
		{
			return new T();
		}

		protected override object GetElementKey(ConfigurationElement element)
		{
			return ((IUniqueConfigurationElement)element).Key;
		}

		public override bool IsReadOnly()
		{
			return false;
		}

		/// <summary>
		/// Typed Enumerator
		/// </summary>
		/// <returns></returns>
		public new IEnumerator<T> GetEnumerator()
		{
			return (IEnumerator<T>)base.GetEnumerator();
		}
	}
}
