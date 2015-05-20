using photo_hdr_duval.DAL;
using photo_hdr_duval.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace photo_hdr_duval.Validation
{
	public class HeureLimiteAttribute : ValidationAttribute
	{
		UnitOfWork uow = new UnitOfWork();


		public HeureLimiteAttribute()
			: base()
		{

		}

		protected override ValidationResult IsValid(object value, ValidationContext validationContext)
		{
			RDV RdvCourant = (RDV)validationContext.ObjectInstance;
			if (value != null && RdvCourant != null)
			{
				//TODO: check if datecourante null
				if (RdvCourant.DateRDV == null) 
				{
					var ErrorMessage = FormatErrorMessage(validationContext.DisplayName);
					return new ValidationResult("*L'heure ne peut pas être entré si il n'y a pas d'heure");
				}
				if (!Is4hoursApart(RdvCourant, (TimeSpan)value))
				{
					var ErrorMessage = FormatErrorMessage(validationContext.DisplayName);
					return new ValidationResult("*Il y a déjà un rendez-vous dans cette plage horaire");
				}
			}
			return ValidationResult.Success;
		}

		private bool Is4hoursApart(RDV rdvCourant, TimeSpan timeOfDay)
		{
			IEnumerable<RDV> rdvs = uow.RDVRepository.Get();
			bool IsValid = true;
			foreach (RDV rdv in rdvs)
			{
				if (rdv != null && rdv.RDVID != rdvCourant.RDVID)
				{
					if (rdv.DateRDV != null && rdv.HeureRDV != null)
					{
						DateTime dateCourante = (DateTime)rdvCourant.DateRDV;
						dateCourante = dateCourante.AddHours(timeOfDay.Hours).AddMinutes(timeOfDay.Minutes);
						DateTime tempDate = (DateTime)rdv.DateRDV;
						tempDate = tempDate.Add((TimeSpan)rdv.HeureRDV);
						TimeSpan fourHours = new TimeSpan(4, 0, 0);
						if (tempDate.DayOfYear == dateCourante.DayOfYear)
							if (tempDate.TimeOfDay >= dateCourante.TimeOfDay.Subtract(fourHours)
								&& tempDate.TimeOfDay <= dateCourante.TimeOfDay.Add(fourHours))
								IsValid = false;
					}
				}
			}
			return IsValid;
		}

	}
}