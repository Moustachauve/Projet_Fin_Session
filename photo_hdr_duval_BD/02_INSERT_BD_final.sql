USE [H15_PROJET_E05]
GO
/*
DROP TABLE RDV.Statuts
DROP TABLE RDV.PhotoProprietes
DROP TABLE Paiement.Taxes
DROP TABLE Agent.Agents
DROP TABLE RDV.RDVs
DROP TABLE RDV.Forfaits*/

--RDV.forfaits
INSERT INTO  RDV.Forfaits (Nom, DescriptionForfait, Prix) VALUES
('Bronze', '20 photos et 35 minutes', 90),
('Argent', '26 photos et 50 mintues', 105),
('Or', '32 photos et 70 mintues', 120),
('Personnalisé', 'À la discretion du photographe', 0)
GO

--Agent.Agent
INSERT INTO Agent.Agents (NomAgent, PrenomAgent, NomEntreprise, Adresse, CodePostal, TelPrincipal, TelSecondaire, Email1, Email2, Email3)VALUES
('Monette','Jamy-jeff', 'Remax', '123 une adresse','H0H 0H0', '1231231234', NULL, 'jjeff@hotmail.com', NULL, NULL),
('Despins','Francis', 'Via Capitale', '321 adresse une','H0H 0H0', '4321321321', NULL, 'francisDespins@hotmail.com', 'FrancisCool123@hotmail.com', NULL),
('Fortier','Kevin', 'Immobilier Quebec', '472 rue secondaire','H0H 0H0', '7531594862', NULL, 'KevinFortier@hotmail.com', NULL, NULL)
GO

--Paiement.Taxes
INSERT INTO Paiement.Taxes (Nom, Pourcentage) VALUES
('TPS', 5),
('TVQ', 9.975)
GO

--RDV.RDVs

