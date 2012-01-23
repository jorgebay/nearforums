using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums.Web.State
{
	public class ProviderInfo
	{
		public ProviderInfo()
		{
			AllowChangeEmail = true;
		}

		public bool AllowChangeEmail
		{
			get;
			set;
		}

		public string EditAccountUrl
		{
			get;
			set;
		}
	}
}
