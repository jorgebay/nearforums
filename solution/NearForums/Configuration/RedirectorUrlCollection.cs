using System;
using System.Data;
using System.Configuration;
using System.Linq;
namespace NearForums.Configuration
{
	public class RedirectorUrlCollection : ConfigurationElementCollection
	{
		protected override ConfigurationElement CreateNewElement()
		{
			return new RedirectorUrl();
		}

		protected override object GetElementKey(ConfigurationElement element)
		{
			return ((RedirectorUrl)(element)).Regex;
		}

		public RedirectorUrl this[int idx]
		{
			get
			{
				return (RedirectorUrl)BaseGet(idx);
			}
		}
	}
}
