using photo_hdr_duval.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace photo_hdr_duval.DAL
{
    public class AgentRepository : Repository<Agent>
    {
        public AgentRepository(H15_PROJET_E05_Context context)
			: base(context)
		{ }

        public IEnumerable<Agent> GetOrderBy(string orderBy, bool asc)
        {
            Func<IQueryable<Agent>, IOrderedQueryable<Agent>> orderLambda = null;

            switch (orderBy)
            {
                case "NomAgent":
                    if (asc)
                        orderLambda = x => x.OrderBy(y => y.NomAgent);
                    else
                        orderLambda = x => x.OrderByDescending(y => y.NomAgent);
                    break;
                case "PrenomAgent":
                    if (asc)
                        orderLambda = x => x.OrderBy(y => y.PrenomAgent);
                    else
                        orderLambda = x => x.OrderByDescending(y => y.PrenomAgent);
                    break;
                case "NomEntreprise":
                    if (asc)
                        orderLambda = x => x.OrderBy(y => y.NomEntreprise);
                    else
                        orderLambda = x => x.OrderByDescending(y => y.NomEntreprise);
                    break;
                case "Adresse":
                    if (asc)
                        orderLambda = x => x.OrderBy(y => y.Adresse);
                    else
                        orderLambda = x => x.OrderByDescending(y => y.Adresse);
                    break;
                case "TelPrincipal":
                    if (asc)
                        orderLambda = x => x.OrderBy(y => y.TelPrincipal);
                    else
                        orderLambda = x => x.OrderByDescending(y => y.TelPrincipal);
                    break;
                case "TelSecondaire":
                    if (asc)
                        orderLambda = x => x.OrderBy(y => y.TelSecondaire);
                    else
                        orderLambda = x => x.OrderByDescending(y => y.TelSecondaire);
                    break;
            }
            return Get(orderBy: orderLambda);
        }
    }
}