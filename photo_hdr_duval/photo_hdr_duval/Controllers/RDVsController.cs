﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using photo_hdr_duval.Models;
using photo_hdr_duval.DAL;
using System.Security.AccessControl;
using System.Configuration;
using System.IO;
using System.Security.Principal;
using PagedList;

namespace photo_hdr_duval.Controllers
{
    public class RDVsController : Controller
    {
        private UnitOfWork uow = new UnitOfWork();

        // GET: RDVs
        public ActionResult Index(string sortString, string Statut, bool? asc, int? page)
        {
            
            int pageNum = page ?? 1;
            int pageSize = 10;

            ViewBag.isAsc = asc;
            ViewBag.orderBy = sortString;
            ViewBag.Statut = Statut;

            IEnumerable<RDV> rdvs = uow.RDVRepository.SortRDVs(sortString, asc, Statut);

            return View(new PagedList<RDV>(rdvs, pageNum, pageSize));
        }

        // GET: RDVs/Details/5
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

            RDVDetailsViewModel viewModel = new RDVDetailsViewModel();

			IEnumerable<Tax> Taxes = uow.TaxRepository.Get();

            viewModel.RDV = rDV;
            viewModel.CoutTPS = rDV.CoutTotalAvantTaxes * (Taxes.Where(x => x.TaxeID == 1).First().Pourcentage / 100);
            viewModel.CoutTVQ = rDV.CoutTotalAvantTaxes * (Taxes.Where(x => x.TaxeID == 2).First().Pourcentage / 100);
            viewModel.Agent = rDV.Agent;
            viewModel.Forfait = rDV.Forfait;
            viewModel.Photos = rDV.PhotoProprietes;
            viewModel.Statut = rDV.CurrentStatut;

            return View(viewModel);
        }

        // GET: RDVs/Create
        public ActionResult Create()
        {
			ViewBag.AgentID = new SelectList(uow.AgentRepository.Get(), "AgentID", "NomAgent");
            ViewBag.Forfaits = uow.ForfaitRepository.Get();
            return View();
        }

        // POST: RDVs/Create
        // Afin de déjouer les attaques par sur-validation, activez les propriétés spécifiques que vous voulez lier. Pour 
        // plus de détails, voir  http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "RDVID,DateRDV,HeureRDV,Commentaire,NomProprietaire,PrenomProprietaire,TelPrincipalProprietaire,TelSecondaire,AdressePropriete,EmailProprietaire,ForfaitID,Ville,VisiteVirtuelle,Deplacement,CodePostal,AgentID")] RDV rDV)
        {
            if (ModelState.IsValid)
            {
                rDV.DateDemande = DateTime.Now;
                uow.RDVRepository.Insert(rDV);
                uow.Save();
                return RedirectToAction("Index");
            }
            ViewBag.Forfaits = uow.ForfaitRepository.Get();
            ViewBag.AgentID = new SelectList(uow.AgentRepository.Get(), "AgentID", "NomAgent", rDV.AgentID);
            return View(rDV);
        }

        // GET: RDVs/Edit/5
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

        // POST: RDVs/Edit/5
        // Afin de déjouer les attaques par sur-validation, activez les propriétés spécifiques que vous voulez lier. Pour 
        // plus de détails, voir  http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "RDVID,DateRDV,HeureRDV,Commentaire,NomProprietaire,PrenomProprietaire,TelPrincipalProprietaire,TelSecondaire,AdressePropriete,EmailProprietaire,ForfaitID,Ville,VisiteVirtuelle,Deplacement,CodePostal,DateDemande,AgentID")] RDV rDV)
        {
            if (ModelState.IsValid)
            {
                uow.RDVRepository.Update(rDV);
                uow.Save();
                return RedirectToAction("Index");
            }
            ViewBag.Forfaits = uow.ForfaitRepository.Get();
			ViewBag.AgentID = new SelectList(uow.AgentRepository.Get(), "AgentID", "NomAgent", rDV.AgentID);
            return View(rDV);
        }

        // GET: RDVs/Delete/5
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

        // POST: RDVs/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            RDV rDV = uow.RDVRepository.GetByID((int)id);

            uow.RDVRepository.DeleteRDV(rDV, uow);
            uow.Save();
            return RedirectToAction("Index");
        }
    }
}
