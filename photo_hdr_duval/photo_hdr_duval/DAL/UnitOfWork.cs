using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace photo_hdr_duval.DAL
{
	public class UnitOfWork : IUnitOfWork
	{

		public int CurrentUserID { get { return 1; } }

		//private Statistiques_SkiContext context = new Statistiques_SkiContext();

        

		public void Save()
		{
			//context.SaveChanges();
		}

		private bool disposed = false;
		protected virtual void Dispose(bool disposing)
		{
			if (!this.disposed)
			{
				if (disposing)
				{
					//context.Dispose();
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