using photo_hdr_duval.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace photo_hdr_duval.DAL
{
    public class PhotoProprieteRepository : Repository<PhotoPropriete>
    {
        public PhotoProprieteRepository(H15_PROJET_E05_Context context)
            : base(context)
        { }


        public PhotoPropriete GetByID(int id)
        {
            return base.GetByID(id);
        }

        public IEnumerable<PhotoPropriete> GetForRDV(int rdvID)
        {
            return Get(filter: x => x.RDVID == rdvID);
        }
    }
}