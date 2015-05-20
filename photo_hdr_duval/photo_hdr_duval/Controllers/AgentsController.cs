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
using PagedList;

namespace photo_hdr_duval.Controllers
{
    public class AgentsController : Controller
    {
        UnitOfWork uow = new UnitOfWork();

        // GET: Agents
        public ActionResult Index(string sortString, bool? asc, int? page)
        {
            int pageNum = page ?? 1;
            int pageSize = 10;

            IEnumerable<Agent> agents = uow.AgentRepository.SortAgents(sortString, asc);

            ViewBag.isAsc = asc;
            ViewBag.orderBy = sortString;
            return View(new PagedList<Agent>(agents, pageNum, pageSize));
        }

        // GET: Agents/Details/5
        public ActionResult Details(string sortString, bool? asc, int? id, int? page)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Agent agent = uow.AgentRepository.GetByID(id);
            if (agent == null)
            {
                return HttpNotFound();
            }
            
            int pageNum = page ?? 1;
            int pageSize = 10;

            IEnumerable<RDV> rdvs = uow.RDVRepository.SortRDVsByAgent(sortString, asc, agent);

            ViewBag.isAsc = asc;
            ViewBag.orderBy = sortString;
            ViewBag.listRDVs = new PagedList<RDV>(rdvs, pageNum, pageSize);
            return View(agent);
        }

       // GET: Agents/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Agents/Create
        // Afin de déjouer les attaques par sur-validation, activez les propriétés spécifiques que vous voulez lier. Pour 
        // plus de détails, voir  http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "AgentID,NomAgent,PrenomAgent,NomEntreprise,Adresse,TelPrincipal,TelSecondaire,CodePostal,Email1,Email2,Email3")] Agent agent)
        {
            if (ModelState.IsValid)
            {
                uow.AgentRepository.InsertAgent(agent);
                uow.Save();
                return RedirectToAction("Index");
            }

            return View(agent);
        }

        // GET: Agents/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Agent agent = uow.AgentRepository.GetByID(id);
            if (agent == null)
            {
                return HttpNotFound();
            }
            return View(agent);
        }

        // POST: Agents/Edit/5
        // Afin de déjouer les attaques par sur-validation, activez les propriétés spécifiques que vous voulez lier. Pour 
        // plus de détails, voir  http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "AgentID,NomAgent,PrenomAgent,NomEntreprise,Adresse,TelPrincipal,TelSecondaire,CodePostal,Email1,Email2,Email3")] Agent agent)
        {
            if (ModelState.IsValid)
            {
                uow.AgentRepository.UpdateAgent(agent);
                uow.Save();
                return RedirectToAction("Index");
            }
            return View(agent);
        }

        // GET: Agents/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Agent agent = uow.AgentRepository.GetByID(id);
            if (agent == null)
            {
                return HttpNotFound();
            }
            return View(agent);
        }

        // POST: Agents/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Agent agent = uow.AgentRepository.GetByID(id);
            uow.AgentRepository.DeleteAgent(agent);
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
