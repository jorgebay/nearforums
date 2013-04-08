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
			: base(@"^[\w\.=-]+@[\w\.-]+\.[\w]{2,3}$", RegexOptions.IgnoreCase)
		{

		}
	}

    public class NumericAttribute : RegexFormatAttribute
    {
        public NumericAttribute()
            : base(@"([1-9][0-9]*)", RegexOptions.IgnoreCase)
        {

        }

        
    }

	public class UrlFormatAttribute : RegexFormatAttribute
	{
		public UrlFormatAttribute()
			: base(@"^https?://[-A-Z0-9+&@#/%?=~_|!:,.;]*[-A-Z0-9+&@#/%=~_|]$", RegexOptions.IgnoreCase)
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

	public class PostGreaterThanReadRightsAttribute : ValidationAttribute
	{
		public bool IsValid(object value, object containerInstance)
		{
			if (containerInstance == null)
			{
				throw new ArgumentNullException("containerInstance");
			}
			var instance = containerInstance as IAccessRightContainer;
			if (instance == null)
			{
				throw new InvalidCastException("PostGreaterThanReadRights validation only applies for instance of IAccessRightContainer");
			}
			if (instance.ReadAccessRole > instance.PostAccessRole)
			{
				return false;
			}
			return true;
		}
	}
}
