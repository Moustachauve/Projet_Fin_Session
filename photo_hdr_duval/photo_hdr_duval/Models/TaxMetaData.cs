using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace photo_hdr_duval.Models
{
	[MetadataType(typeof(TaxMetaData))]
	public partial class Tax
	{
		internal sealed class TaxMetaData
		{
			public int TaxeID { get; set; }
			public string Nom { get; set; }
			public decimal Pourcentage { get; set; }
		}
		public string PourcentageToString()
		{
			string output = "";

			output = output + Pourcentage.ToString() + "%";

			return output;
		}
	}
}