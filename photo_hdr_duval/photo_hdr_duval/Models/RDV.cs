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
    
    public partial class RDV
    {
        public RDV()
        {
            this.PhotoProprietes = new HashSet<PhotoPropriete>();
            this.Statuts = new HashSet<Statut>();
        }
    
        public int RDVID { get; set; }
        public System.DateTime DateDemande { get; set; }
        public Nullable<System.DateTime> DateRDV { get; set; }
        public Nullable<System.TimeSpan> HeureRDV { get; set; }
        public string Commentaire { get; set; }
        public string NomProprietaire { get; set; }
        public string PrenomProprietaire { get; set; }
        public long TelPrincipalProprietaire { get; set; }
        public Nullable<long> TelSecondaire { get; set; }
        public string AdressePropriete { get; set; }
        public string CodePostal { get; set; }
        public string Ville { get; set; }
        public string EmailProprietaire { get; set; }
        public int ForfaitID { get; set; }
        public decimal CoutTotalAvantTaxes { get; set; }
        public decimal CoutTotalApresTaxes { get; set; }
        public decimal Deplacement { get; set; }
        public decimal VisiteVirtuelle { get; set; }
        public Nullable<System.DateTime> DateFacturation { get; set; }
        public Nullable<System.DateTime> DateLivraison { get; set; }
        public int AgentID { get; set; }
    
        public virtual Agent Agent { get; set; }
        public virtual Forfait Forfait { get; set; }
        public virtual ICollection<PhotoPropriete> PhotoProprietes { get; set; }
        public virtual ICollection<Statut> Statuts { get; set; }
    }
}
