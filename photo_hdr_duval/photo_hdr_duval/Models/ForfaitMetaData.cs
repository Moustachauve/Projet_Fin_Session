using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace photo_hdr_duval.Models
{
	[MetadataType(typeof(ForfaitMetaData))]
	public partial class Forfait
	{
		internal sealed class ForfaitMetaData
		{
            [Display(Name = "Forfait")]
			public int ForfaitID { get; set; }
			[Display(Name = "Nom du forfait")]
			public string Nom { get; set; }
			[Display(Name = "Description du forfait")]
			public string DescriptionForfait { get; set; }
			[DisplayFormat(DataFormatString="{0:c2}")]
			public decimal Prix { get; set; }

            
		}
        public string PrixToString()
        {
            if (Prix == 0)
            {
                return "--";
            }
            return Prix.ToString("C2");
        }
	}
}