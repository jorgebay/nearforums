using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums
{
	public enum EmailPolicy: short
	{
		None = 0,
		SendFromSubscriptions = 1,
		SendNewsletter = 2
	}
}
