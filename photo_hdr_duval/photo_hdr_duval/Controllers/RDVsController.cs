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
using System.Security.AccessControl;
using System.Configuration;
using System.IO;
using System.Security.Principal;

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
            uow.RDVRepository.UpdateCoutTotal(rDV);
            ViewBag.Taxes = uow.TaxRepository.Get();
            return View(rDV);
        }

        // GET: RDVs/Create
        public ActionResult Create()
        {
            ViewBag.Forfaits = uow.ForfaitRepository.Get();
            return View();
        }

        // POST: RDVs/Create
        // Afin de déjouer les attaques par sur-validation, activez les propriétés spécifiques que vous voulez lier. Pour 
        // plus de détails, voir  http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "RDVID,DateRDV,HeureRDV,Commentaire,NomProprietaire,PrenomProprietaire,TelPrincipalProprietaire,TelSecondaire,AdressePropriete,EmailProprietaire,ForfaitID,Ville,VisiteVirtuelle,Deplacement,CodePostal")] RDV rDV)
        {
            if (ModelState.IsValid)
            {
                rDV.DateDemande = DateTime.Now;
                uow.RDVRepository.UpdateCoutTotal(rDV);
                uow.RDVRepository.Insert(rDV);
                uow.Save();
                return RedirectToAction("Index");
            }
            ViewBag.Forfaits = uow.ForfaitRepository.Get();
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
            ViewBag.Forfaits = uow.ForfaitRepository.Get();
            return View(rDV);
        }

        // POST: RDVs/Edit/5
        // Afin de déjouer les attaques par sur-validation, activez les propriétés spécifiques que vous voulez lier. Pour 
        // plus de détails, voir  http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "RDVID,DateRDV,HeureRDV,Commentaire,NomProprietaire,PrenomProprietaire,TelPrincipalProprietaire,TelSecondaire,AdressePropriete,EmailProprietaire,ForfaitID,Ville,VisiteVirtuelle,Deplacement,CodePostal,DateDemande")] RDV rDV)
        {
            if (ModelState.IsValid)
            {
                uow.RDVRepository.UpdateCoutTotal(rDV);
                uow.RDVRepository.Update(rDV);
                uow.Save();
                return RedirectToAction("Index");
            }
            ViewBag.Forfaits = uow.ForfaitRepository.Get();
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

        public ActionResult UploadPhoto(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            RDV rDV = uow.RDVRepository.GetByID((int)id);
            return View(rDV);
        }

        public ActionResult EditPhoto(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            PhotoPropriete photo = uow.PhotoProprieteRepository.GetByID((int)id);
            if (photo == null)
            {
                return HttpNotFound();
            }
            return View(photo);
        }

        public JsonResult DoUploadPhoto(int? id)
        {
            if (id == null)
            {
                Response.StatusCode = (int)HttpStatusCode.BadRequest;
                return Json("No ID");
            }
            if (Request.Files == null)
            {
                Response.StatusCode = (int)HttpStatusCode.BadRequest;
                return Json("No file");
            }

            DirectoryInfo imageFolderPath = createImageRepo((int)id);

            foreach (string fileString in Request.Files)
            {
                HttpPostedFileBase file = Request.Files[fileString];

                string filename = Guid.NewGuid().ToString() + System.IO.Path.GetExtension(file.FileName);

                file.SaveAs(imageFolderPath + "/" + filename);
                string fullPath = id + "/" + filename;
                uow.PhotoProprieteRepository.Insert(new PhotoPropriete() { Url = fullPath, RDVID = (int)id });
            }

            uow.Save();

            return Json("File uploaded successfully");
        }

        public JsonResult DoDeletePhoto(int? id)
        {
            if (id == null)
            {
                Response.StatusCode = (int)HttpStatusCode.BadRequest;
                return Json("No ID");
            }

            PhotoPropriete photo = uow.PhotoProprieteRepository.GetByID(id);
            String path = HttpContext.Server.MapPath("~/images/" + photo.Url);
            if (System.IO.File.Exists(path))
                System.IO.File.Delete(path);

            uow.PhotoProprieteRepository.Delete(photo);
            uow.Save();

            return Json(id);
        }


        private DirectoryInfo createImageRepo(int id)
        {
            DirectoryInfo imageFolderPath = new DirectoryInfo(Server.MapPath("~/Images/") + id);

            if (!imageFolderPath.Exists)
            {
                DirectorySecurity securityRules = new DirectorySecurity();
                SecurityIdentifier everyone = new SecurityIdentifier(WellKnownSidType.WorldSid, null);

                securityRules.AddAccessRule(new FileSystemAccessRule(everyone, FileSystemRights.Modify | FileSystemRights.Synchronize,
                                            InheritanceFlags.ContainerInherit | InheritanceFlags.ObjectInherit,
                                            PropagationFlags.None, AccessControlType.Allow));

                imageFolderPath.Create(securityRules);
            }

            return imageFolderPath;
        }
    }
}
