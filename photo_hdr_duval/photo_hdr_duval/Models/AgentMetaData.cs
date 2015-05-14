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

            [Display(Name = "Nom")]
            public string NomAgent { get; set; }

			[Display(Name = "Prénom")]
			public string PrenomAgent { get; set; }

            [Display(Name = "Nom de l'entreprise")]
            public string NomEntreprise { get; set; }

            [Display(Name = "Adresse")]
            public string Adresse { get; set; }

            [Display(Name = "Code Postal")]
            public string CodePostal { get; set; }

            [DataType(DataType.PhoneNumber)]
            [Display(Name = "Téléphone principal*")]
            [DisplayFormat(DataFormatString = "{0:###-###-####}")]
            public long TelPrincipal { get; set; }

            [DataType(DataType.PhoneNumber)]
            [Display(Name = "Téléphone secondaire")]
            [DisplayFormat(DataFormatString = "{0:###-###-####}")]
            public long TelSecondaire { get; set; }

        }
    }
}