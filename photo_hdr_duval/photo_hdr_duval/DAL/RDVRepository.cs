using photo_hdr_duval.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace photo_hdr_duval.DAL
{
	public class RDVRepository : Repository<RDV>
	{
		public RDVRepository(H15_PROJET_E05_Context context)
			: base(context)
		{ }

		public IEnumerable<RDV> GetOrderBy(string orderBy, bool asc)
		{
			Func<IQueryable<RDV>, IOrderedQueryable<RDV>> orderLambda = null;

			switch (orderBy)
			{
				case "DateRdv":
					if (asc)
						orderLambda = x => x.OrderBy(y => y.DateRDV);
					else
						orderLambda = x => x.OrderByDescending(y => y.DateRDV);
					break;
				case "DateDemande":
					if (asc)
						orderLambda = x => x.OrderBy(y => y.DateDemande);
					else
						orderLambda = x => x.OrderByDescending(y => y.DateDemande);
					break;
			}
			return Get(orderBy: orderLambda);
		}
	}
}