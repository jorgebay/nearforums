using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace NearForums.Validation
{
	public class ValidationAttribute : Attribute
	{

	}

	public class RequireFieldAttribute : ValidationAttribute
	{

	}

	public class RangeAttribute : ValidationAttribute
	{
		public object MinValue
		{
			get;
			set;
		}

		public object MaxValue
		{
			get;
			set;
		}

		public RangeAttribute(object minValue, object maxValue)
		{
			this.MinValue = minValue;
			this.MaxValue = maxValue;
		}
	}

	public class LengthAttribute : ValidationAttribute
	{
		public int MaxLength
		{
			get;
			set;
		}
		public int MinLength
		{
			get;
			set;
		}

		public LengthAttribute(int minLength, int maxLength)
		{
			this.MinLength = minLength;
			this.MaxLength = maxLength;
		}

		public LengthAttribute(int maxLength)
		{
			this.MaxLength = maxLength;
		}
	}

	public class RegexFormatAttribute : ValidationAttribute
	{
		public string Regex
		{
			get;
			set;
		}

		public RegexOptions RegexOptions
		{
			get;
			set;
		}

		private RegexFormatAttribute()
		{
			this.RegexOptions = RegexOptions.None;
		}

		public RegexFormatAttribute(string regex)
		{
			this.Regex = regex;
		}

		public RegexFormatAttribute(string regex, RegexOptions options)
		{
			this.Regex = regex;
			this.RegexOptions = options;
		}
	}

	public class EmailFormatAttribute : RegexFormatAttribute
	{
		public EmailFormatAttribute()
			: base(@"^[\w\.=-]+@[\w\.-]+\.[\w]{2,3}$")
		{

		}
	}

	public class BirthdayAttribute : RangeAttribute
	{
		public BirthdayAttribute()
			: base(new DateTime(1900, 1, 1), DateTime.Today)
		{

		}
	}
}
