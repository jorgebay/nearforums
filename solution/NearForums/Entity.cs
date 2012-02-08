using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.Validation;
using System.Reflection;
using System.Text.RegularExpressions;

namespace NearForums
{
	public abstract class Entity : IEnsureValidation
	{
		/// <summary>
		/// 
		/// </summary>
		/// <exception cref="ValidationException"></exception>
		protected List<ValidationError> ValidateFields(bool throwErrors)
		{
			List<ValidationError> errors = new List<ValidationError>();
			Type t = this.GetType();
			foreach (PropertyInfo property in t.GetProperties(BindingFlags.Instance | BindingFlags.Public))
			{
				ValidationAttribute[] attributes = (ValidationAttribute[])property.GetCustomAttributes(typeof(ValidationAttribute), true);
				if (attributes != null && attributes.Length > 0)
				{
					foreach (ValidationAttribute attribute in attributes)
					{
						object value = property.GetValue(this, null);
						if (attribute is RequireFieldAttribute)
						{
							#region Required
							if (value == null)
							{
								errors.Add(new ValidationError(property.Name, ValidationErrorType.NullOrEmpty));
								break;
							}
							else if (value is string)
							{
								if (value.ToString() == "")
								{
									errors.Add(new ValidationError(property.Name, ValidationErrorType.NullOrEmpty));
									break;
								}
							}
							#endregion
						}
						else if (attribute is RangeAttribute)
						{
							#region Range
							if (value != null)
							{
								RangeAttribute rangeAttribute = (RangeAttribute)attribute;
								if (value is IComparable)
								{
									if (((IComparable)value).CompareTo(rangeAttribute.MinValue) < 0 || ((IComparable)value).CompareTo(rangeAttribute.MaxValue) > 0)
									{
										errors.Add(new ValidationError(property.Name, ValidationErrorType.Range));
									}
								}
								else
								{
									throw new ArgumentException("RangeAttribute only applies to IComparable fields.");
								}
							}
							#endregion
						}
						else if (attribute is LengthAttribute)
						{
							#region Length
							if (value != null)
							{
								LengthAttribute lengthAttribute = (LengthAttribute)attribute;
								if (value is string)
								{
									if (((string)value).Length > 0)
									{
										if (((string)value).Length > lengthAttribute.MaxLength)
										{
											errors.Add(new ValidationError(property.Name, ValidationErrorType.MaxLength));
										}
										if (lengthAttribute.MinLength > 0)
										{
											if (((string)value).Length < lengthAttribute.MinLength)
											{
												errors.Add(new ValidationError(property.Name, ValidationErrorType.MinLength));
											}
										}
									}
								}
								else
								{
									throw new ArgumentException("LengthAttribute only applies to string fields.");
								}
							}
							#endregion
						}
						else if (attribute is RegexFormatAttribute)
						{
							#region Regex
							if (value != null)
							{
								RegexFormatAttribute regexAttribute = (RegexFormatAttribute)attribute;
								if (value.ToString() != "" && !Regex.IsMatch(value.ToString(), regexAttribute.Regex, regexAttribute.RegexOptions))
								{
									errors.Add(new ValidationError(property.Name, ValidationErrorType.Format));
								}
							}
							#endregion
						}
						else if (attribute is PostGreaterThanReadRightsAttribute)
						{
							if (!((PostGreaterThanReadRightsAttribute)attribute).IsValid(value, this))
							{
								errors.Add(new ValidationError(property.Name, ValidationErrorType.CompareNotMatch));
							}
						}
					}
				}
			}

			if (errors.Count > 0 && throwErrors)
			{
				throw new ValidationException(errors);
			}

			return errors;
		}

		/// <exception cref="ValidationException"></exception>
		public virtual void ValidateFields()
		{
			this.ValidateFields(true);
		}
	}
}
