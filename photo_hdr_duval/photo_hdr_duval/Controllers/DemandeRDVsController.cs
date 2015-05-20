using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using photo_hdr_duval.Models;
using photo_hdr_duval.DAL;
using System.IO;
using System.IO.Compression;
using Ionic.Zip;
using System.Drawing;
using PagedList;

namespace photo_hdr_duval.Controllers
{
    public class DemandeRDVsController : Controller
    {
        private UnitOfWork uow = new UnitOfWork();
        
        // GET: DemandeRDVs
        public ActionResult Index(string sortString, string Statut, bool? asc, int? page, int? agentId)
        {
            int pageNum = page ?? 1;
            int pageSize = 10;

            ViewBag.isAsc = asc;
            ViewBag.orderBy = sortString;
            ViewBag.Statut = Statut;
            ViewBag.SelectedAgentID = agentId;
            ViewBag.AgentID = new SelectList(uow.AgentRepository.Get(), "AgentID", "NomAgent", agentId);

            IEnumerable<RDV> rdvs;

            if (agentId != null)
            {
                Agent agent = uow.AgentRepository.GetByID((int)agentId);
                rdvs = uow.RDVRepository.SortRDVsByAgent(sortString, asc, Statut, agent);
            }
            else {
                rdvs = uow.RDVRepository.SortRDVs(sortString, asc, Statut);
            }

            return View(new PagedList<RDV>(rdvs, pageNum, pageSize));
        }

        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            RDV rDV = uow.RDVRepository.GetByID((int)id);
            if (rDV == null)
            {
                return HttpNotFound();
            }
            IEnumerable<Tax> Taxes = uow.TaxRepository.Get();

            RDVDetailsViewModel viewModel = new RDVDetailsViewModel();
            viewModel.RDV = rDV;
            viewModel.CoutTPS = rDV.CoutTotalAvantTaxes * (Taxes.Where(x => x.TaxeID == 1).First().Pourcentage / 100);
            viewModel.CoutTVQ = rDV.CoutTotalAvantTaxes * (Taxes.Where(x => x.TaxeID == 2).First().Pourcentage / 100);
            viewModel.Agent = rDV.Agent;
            viewModel.Forfait = rDV.Forfait;
            viewModel.Photos = rDV.PhotoProprietes;
            viewModel.Statut = rDV.Statuts.First();

            return View(viewModel);
        }

        // GET: DemandeRDVs/Create
        public ActionResult Create()
        {
            ViewBag.AgentID = new SelectList(uow.AgentRepository.Get(), "AgentID", "NomAgent");
            ViewBag.Forfaits = uow.ForfaitRepository.Get();
            return View();
        }

        // POST: DemandeRDVs/Create
        // Afin de déjouer les attaques par sur-validation, activez les propriétés spécifiques que vous voulez lier. Pour 
        // plus de détails, voir  http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "RDVID,DateRDV,CodePostal,HeureRDV,Commentaire,NomProprietaire,PrenomProprietaire,TelPrincipalProprietaire,TelSecondaire,AdressePropriete,EmailProprietaire,ForfaitID,Ville,AgentID")] RDV rDV)
        {
            if (ModelState.IsValid)
            {
                rDV.DateDemande = DateTime.Now;
                uow.RDVRepository.InsertRDV(rDV);
                uow.Save();
                return RedirectToAction("Index");
            }
            ViewBag.Forfaits = uow.ForfaitRepository.Get();
            return View(rDV);
        }

        // GET: DemandeRDVs/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            RDV rDV = uow.RDVRepository.GetByID((int)id);
            if (rDV == null)
            {
                return HttpNotFound();
            }
			ViewBag.AgentID = new SelectList(uow.AgentRepository.Get(), "AgentID", "NomAgent", rDV.AgentID);
            ViewBag.Forfaits = uow.ForfaitRepository.Get();
            return View(rDV);
        }

        // POST: DemandeRDVs/Edit/5
        // Afin de déjouer les attaques par sur-validation, activez les propriétés spécifiques que vous voulez lier. Pour 
        // plus de détails, voir  http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
		public ActionResult Edit([Bind(Include = "RDVID,DateRDV,HeureRDV,Commentaire,NomProprietaire,PrenomProprietaire,TelPrincipalProprietaire,TelSecondaire,AdressePropriete,EmailProprietaire,ForfaitID,Ville,VisiteVirtuelle,Deplacement,CodePostal,DateDemande,AgentID")] RDV rDV)
        {
            if (ModelState.IsValid)
            {
                uow.RDVRepository.UpdateRDV(rDV);
                uow.Save();
                return RedirectToAction("Index");
            }
            ViewBag.Forfaits = uow.ForfaitRepository.Get();
			ViewBag.AgentID = new SelectList(uow.AgentRepository.Get(), "AgentID", "NomAgent", rDV.AgentID);
            return View(rDV);
        }

        // GET: DemandeRDVs/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            RDV rDV = uow.RDVRepository.GetByID((int)id);
            if (rDV == null)
            {
                return HttpNotFound();
            }
            return View(rDV);
        }

        // POST: DemandeRDVs/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            RDV rDV = uow.RDVRepository.GetByID((int)id);
            uow.RDVRepository.DeleteRDV(rDV, uow);
            uow.Save();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                uow.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
