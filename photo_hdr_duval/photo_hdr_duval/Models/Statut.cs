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
    
    public partial class Statut
    {
        public int StatutID { get; set; }
        public System.DateTime DateModification { get; set; }
        public string DescriptionStatut { get; set; }
        public int RDVID { get; set; }
    
        public virtual RDV RDV { get; set; }
    }
}
