using Ionic.Zip;
using photo_hdr_duval.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Hosting;
using System.Web.Mvc;

namespace photo_hdr_duval.DAL
{
    public class PhotoProprieteRepository : Repository<PhotoPropriete>
    {
        public PhotoProprieteRepository(H15_PROJET_E05_Context context)
            : base(context)
        { }


        public PhotoPropriete GetByID(int id)
        {
            return base.GetByID(id);
        }

        public IEnumerable<PhotoPropriete> GetForRDV(int rdvID)
        {
            return Get(filter: x => x.RDVID == rdvID);
        }

        public MemoryStream ZipPhotos(RDV rdv)
        {
            var outputStream = new MemoryStream();

            using (var zip = new ZipFile())
            {
                int i = 1;
                foreach (PhotoPropriete photo in GetForRDV(rdv.RDVID))
                {
                    string ext = System.IO.Path.GetExtension(photo.Url);
                    if (rdv.DateRDV == null)
                        zip.AddFile(HostingEnvironment.MapPath(photo.Url)).FileName = i + ext;
                    else
                        zip.AddFile(HostingEnvironment.MapPath(photo.Url)).FileName = ((DateTime)rdv.DateRDV).ToShortDateString() + "_" + i + ext;
                    i++;
                }
                zip.Save(outputStream);
            }

            outputStream.Position = 0;
            return outputStream;
        }

        public void DeletePhotoPropriete(PhotoPropriete photo)
        {
            String path = HostingEnvironment.MapPath("~/images/" + photo.Url);
            if (System.IO.File.Exists(path))
                System.IO.File.Delete(path);

            Delete(photo);
        }

        public PhotoPropriete UpdatePhoto(PhotoPropriete photo)
        {
            PhotoPropriete vraiPhoto = GetByID(photo.PhotoProprieteID);
            vraiPhoto.DescriptionPhoto = photo.DescriptionPhoto;

            Update(vraiPhoto);

            return vraiPhoto;
        }
    }
}