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
	public class RDVsController : Controller
	{
		private UnitOfWork uow = new UnitOfWork();

		// GET: RDVs
		public ActionResult Index(string sortString, bool? asc)
		{
			IEnumerable<RDV> rdvs = null;

			ViewBag.isAsc = asc;
			ViewBag.orderBy = sortString;

			if (sortString == null)
				rdvs = uow.RDVRepository.Get();
			else
				rdvs = uow.RDVRepository.GetOrderBy(sortString, asc != null ? (bool)asc : false);

			return View(rdvs.ToList());
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
			return View(rDV);
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
		public ActionResult Create([Bind(Include = "RDVID,DateRDV,HeureRDV,Commentaire,NomPrenomProprietaire,TelPrincipalProprietaire,TelSecondaire,AdressePropriete,EmailProprietaire")] RDV rDV)
		{
			if (ModelState.IsValid)
			{
				rDV.DateDemande = DateTime.Now;
				uow.RDVRepository.Insert(rDV);
				uow.Save();
				return RedirectToAction("Index");
			}

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
			return View(rDV);
		}

		// POST: RDVs/Edit/5
		// Afin de déjouer les attaques par sur-validation, activez les propriétés spécifiques que vous voulez lier. Pour 
		// plus de détails, voir  http://go.microsoft.com/fwlink/?LinkId=317598.
		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult Edit([Bind(Include = "RDVID,DateRDV,HeureRDV,Commentaire,NomPrenomProprietaire,TelPrincipalProprietaire,TelSecondaire,AdressePropriete,EmailProprietaire")] RDV rDV)
		{
			if (ModelState.IsValid)
			{
				uow.RDVRepository.Update(rDV);
				uow.Save();
				return RedirectToAction("Index");
			}
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
			uow.RDVRepository.Delete(rDV);
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
