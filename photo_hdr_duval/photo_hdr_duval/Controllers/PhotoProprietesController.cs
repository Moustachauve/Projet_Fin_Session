using Ionic.Zip;
using photo_hdr_duval.DAL;
using photo_hdr_duval.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Security.AccessControl;
using System.Security.Principal;
using System.Web;
using System.Web.Mvc;

namespace photo_hdr_duval.Controllers
{
    public class PhotoProprietesController : Controller
    {
        private UnitOfWork uow = new UnitOfWork();

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

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult EditPhoto(PhotoPropriete photo)
        {
            if (ModelState.IsValid)
            {
                PhotoPropriete vraiPhoto = uow.PhotoProprieteRepository.UpdatePhoto(photo);
                uow.Save();
                return RedirectToAction("Details", "RDVs", new { id = vraiPhoto.RDVID });
            }
            return View(photo);
        }

        public ActionResult DownloadPhoto(int? id)
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

            string path = Server.MapPath(photo.Url);
            string mime = MimeMapping.GetMimeMapping(path);

            string date = ((DateTime)photo.RDV.DateRDV).ToShortDateString();
            string ext = System.IO.Path.GetExtension(path);

            return File(path, mime, date + "_" + photo.PhotoProprieteID + ext);
        }

        public ActionResult DownloadAll(int? id)
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
            if (rDV.DateRDV != null)
            {
                return File(uow.PhotoProprieteRepository.ZipPhotos(rDV), "application/zip", rDV.NomProprietaire + rDV.PrenomProprietaire + "_" + ((DateTime)rDV.DateRDV).ToShortDateString() + ".zip");
            }
            return File(uow.PhotoProprieteRepository.ZipPhotos(rDV), "application/zip", rDV.NomProprietaire + rDV.PrenomProprietaire + "_" + "photos.zip");
        }


        public JsonResult DoUploadPhoto(int? id)
        {
            if (id == null)
            {
                Response.StatusCode = (int)HttpStatusCode.BadRequest;
                return Json("Aucun rendez-vous sélectionné");
            }
            if (Request.Files == null)
            {
                Response.StatusCode = (int)HttpStatusCode.BadRequest;
                return Json("Aucun fichier sélectionné");
            }

            DirectoryInfo imageFolderPath = createImageRepo((int)id);

            foreach (string fileString in Request.Files)
            {
                HttpPostedFileBase file = Request.Files[fileString];

                if(file.ContentType.ToLower() != "image/jpg" &&
                    file.ContentType.ToLower() != "image/jpeg" &&
                    file.ContentType.ToLower() != "image/gif" &&
                    file.ContentType.ToLower() != "image/png")
                {
                    Response.StatusCode = (int)HttpStatusCode.BadRequest;
                    return Json("Un ou plusieurs fichiers ne sont pas des images valides");
                }

                string filename = Guid.NewGuid().ToString() + System.IO.Path.GetExtension(file.FileName);

                file.SaveAs(imageFolderPath + "/" + filename);
                string fullPath = "~/Images/" + id + "/" + filename;
                uow.PhotoProprieteRepository.Insert(new PhotoPropriete() { Url = fullPath, RDVID = (int)id });
            }

            uow.Save();

            return Json("Fichier téléversé avec succès");
        }

        public JsonResult DoDeletePhoto(int? id)
        {
            if (id == null)
            {
                Response.StatusCode = (int)HttpStatusCode.BadRequest;
                return Json("No ID");
            }

            PhotoPropriete photo = uow.PhotoProprieteRepository.GetByID(id);

            uow.PhotoProprieteRepository.DeletePhotoPropriete(photo);
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