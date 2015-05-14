using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace photo_hdr_duval.Validation
{
	public class DateLimiteAttribute : ValidationAttribute
	{

		public DateLimiteAttribute()
			: base()
		{

		}

		public override ValidationResult IsValid(object value, ValidationContext validationContext)
		{
			DateTime date = new DateTime();
			if (value != null)
			{
				/*
				DateTime valeurAValider = (DateTime)value;
				if (DateTime.Compare(valeurAValider, DateTime.Now()))
				{
					var ErrorMessage = FormatErrorMessage(validationContext.DisplayName);
					return new ValidationResult(ErrorMessage);
				}*/
			}
			return ValidationResult.Success;
		}

	}
}