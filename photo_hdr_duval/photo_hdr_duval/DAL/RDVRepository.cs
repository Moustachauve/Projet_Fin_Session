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
			}
			return Get(orderBy: orderLambda);
		}

		public void UpdateCoutTotal(RDV rdv)
		{
			decimal deplacement = rdv.Deplacement;
			decimal visiteVirtuelle = rdv.VisiteVirtuelle;
			decimal prixForfait = context.Forfaits.Where(x => x.ForfaitID == rdv.ForfaitID).First().Prix;
			decimal tps = context.Taxes.Where(x => x.TaxeID == 1).First().Pourcentage / 100;
			decimal tvq = context.Taxes.Where(x => x.TaxeID == 2).First().Pourcentage / 100;
			decimal coutTotalBeforeTaxes = prixForfait + deplacement + visiteVirtuelle;
			decimal coutTotalAfterTaxes = (coutTotalBeforeTaxes * tps) + (coutTotalBeforeTaxes * tvq) + coutTotalBeforeTaxes;
			rdv.CoutTotalAvantTaxes = coutTotalBeforeTaxes;
			rdv.CoutTotalApresTaxes = coutTotalAfterTaxes;
		}
		public void InsertRDV(RDV rdv)
		{
			Insert(rdv);
		}
		public void UpdateRDV(RDV rdv)
		{
			Update(rdv);
		}
		public void DeleteRDV(RDV rdv)
		{
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
						rdvsByDate.Add(rdv);
				}
			}
			return rdvsByDate;
		}
	}
}
