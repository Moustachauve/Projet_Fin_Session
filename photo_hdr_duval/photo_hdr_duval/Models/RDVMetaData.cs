using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace photo_hdr_duval.Models
{
    //[MetadataType(typeof(RDVMetaData))]
    //public partial class RDV
    //{
    //    public int RDVID { get; set; }
    //    public DateTime DateRDV { get; set; }
    //    public DateTime HeureRDV { get; set; }
    //    public string Commentaire { get; set; }
    //    public string NomPrenomPropietaire { get; set; }
    //    public int TelPrincipalProprietaire { get; set; }
    //    public int TelSecondaire { get; set; }
    //    public string AdresseProprietaire { get; set; }
    //    public string EmailProprietaire { get; set; }
    //    public DateTime DateDemande { get; set; }
    //}

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

            [Display(Name = "Nom et Prénom du Propriétaire")]
            public string NomPrenomProprietaire { get; set; }

            [StringLength(10)]
            [DataType(DataType.PhoneNumber)]
            [Display(Name = "Téléphone principal du propriétaire")]
            public int TelPrincipalProprietaire { get; set; }

            [StringLength(10)]
            [DataType(DataType.PhoneNumber)]
            [Display(Name = "Téléphone secondaire")]
            public int TelSecondaire { get; set; }

            [Display(Name = "Adresse de la propriété")]
            public string AdressePropriete { get; set; }

            [Display(Name = "Email du propriétaire")]
            public string EmailProprietaire { get; set; }

            [DataType(DataType.Date)]
			[Display(Name = "Date de demande")]
            public DateTime DateDemande { get; set; }
        }
    }
}