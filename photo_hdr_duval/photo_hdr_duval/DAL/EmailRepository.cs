using photo_hdr_duval.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace photo_hdr_duval.DAL
{
    public class EmailRepository : Repository<Email>
    {
        public EmailRepository(H15_PROJET_E05_Context context)
			: base(context)
		{ }

        public IEnumerable<Email> GetForAgent(int AgentID)
        {
            return Get(filter: x => x.AgentID == AgentID);
        }
    }
}