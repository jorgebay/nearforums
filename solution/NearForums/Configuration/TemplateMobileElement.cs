using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	public class TemplateMobileElement : ConfigurationElement, IOptionalElement
	{
		/// <summary>
		/// User agent regular expression
		/// </summary>
		[ConfigurationProperty("regex")]
		public string Regex
		{
			get
			{
				return (string)this["regex"];
			}
			set
			{
				this["regex"] = value;
			}
		}

		#region IOptionalElement Members
		public bool IsDefined
		{
			get
			{
				return (!String.IsNullOrEmpty(this.Regex));
			}
		}
		#endregion
	}
}
