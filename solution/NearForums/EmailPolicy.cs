using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums
{
	public enum EmailPolicy: short
	{
		/// <summary>
		/// Default policy
		/// </summary>
		None = 0,
		/// <summary>
		/// Determines if the system should send a message to notify of new messages on topics the user subscribed to.
		/// </summary>
		SendFromSubscriptions = 1,
		/// <summary>
		/// Send site newsletter
		/// </summary>
		SendNewsletter = 2
	}
}
