using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using photo_hdr_duval;
using photo_hdr_duval.Models;

namespace photo_hdr_duval.Controllers
{
    public class RDVController : Controller
    {
        private H15_PROJET_E05Entities1 db = new H15_PROJET_E05Entities1();

        // GET: RDV
        public ActionResult Index()
        {
            return View(db.RDVs.ToList());
        }

        // GET: RDV/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            RDV rDVs = db.RDVs.Find(id);
            if (rDVs == null)
            {
                return HttpNotFound();
            }
            return View(rDVs);
        }

        // GET: RDV/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: RDV/Create
        // Afin de déjouer les attaques par sur-validation, activez les propriétés spécifiques que vous voulez lier. Pour 
        // plus de détails, voir  http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "RDVID,DateRDV,HeureRDV,Commentaire,NomPrenomProprio,TelProprietaire,AdressePropriete,EmailProprietaire")] RDV rDVs)
        {
            if (ModelState.IsValid)
            {
                db.RDVs.Add(rDVs);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(rDVs);
        }

        // GET: RDV/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            RDV rDVs = db.RDVs.Find(id);
            if (rDVs == null)
            {
                return HttpNotFound();
            }
            return View(rDVs);
        }

        // POST: RDV/Edit/5
        // Afin de déjouer les attaques par sur-validation, activez les propriétés spécifiques que vous voulez lier. Pour 
        // plus de détails, voir  http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "RDVID,DateRDV,HeureRDV,Commentaire,NomPrenomProprio,TelProprietaire,AdressePropriete,EmailProprietaire")] RDV rDVs)
        {
            if (ModelState.IsValid)
            {
                db.Entry(rDVs).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(rDVs);
        }

        // GET: RDV/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            RDV rDVs = db.RDVs.Find(id);
            if (rDVs == null)
            {
                return HttpNotFound();
            }
            return View(rDVs);
        }

        // POST: RDV/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            RDV rDVs = db.RDVs.Find(id);
            db.RDVs.Remove(rDVs);
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
