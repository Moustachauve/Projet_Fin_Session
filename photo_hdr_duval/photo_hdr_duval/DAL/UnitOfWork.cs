﻿using photo_hdr_duval.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace photo_hdr_duval.DAL
{
	public class UnitOfWork : IUnitOfWork
	{

		public int CurrentUserID { get { return 1; } }

		private H15_PROJET_E05_Context context = new H15_PROJET_E05_Context();

		private RDVRepository rdvRepository;
		public RDVRepository RDVRepository
		{
			get
			{
				if (this.rdvRepository == null)
				{
					this.rdvRepository = new RDVRepository(context);
				}
				return this.rdvRepository;
			}
		}

        private RDVRepository demandeRdvRepository;
        public RDVRepository DemandeRDVRepository
        {
            get
            {
                if (this.demandeRdvRepository == null)
                {
                    this.demandeRdvRepository = new RDVRepository(context);
                }
                return this.demandeRdvRepository;
            }
        }
        

		public void Save()
		{
			context.SaveChanges();
		}

		private bool disposed = false;
		protected virtual void Dispose(bool disposing)
		{
			if (!this.disposed)
			{
				if (disposing)
				{
					context.Dispose();
				}
			}
			this.disposed = true;
		}

		public void Dispose()
		{
			Dispose(true);
			GC.SuppressFinalize(this);
		}
	}
}