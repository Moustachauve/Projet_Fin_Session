using photo_hdr_duval.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace photo_hdr_duval.DAL
{
    public class ForfaitRepository:Repository<Forfait>
    {
        public ForfaitRepository(H15_PROJET_E05_Context context)
			: base(context)
		{ }
    }
}