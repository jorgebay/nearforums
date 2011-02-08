using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	public class RouteElementCollection : ConfigurationElementCollection
	{
		protected override ConfigurationElement CreateNewElement()
		{
			return new RouteElement();
		}

		protected override object GetElementKey(ConfigurationElement element)
		{
			return ((RouteElement)(element)).Url;
		}

		public RouteElement this[int index]
		{
			get
			{
				return (RouteElement)BaseGet(index);
			}
		}
	}
}
