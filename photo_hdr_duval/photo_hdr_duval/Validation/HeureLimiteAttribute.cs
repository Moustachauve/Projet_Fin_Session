﻿using photo_hdr_duval.DAL;
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
				TimeSpan timeOfDay = (TimeSpan)value;
				DateTime date = (DateTime)RdvCourant.DateRDV;
				date.AddHours(timeOfDay.Hours).AddMinutes(timeOfDay.Minutes);
				if (!Is4hoursApart(date))
				{
					var ErrorMessage = FormatErrorMessage(validationContext.DisplayName);
					return new ValidationResult("Le rendez-vous doit avoir un minimum de 4 heures de différence avec les autres rendez-vous de la journée");
				}
			}
			return ValidationResult.Success;
		}

		private bool Is4hoursApart(DateTime dt) 
		{
			IEnumerable<RDV> rdvs = uow.RDVRepository.Get();
			bool IsValid = true;
			foreach (RDV rdv in rdvs) 
			{
				if (rdv != null) 
				{
					if (rdv.DateRDV != null)
					{
						DateTime tempDate = (DateTime)rdv.DateRDV;
                        if (rdv.HeureRDV != null)
                        {
                            tempDate.Add((TimeSpan)rdv.HeureRDV);
                            if (tempDate.DayOfYear == dt.DayOfYear)
                            {
                                if (tempDate.TimeOfDay >= dt.TimeOfDay.Subtract(new TimeSpan(4, 0, 0)) && tempDate.TimeOfDay <= dt.TimeOfDay.Add(new TimeSpan(4, 0, 0)))
                                {
                                    IsValid = false;
                                }
                            }
                        }
					}
				}
			}
			return IsValid;
		}

	}
}