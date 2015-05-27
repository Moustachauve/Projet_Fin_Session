using PagedList;
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
				case "NomProprietaire":
					if (asc)
						orderLambda = x => x.OrderBy(y => y.NomProprietaire);
					else
						orderLambda = x => x.OrderByDescending(y => y.NomProprietaire);
					break;
                case "Status":
                    if (asc)
						orderLambda = x => x.OrderBy(y => y.Statuts.OrderByDescending(z => z.StatutID).FirstOrDefault().Importance);
                    else
						orderLambda = x => x.OrderByDescending(y => y.Statuts.OrderByDescending(z => z.StatutID).FirstOrDefault().Importance);
                    break;
			}
			return Get(orderBy: orderLambda);
		}

		public void InsertRDV(RDV rdv)
		{
			Insert(rdv);
		}
		public void UpdateRDV(RDV rdv)
		{
			Update(rdv);
		}
		public void DeleteRDV(RDV rdv, UnitOfWork uow)
		{
            for (int i = rdv.PhotoProprietes.Count - 1; i >= 0; i--)
            {
                uow.PhotoProprieteRepository.DeletePhotoPropriete(rdv.PhotoProprietes.ElementAt(i));
            }
            for (int i = rdv.Statuts.Count - 1; i >= 0; i--)
            {
                uow.StatutRepository.Delete(rdv.Statuts.ElementAt(i));
            }

			Delete(rdv);
		}

		public List<RDV> GetByDateRDV(DateTime dt)
		{
			IEnumerable<RDV> rdvs = this.Get();
			List<RDV> rdvsByDate = new List<RDV>();
			foreach (RDV rdv in rdvs)
			{
				if (rdv.DateRDV != null)
				{
					DateTime dateRdv = (DateTime)rdv.DateRDV;
					if (dateRdv.Date == dt.Date)
					{
						rdvsByDate.Add(rdv);
					}
				}
			}
			return rdvsByDate;
		}

        public IEnumerable<RDV> GetRdvByAgentID(int id)
        {
            List<RDV> lst = new List<RDV>();
            foreach (RDV rdv in Get())
            {
                if (rdv.AgentID == id)
                {
                    lst.Add(rdv);
                    
                }
            }
            return lst;
        }

        public IEnumerable<RDV> GetOrderByAgent(string orderBy, bool asc, Agent agent)
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
                case "NomProprietaire":
                    if (asc)
                        orderLambda = x => x.OrderBy(y => y.NomProprietaire);
                    else
                        orderLambda = x => x.OrderByDescending(y => y.NomProprietaire);
                    break;
                case "Status":
                    if (asc)
						orderLambda = x => x.OrderBy(y => y.CurrentStatut.Importance);
                    else
						orderLambda = x => x.OrderByDescending(y => y.CurrentStatut.Importance);
                    break;
            }
            List<RDV> lst = new List<RDV>();
            foreach (RDV rdv in Get(orderBy: orderLambda))
            {
                if (rdv.AgentID == agent.AgentID && (rdv.DateRDV == null || rdv.DateRDV.Value.Year == DateTime.Now.Year))
                {
                    lst.Add(rdv);
                }
            }
            return lst;
        }

        public IEnumerable<RDV> SortRDVs(string sortString, bool? asc, string Statut)
        {
            IEnumerable<RDV> rdvs;

            if (sortString == null)
                rdvs = Get();
            else
                rdvs = GetOrderBy(sortString, asc != null ? (bool)asc : false);

            if (Statut != null && !String.IsNullOrWhiteSpace(Statut))
				rdvs = rdvs.Where(x => x.CurrentStatut.DescriptionStatut == Statut).ToList();

            return rdvs;
        }

        public IEnumerable<RDV> SortRDVsByAgent(string sortString, bool? asc, string Statut, Agent agent)
        {
            IEnumerable<RDV> rdvs = null;

            if (sortString == null)
                rdvs = GetRdvByAgentID(agent.AgentID);
            else
                rdvs = GetOrderByAgent(sortString, asc != null ? (bool)asc : false, agent);

            if (Statut != null && !String.IsNullOrWhiteSpace(Statut))
				rdvs = rdvs.Where(x => x.CurrentStatut.DescriptionStatut == Statut).ToList();

            return rdvs;
        }
	}
}
