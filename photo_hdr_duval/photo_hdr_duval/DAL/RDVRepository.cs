using photo_hdr_duval.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace photo_hdr_duval.DAL
{
	public class RDVRepository : Repository<RDVRepository>
	{
		public RDVRepository(H15_PROJET_E05_Context context)
			: base(context)
		{ }

		public RDV Get()
		{
			return Get();
		}

		public RDV GetByID(int id)
		{
			RDV rdv = GetByID(id);
			if (rdv != null)
				return rdv;
			return null;
		}
		public void Insert(RDV rdv)
		{
			if (rdv != null)
				Insert(rdv);

		}
		public void Update(RDV rdv)
		{
			if (rdv != null)
				Update(rdv);
		}

	}
}