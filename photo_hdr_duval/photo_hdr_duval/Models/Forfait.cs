//------------------------------------------------------------------------------
// <auto-generated>
//     Ce code a été généré à partir d'un modèle.
//
//     Des modifications manuelles apportées à ce fichier peuvent conduire à un comportement inattendu de votre application.
//     Les modifications manuelles apportées à ce fichier sont remplacées si le code est régénéré.
// </auto-generated>
//------------------------------------------------------------------------------

namespace photo_hdr_duval.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class Forfait
    {
        public Forfait()
        {
            this.RDVs = new HashSet<RDV>();
        }
    
        public int ForfaitID { get; set; }
        public string Nom { get; set; }
        public string DescriptionForfait { get; set; }
        public decimal Prix { get; set; }
    
        public virtual ICollection<RDV> RDVs { get; set; }
    }
}
