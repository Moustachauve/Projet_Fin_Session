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
    public class AgentsController : Controller
    {
        //private H15_PROJET_E05_Context db = new H15_PROJET_E05_Context();
        UnitOfWork uow = new UnitOfWork();

        // GET: Agents
        public ActionResult Index(string sortString, bool? asc)
        {
            IEnumerable<Agent> agents = null;

            ViewBag.isAsc = asc;
            ViewBag.orderBy = sortString;

            if (sortString == null)
                agents = uow.AgentRepository.Get();
            else
                agents = uow.AgentRepository.GetOrderBy(sortString, asc != null ? (bool)asc : false);

            return View(agents.ToList());
        }

        // GET: Agents/Details/5
        public ActionResult Details(int? id)
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

        public ActionResult CreateEmail(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            return View(new Email() { AgentID = (int)id });
        }

        // POST: Agents/Create
        // Afin de déjouer les attaques par sur-validation, activez les propriétés spécifiques que vous voulez lier. Pour 
        // plus de détails, voir  http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult CreateEmail([Bind(Include = "EmailID,AgentID,Email1,IsPrimary")] Email email)
        {
            if (ModelState.IsValid)
            {
                uow.EmailRepository.Insert(email);
                uow.Save();
                return RedirectToAction("Edit/" + email.AgentID.ToString());
            }

            return View(email);
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
        public ActionResult Create([Bind(Include = "AgentID,NomAgent,PrenomAgent,NomEntreprise,Adresse,TelPrincipal,TelSecondaire,CodePostal")] Agent agent)
        {
            if (ModelState.IsValid)
            {
                uow.AgentRepository.Insert(agent);
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
            ViewBag.Emails = uow.EmailRepository.GetForAgent(agent.AgentID);
            return View(agent);
        }

        // POST: Agents/Edit/5
        // Afin de déjouer les attaques par sur-validation, activez les propriétés spécifiques que vous voulez lier. Pour 
        // plus de détails, voir  http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "AgentID,NomAgent,PrenomAgent,NomEntreprise,Adresse,TelPrincipal,TelSecondaire,CodePostal,Emails")] Agent agent)
        {
            if (ModelState.IsValid)
            {
                foreach (Email aEmail in agent.Emails)
                {
                    aEmail.AgentID = agent.AgentID;
                }
                uow.AgentRepository.EditWithEmails(agent);
                uow.Save();
                return RedirectToAction("Index");
            }
            ViewBag.Emails = uow.EmailRepository.GetForAgent(agent.AgentID);
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
            uow.AgentRepository.Delete(agent);
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
