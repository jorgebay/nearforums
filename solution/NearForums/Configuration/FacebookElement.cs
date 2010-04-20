﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace NearForums.Configuration
{
	public class FacebookElement : ConfigurationElement
	{
		[ConfigurationProperty("apiKey", IsRequired = true)]
		public string ApiKey
		{
			get
			{
				return (string)this["apiKey"];
			}
			set
			{
				this["apiKey"] = value;
			}
		}

		[ConfigurationProperty("secretKey", IsRequired = true)]
		public string SecretKey
		{
			get
			{
				return (string)this["secretKey"];
			}
			set
			{
				this["secretKey"] = value;
			}
		}
	}
}