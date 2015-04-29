using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace photo_hdr_duval.DAL
{
    interface IUnitOfWork : IDisposable
    {


        void Save();
    }
}