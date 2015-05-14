using photo_hdr_duval.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace photo_hdr_duval.DAL
{
	public class UnitOfWork : IUnitOfWork
	{

		public int CurrentUserID { get { return 1; } }

        public int CurrentAgentID { get; set; }

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

        private ForfaitRepository forfaitRepository;
        public ForfaitRepository ForfaitRepository
        {
            get
            {
                if (this.forfaitRepository == null)
                {
                    this.forfaitRepository = new ForfaitRepository(context);
                }
                return this.forfaitRepository;
            }
        }

        private AgentRepository agentRepository;
        public AgentRepository AgentRepository
        {
            get
            {
                if (this.agentRepository == null)
                {
                    this.agentRepository = new AgentRepository(context);
                }
                return this.agentRepository;
            }
        }

        private EmailRepository emailRepository;
        public EmailRepository EmailRepository
        {
            get
            {
                if (this.emailRepository == null)
                {
                    this.emailRepository = new EmailRepository(context);
                }
                return this.emailRepository;
            }
        }

        private PhotoProprieteRepository photoProprieteRepository;
        public PhotoProprieteRepository PhotoProprieteRepository
        {
            get
            {
                if (this.photoProprieteRepository == null)
                {
                    this.photoProprieteRepository = new PhotoProprieteRepository(context);
                }
                return this.photoProprieteRepository;
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