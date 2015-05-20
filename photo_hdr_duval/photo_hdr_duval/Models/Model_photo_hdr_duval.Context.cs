﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
    public partial class H15_PROJET_E05_Context : DbContext
    {
        public H15_PROJET_E05_Context()
            : base("name=H15_PROJET_E05_Context")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<Agent> Agents { get; set; }
        public virtual DbSet<Tax> Taxes { get; set; }
        public virtual DbSet<Forfait> Forfaits { get; set; }
        public virtual DbSet<PhotoPropriete> PhotoProprietes { get; set; }
        public virtual DbSet<RDV> RDVs { get; set; }
        public virtual DbSet<Statut> Statuts { get; set; }
        public virtual DbSet<view_RapportMensuel> view_RapportMensuel { get; set; }
    
        public virtual ObjectResult<RapportMensuel_Result> RapportMensuel(Nullable<int> mois, Nullable<int> année)
        {
            var moisParameter = mois.HasValue ?
                new ObjectParameter("mois", mois) :
                new ObjectParameter("mois", typeof(int));
    
            var annéeParameter = année.HasValue ?
                new ObjectParameter("année", année) :
                new ObjectParameter("année", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<RapportMensuel_Result>("RapportMensuel", moisParameter, annéeParameter);
        }
    }
}
