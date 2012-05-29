using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.IO;

namespace NearForums.Configuration
{
	public class SearchElement : ConfigurationElement
	{
		public SiteConfiguration ParentElement
		{
			get;
			set;
		}

		/// <summary>
		/// Gets the index file path.
		/// </summary>
		public string IndexPath
		{
			get
			{
				return Path.Combine(ParentElement.ContentPathFull, "search-index");
			}
		}
	}
}
