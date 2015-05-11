using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace photo_hdr_duval.Models
{
    [MetadataType(typeof(RDVMetaData))]
    public partial class RDV
    {
        internal sealed class RDVMetaData
        {
            public int RDVID { get; set; }

            [DataType(DataType.Date)]
            [Display(Name= "Date du rendez-vous")]
            public DateTime DateRDV { get; set; }

            [DataType(DataType.Time)]
            [Display(Name = "Heure")]
            public DateTime HeureRDV { get; set; }

            [DataType(DataType.MultilineText)]
            [Display(Name = "Information supplémentaire")]
            public string Commentaire { get; set; }

            [Display(Name = "Nom Propriétaire")]
            [Required]
            public string NomProprietaire { get; set; }

			[Display(Name = "Prenom du Propriétaire")]
			[Required]
			public string PrenomProprietaire { get; set; }

            [DataType(DataType.PhoneNumber)]
            [Required]
            [Display(Name = "Téléphone principal du propriétaire")]
            [DisplayFormat(DataFormatString = "{0:###-###-####}")]
            public long TelPrincipalProprietaire { get; set; }

            [DataType(DataType.PhoneNumber)]
            [Display(Name = "Téléphone secondaire")]
            [DisplayFormat(DataFormatString = "{0:###-###-####}")]
            public long TelSecondaire { get; set; }

            [Display(Name = "Adresse de la propriété")]
            [Required]
            public string AdressePropriete { get; set; }

            [Display(Name = "Email du propriétaire")]
            public string EmailProprietaire { get; set; }

            [DataType(DataType.DateTime)]
			[Display(Name = "Date de demande")]
            public DateTime DateDemande { get; set; }

        }
    }
}