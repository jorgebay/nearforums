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
		/// <summary>
		/// Adds a range of values to the collection
		/// </summary>
		/// <param name="values"></param>
		public void AddRange(IEnumerable<T> values)
		{
			foreach (T item in values)
			{
				BaseAdd(item);
			}
		}

		/// <summary>
		/// Adds an item to the collection
		/// </summary>
		/// <param name="item">Item to add</param>
		public void Add(T item)
		{
			BaseAdd(item);
		}

		/// <summary>
		/// Creates a new instance of T
		/// </summary>
		/// <returns></returns>
		protected override ConfigurationElement CreateNewElement()
		{
			return new T();
		}

		/// <summary>
		/// Gets the key of a given element
		/// </summary>
		/// <param name="element"></param>
		/// <returns></returns>
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
			return this.OfType<T>().GetEnumerator();
		}
	}
}