INSERT INTO RDV.RDVs (DateDemande, DateRDV, HeureRDV, Commentaire, TelPrincipalProprietaire, TelSecondaire, AdressePropriete, EmailProprietaire, ForfaitID, NomProprietaire, PrenomProprietaire, CodePostal, Deplacement, VisiteVirtuelle, DateFacturation, DateLivraison, Ville, AgentID, CoutTotalAvantTaxes, CoutTotalApresTaxes) VALUES
(GETDATE(), NULL, NULL, 'Appeller telephone secondaire avant 17h',4501231234, NULL, '7350-16 du Chardonneret', 'EricCoolFriend@hotmail.com',2, 'Leduc', 'Éric', 'H0H 0H0', 10, 5, NULL, NULL, 'Brossard', 2, 0, 0)
INSERT INTO RDV.RDVs (DateDemande, DateRDV, HeureRDV, Commentaire, TelPrincipalProprietaire, TelSecondaire, AdressePropriete, EmailProprietaire, ForfaitID, NomProprietaire, PrenomProprietaire, CodePostal, Deplacement, VisiteVirtuelle, DateFacturation, DateLivraison, Ville, AgentID, CoutTotalAvantTaxes, CoutTotalApresTaxes) VALUES
(GETDATE(), '2015-06-06', '15:10', NULL,4501231234, NULL, '3743 Boul Jean Béliveau', 'unEmail@email.com', 1, 'Fafard', 'Paméla', 'H0H 0H0', 0, 0, NULL, NULL, 'Longueuil', 1, 0, 0)
INSERT INTO RDV.RDVs (DateDemande, DateRDV, HeureRDV, Commentaire, TelPrincipalProprietaire, TelSecondaire, AdressePropriete, EmailProprietaire, ForfaitID, NomProprietaire, PrenomProprietaire, CodePostal, Deplacement, VisiteVirtuelle, DateFacturation, DateLivraison, Ville, AgentID, CoutTotalAvantTaxes, CoutTotalApresTaxes) VALUES
(GETDATE(), NULL, NULL, NULL,4501231234, NULL, '3045 Paquin', 'unEmail@email.com',3, 'Sylvain','Rodrigue', 'H0H 0H0', 0, 0, NULL, NULL, 'Sainte-Madeleine', 3, 0, 0)
INSERT INTO RDV.RDVs (DateDemande, DateRDV, HeureRDV, Commentaire, TelPrincipalProprietaire, TelSecondaire, AdressePropriete, EmailProprietaire, ForfaitID, NomProprietaire, PrenomProprietaire, CodePostal, Deplacement, VisiteVirtuelle, DateFacturation, DateLivraison, Ville, AgentID, CoutTotalAvantTaxes, CoutTotalApresTaxes) VALUES
(GETDATE(), '2015-05-29', '15:35', 'Extérieur seulement. Intérieur pas prêt', 4501231234, NULL, '5525-5527 Baldwin', 'unAutreEmail@email.com',3, 'France','Mayer', 'H0H 0H0', 0, 0, NULL, NULL, 'Sainte-Madeleine', 3, 0, 0)
INSERT INTO RDV.RDVs (DateDemande, DateRDV, HeureRDV, Commentaire, TelPrincipalProprietaire, TelSecondaire, AdressePropriete, EmailProprietaire, ForfaitID, NomProprietaire, PrenomProprietaire, CodePostal, Deplacement, VisiteVirtuelle, DateFacturation, DateLivraison, Ville, AgentID, CoutTotalAvantTaxes, CoutTotalApresTaxes) VALUES
(GETDATE(), '2015-06-04', '16:15', 'Extérieur seulement. Intérieur pas prêt', 4501231234, NULL, '3743 Boul Jean Béliveau', 'helloworld@email.com',3, 'Mandy','Hornez', 'H0H 0H0', 0, 0, NULL, NULL, 'Brossard', 3, 0, 0)
INSERT INTO RDV.RDVs (DateDemande, DateRDV, HeureRDV, Commentaire, TelPrincipalProprietaire, TelSecondaire, AdressePropriete, EmailProprietaire, ForfaitID, NomProprietaire, PrenomProprietaire, CodePostal, Deplacement, VisiteVirtuelle, DateFacturation, DateLivraison, Ville, AgentID, CoutTotalAvantTaxes, CoutTotalApresTaxes) VALUES
(GETDATE(), '2015-06-15', '15:35', 'Extérieur seulement. Intérieur pas prêt', 4501231234, NULL, '2100-506 du Colisee', 'marco@email.com',3, 'Marie-Hélène','Gagnon', 'H0H 0H0', 0, 0, NULL, NULL, 'Sainte-Julie', 3, 0, 0)
INSERT INTO RDV.RDVs (DateDemande, DateRDV, HeureRDV, Commentaire, TelPrincipalProprietaire, TelSecondaire, AdressePropriete, EmailProprietaire, ForfaitID, NomProprietaire, PrenomProprietaire, CodePostal, Deplacement, VisiteVirtuelle, DateFacturation, DateLivraison, Ville, AgentID, CoutTotalAvantTaxes, CoutTotalApresTaxes) VALUES
(GETDATE(), '2015-06-15', '19:35', 'Extérieur seulement. Intérieur pas prêt', 4501231234, NULL, '1487 de Samares', 'sylvain@hotmail.com',3, 'Sylvain','Rodrigue', 'H0H 0H0', 10, 0, NULL, NULL, 'Chambly', 3, 0, 0)
INSERT INTO RDV.RDVs (DateDemande, DateRDV, HeureRDV, Commentaire, TelPrincipalProprietaire, TelSecondaire, AdressePropriete, EmailProprietaire, ForfaitID, NomProprietaire, PrenomProprietaire, CodePostal, Deplacement, VisiteVirtuelle, DateFacturation, DateLivraison, Ville, AgentID, CoutTotalAvantTaxes, CoutTotalApresTaxes) VALUES
(GETDATE(), '2015-05-30', '10:00', 'Extérieur seulement. Intérieur pas prêt', 4501231234, NULL, '1675-4 Bellevue S', 'Beleau.Carl@hotmail.com',3, 'Carl','Beleau', 'H0H 0H0', 0, 0, NULL, NULL, 'Saint-Hubert', 3, 0, 0)
GO

--Add différent statut
UPDATE RDV.RDVS
SET DateRDV = '2015-07-07'
WHERE RDVID = 2
GO

UPDATE RDV.RDVs
SET DateFacturation = '2015-05-15'
WHERE RDVID = 1
GO

UPDATE RDV.RDVs
SET DateLivraison = '2015-08-12'
WHERE RDVID = 3
GO

/*
INSERT INTO [RDV].[PhotoProprietes]
VALUES('testtt2', 'photo 2', 2)
*/