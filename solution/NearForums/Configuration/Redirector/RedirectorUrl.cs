using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Configuration;

namespace NearForums.Configuration.Redirector
{
	public class RedirectorUrl : ConfigurationElement, IUniqueConfigurationElement
	{
		/// <summary>
		/// Regex to match the url againts
		/// </summary>
		[ConfigurationProperty("regex", IsRequired = true)]
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

		/// <summary>
		/// Regex replacement for the match ($1, $2)
		/// </summary>
		[ConfigurationProperty("replacement", IsRequired = true)]
		public string Replacement
		{
			get
			{
				return (string)this["replacement"];
			}
			set
			{
				this["replacement"] = value;
			}
		}

		/// <summary>
		/// Regular expression to match the request header agains
		/// </summary>
		[ConfigurationProperty("headerRegex", IsRequired = false)]
		public string HeaderRegex
		{
			get
			{
				return (string)this["headerRegex"];
			}
			set
			{
				this["headerRegex"] = value;
			}
		}

		/// <summary>
		/// Http status code returned to the user agent 
		/// (301: Moved permanently by default)
		/// </summary>
		[ConfigurationProperty("responseStatus", IsRequired = false, DefaultValue=301)]
		public int ResponseStatus
		{
			get
			{
				return (int)this["responseStatus"];
			}
			set
			{
				this["responseStatus"] = value;
			}
		}

		/// <summary>
		/// Creates a new instance of RedirectorUrl
		/// </summary>
		public RedirectorUrl()
		{

		}

		/// <summary>
		/// Creates a new instance of RedirectorUrl
		/// </summary>
		public RedirectorUrl(string regex, string replacement)
		{
			Regex = regex;
			Replacement = replacement;
		}

		#region IUniqueConfigurationElement Members
		public string Key
		{
			get 
			{ 
				return Regex; 
			}
		}
		#endregion
	}
}
