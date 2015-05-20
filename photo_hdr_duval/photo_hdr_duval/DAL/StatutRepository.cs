using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using photo_hdr_duval.Models;

namespace photo_hdr_duval.DAL
{
    public class StatutRepository : Repository<Statut>
    {
        public StatutRepository(H15_PROJET_E05_Context context)
			: base(context)
		{ }


    }
}