using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums.Web.State
{
	[Serializable]
	public class ProviderInfo
	{
		public ProviderInfo()
		{
			AllowChangeEmail = true;
		}

		/// <summary>
		/// Determines if the provider allows to change the email
		/// </summary>
		public bool AllowChangeEmail { get; set; }

		public AuthenticationProvider Provider { get; set; }

		public string EditAccountUrl { get; set; }
	}
}
