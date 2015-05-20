using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace photo_hdr_duval.Models
{
    public class RDVDetailsViewModel
    {
        public RDV RDV { get; set; }
        public Agent Agent { get; set; }
        public Statut Statut { get; set; }
        public Forfait Forfait { get; set; }
        public ICollection<PhotoPropriete> Photos { get; set; }

        [DisplayFormat(DataFormatString = "{0:C2}")]
        [DisplayName("TPS")]
        public decimal CoutTPS { get; set; }

        [DisplayFormat(DataFormatString = "{0:C2}")]
        [DisplayName("TVQ")]
        public decimal CoutTVQ { get; set; }
    }
}