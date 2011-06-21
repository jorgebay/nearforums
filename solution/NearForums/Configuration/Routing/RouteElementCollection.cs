using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration.Routing
{
	public class RouteElementCollection : ConfigurationElementCollection
	{
		public void Add(RouteElement element)
		{
			BaseAdd(element);
		}

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
