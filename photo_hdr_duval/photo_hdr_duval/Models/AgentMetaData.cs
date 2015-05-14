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

            [Display(Name = "Nom de l'agent")]
            public string NomAgent { get; set; }

			[Display(Name = "Prénom de l'agent")]
			public string PrenomAgent { get; set; }

            [Display(Name = "Nom de l'entreprise")]
            public string NomEntreprise { get; set; }
            public string Adresse { get; set; }

            [StringLength(10)]
            [DataType(DataType.PhoneNumber)]
            [Display(Name = "Téléphone principal")]
            [DisplayFormat(DataFormatString = "{0:###-###-####}")]
            public int TelPrincipal { get; set; }

            [StringLength(10)]
            [DataType(DataType.PhoneNumber)]
            [Display(Name = "Téléphone secondaire")]
            [DisplayFormat(DataFormatString = "{0:###-###-####}")]
            public int TelSecondaire { get; set; }

        }
    }
}