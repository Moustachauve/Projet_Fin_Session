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

namespace photo_hdr_duval.Controllers
{
    public class DemandeRDVsController : Controller
    {
        private H15_PROJET_E05_Context db = new H15_PROJET_E05_Context();
        private UnitOfWork uow = new UnitOfWork();

        // GET: DemandeRDVs
        public ActionResult Index()
        {
            return View(db.RDVs.ToList());
        }

        // GET: DemandeRDVs/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            RDV rDV = db.RDVs.Find(id);
            if (rDV == null)
            {
                return HttpNotFound();
            }
            return View(rDV);
        }

        // GET: DemandeRDVs/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: DemandeRDVs/Create
        // Afin de déjouer les attaques par sur-validation, activez les propriétés spécifiques que vous voulez lier. Pour 
        // plus de détails, voir  http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "RDVID,DateRDV,HeureRDV,Commentaire,NomPrenomProprietaire,TelPrincipalProprietaire,TelCellProprietaire,AdressePropriete,EmailProprietaire")] RDV rDV)
        {
            if (ModelState.IsValid)
            {
                db.RDVs.Add(rDV);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(rDV);
        }

        // GET: DemandeRDVs/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            RDV rDV = db.RDVs.Find(id);
            if (rDV == null)
            {
                return HttpNotFound();
            }
            return View(rDV);
        }

        // POST: DemandeRDVs/Edit/5
        // Afin de déjouer les attaques par sur-validation, activez les propriétés spécifiques que vous voulez lier. Pour 
        // plus de détails, voir  http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "RDVID,DateRDV,HeureRDV,Commentaire,NomPrenomProprietaire,TelPrincipalProprietaire,TelCellProprietaire,AdressePropriete,EmailProprietaire")] RDV rDV)
        {
            if (ModelState.IsValid)
            {
                db.Entry(rDV).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(rDV);
        }

        // GET: DemandeRDVs/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            RDV rDV = db.RDVs.Find(id);
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
            RDV rDV = db.RDVs.Find(id);
            db.RDVs.Remove(rDV);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
