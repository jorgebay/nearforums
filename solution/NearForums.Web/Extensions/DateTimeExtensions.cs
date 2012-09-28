using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.Configuration;

namespace NearForums.Web.Extensions
{
	public static class DateTimeExtensions
	{
		public static DateTime ToApplicationDateTime(this DateTime date)
		{
			if (date.Kind == DateTimeKind.Utc)
			{
				if (SiteConfiguration.Current.General.TimeZoneOffset.HasValue)
				{
					return DateTime.SpecifyKind(date.Add(SiteConfiguration.Current.General.TimeZoneOffset.Value), DateTimeKind.Local);
				}
				else
				{
					return date.ToLocalTime();
				}
			}
			return date;
		}
	}
}
