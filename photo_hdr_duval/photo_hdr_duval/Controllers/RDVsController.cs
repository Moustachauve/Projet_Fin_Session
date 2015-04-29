using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using photo_hdr_duval;

namespace photo_hdr_duval.Controllers
{
    public class RDVsController : Controller
    {
        private H15_PROJET_E05Entities db = new H15_PROJET_E05Entities();

        // GET: RDVs
        public ActionResult Index()
        {
            return View(db.RDVs.ToList());
        }

        // GET: RDVs/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            RDVs rDVs = db.RDVs.Find(id);
            if (rDVs == null)
            {
                return HttpNotFound();
            }
            return View(rDVs);
        }

        // GET: RDVs/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: RDVs/Create
        // Afin de déjouer les attaques par sur-validation, activez les propriétés spécifiques que vous voulez lier. Pour 
        // plus de détails, voir  http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "RDVID,DateRDV,HeureRDV,Commentaire,NomPrenomProprio,TelProprietaire,AdressePropriete,EmailProprietaire")] RDVs rDVs)
        {
            if (ModelState.IsValid)
            {
                db.RDVs.Add(rDVs);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(rDVs);
        }

        // GET: RDVs/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            RDVs rDVs = db.RDVs.Find(id);
            if (rDVs == null)
            {
                return HttpNotFound();
            }
            return View(rDVs);
        }

        // POST: RDVs/Edit/5
        // Afin de déjouer les attaques par sur-validation, activez les propriétés spécifiques que vous voulez lier. Pour 
        // plus de détails, voir  http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "RDVID,DateRDV,HeureRDV,Commentaire,NomPrenomProprio,TelProprietaire,AdressePropriete,EmailProprietaire")] RDVs rDVs)
        {
            if (ModelState.IsValid)
            {
                db.Entry(rDVs).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(rDVs);
        }

        // GET: RDVs/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            RDVs rDVs = db.RDVs.Find(id);
            if (rDVs == null)
            {
                return HttpNotFound();
            }
            return View(rDVs);
        }

        // POST: RDVs/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            RDVs rDVs = db.RDVs.Find(id);
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
