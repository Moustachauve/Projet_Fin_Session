using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace photo_hdr_duval.Models
{
    [MetadataType(typeof(PhotoProprieteMetaData))]
    public partial class PhotoPropriete
    {
        internal sealed class PhotoProprieteMetaData
        {
            [DataType(DataType.MultilineText)]
            [StringLength(300)]
            public string DescriptionPhoto { get; set; }
        }
    }
}