using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace photo_hdr_duval.Models
{
    [MetadataType(typeof(AgentMetaData))]
    public partial class Agent
    {
        internal sealed class AgentMetaData
        {

            public int AgentID { get; set; }

            [Required]
            [Display(Name = "Nom")]
            public string NomAgent { get; set; }

            [Required]
			[Display(Name = "Prénom")]
			public string PrenomAgent { get; set; }

            [Required]
            [Display(Name = "Nom de l'entreprise")]
            public string NomEntreprise { get; set; }

            [Required]
            [Display(Name = "Adresse")]
            public string Adresse { get; set; }

            [Required]
            [Display(Name = "Code Postal")]
            public string CodePostal { get; set; }

            [Required]
            [DataType(DataType.PhoneNumber)]
            [Display(Name = "Téléphone principal")]
            [DisplayFormat(DataFormatString = "{0:###-###-####}")]
            public long TelPrincipal { get; set; }

            [DataType(DataType.PhoneNumber)]
            [Display(Name = "Téléphone secondaire")]
            [DisplayFormat(DataFormatString = "{0:###-###-####}")]
            public long TelSecondaire { get; set; }

            [Required]
            [Display(Name = "Email principal")]
            public string Email1 { get; set; }

            [Display(Name = "Email secondaire 1")]
            public string Email2 { get; set; }

            [Display(Name = "Email secondaire 2")]
            public string Email3 { get; set; }

        }
    }
}