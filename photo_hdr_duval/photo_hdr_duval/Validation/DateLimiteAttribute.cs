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

		protected override ValidationResult IsValid(object value, ValidationContext validationContext)
		{
			if (value != null)
			{

				DateTime datePlus15 = DateTime.Now.AddDays(15);
				DateTime valeurAValider = (DateTime)value;
				if (DateTime.Compare(valeurAValider, DateTime.Now) <= 0)
				{
					var ErrorMessage = FormatErrorMessage(validationContext.DisplayName);
					return new ValidationResult("*La date de rendez-vous ne peut pas être aujourd'hui");
				}
				else if (DateTime.Compare(valeurAValider, datePlus15) >= 0)
				{
					var ErrorMessage = FormatErrorMessage(validationContext.DisplayName);
					return new ValidationResult("*La date de rendez-vous doit être avant le" + datePlus15.ToShortDateString());
				}
				//else if()
			}
			return ValidationResult.Success;
		}

	}
}