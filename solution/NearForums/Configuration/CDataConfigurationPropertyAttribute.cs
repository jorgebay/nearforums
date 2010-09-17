using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums.Configuration
{
	[AttributeUsage(AttributeTargets.Property)]
	public sealed class CDataConfigurationPropertyAttribute
		: Attribute
	{
	}
}
