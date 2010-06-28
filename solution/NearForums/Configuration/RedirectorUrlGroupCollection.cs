using System;
using System.Data;
using System.Configuration;
using System.Linq;

namespace NearForums.Configuration
{
	public class RedirectorUrlGroupCollection : ConfigurationElementCollection
	{
		protected override ConfigurationElement CreateNewElement()
		{
			return new RedirectorUrlGroup();
		}

		protected override object GetElementKey(ConfigurationElement element)
		{
			return ((RedirectorUrlGroup)(element)).Regex;
		}

		public RedirectorUrlGroup this[int idx]
		{
			get
			{
				return (RedirectorUrlGroup)BaseGet(idx);
			}
		}
	}
}
