using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	public class ConfigurationElementCollection<T> : System.Configuration.ConfigurationElementCollection where T : ConfigurationElement, IUniqueConfigurationElement, new()
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
	}
}
