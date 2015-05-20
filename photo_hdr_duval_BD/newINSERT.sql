USE [H15_PROJET_E05]
GO

--RDV.forfaits
INSERT INTO  RDV.Forfaits (Nom, DescriptionForfait, Prix) VALUES
('Bronze', '20 photos et 35 minutes', 90),
('Argent', '26 photos et 50 mintues', 105),
('Or', '32 photos et 70 mintues', 120),
('Personnalis�', '� la discretion du photographe', 0)
GO

--Agent.Agent
INSERT INTO Agent.Agents (NomAgent, PrenomAgent, NomEntreprise, Adresse, CodePostal, TelPrincipal, TelSecondaire, Email1, Email2, Email3)VALUES
('Monette','Jamy-jeff', 'Remax', '123 une adresse','H0H 0H0', '1231231234', NULL, 'jjeff@hotmail.com', NULL, NULL),
('Despins','Francis', 'Via Capitale', '321 adresse une','H0H 0H0', '4321321321', NULL, 'francisDespins@hotmail.com', 'FrancisCool123@hotmail.com', NULL),
('Fortier','Kevin', 'Immobilier Quebec', '472 rue secondaire','H0H 0H0', '7531594862', NULL, 'KevinFortier@hotmail.com', NULL, NULL)
GO

INSERT INTO RDV.RDVs (DateDemande, DateRDV, HeureRDV, Commentaire, TelPrincipalProprietaire, TelSecondaire, AdressePropriete, EmailProprietaire, ForfaitID, NomProprietaire, PrenomProprietaire, CodePostal, Deplacement, VisiteVirtuelle, DateFacturation, DateLivraison, Ville, AgentID) VALUES
(GETDATE(), NULL, NULL, 'Appeller telephone secondaire avant 17h',4501231234, NULL, '7350-16 du Chardonneret', 'EricCoolFriend@hotmail.com',2, 'Leduc', '�ric', 'H0H 0H0', 10, 5, NULL, NULL, 'Brossard', 2)
INSERT INTO RDV.RDVs (DateDemande, DateRDV, HeureRDV, Commentaire, TelPrincipalProprietaire, TelSecondaire, AdressePropriete, EmailProprietaire, ForfaitID, NomProprietaire, PrenomProprietaire, CodePostal, Deplacement, VisiteVirtuelle, DateFacturation, DateLivraison, Ville, AgentID) VALUES
(GETDATE(), '2015-06-06', '15:10', 'N/D',4501231234, NULL, '3743 Boul Jean B�liveau', 'unEmail@email.com', 1, 'Fafard','Pam�la', 'H0H 0H0', 0, 0, NULL, NULL, 'Longueuil', 1)
INSERT INTO RDV.RDVs (DateDemande, DateRDV, HeureRDV, Commentaire, TelPrincipalProprietaire, TelSecondaire, AdressePropriete, EmailProprietaire, ForfaitID, NomProprietaire, PrenomProprietaire, CodePostal, Deplacement, VisiteVirtuelle, DateFacturation, DateLivraison, Ville, AgentID) VALUES
(GETDATE(), NULL, NULL, 'N/D',4501231234, NULL, '3045 Paquin', 'EricCoolFriend@hotmail.com',3, 'Fafard','Pam�la', 'H0H 0H0', 0, 0, NULL, NULL, 'Sainte-Madeleine', 3)
INSERT INTO RDV.RDVs (DateDemande, DateRDV, HeureRDV, Commentaire, TelPrincipalProprietaire, TelSecondaire, AdressePropriete, EmailProprietaire, ForfaitID, NomProprietaire, PrenomProprietaire, CodePostal, Deplacement, VisiteVirtuelle, DateFacturation, DateLivraison, Ville, AgentID) VALUES
(GETDATE(), '2015-05-29',  '15:35', 'Ext�rieur seulement. Int�rieur pas pr�t', 4501231234, NULL, '5525-5527 Baldwin', 'EricCoolFriend@hotmail.com',3, 'Fafard','Pam�la', 'H0H 0H0', 0, 0, NULL, NULL, 'Sainte-Madeleine', 3)


--Paiement.Taxes
INSERT INTO Paiement.Taxes (Nom, Pourcentage) VALUES
('TPS', 5),
('TVQ', 9.975)
GO

--Add diff�rent statut
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

INSERT INTO [RDV].[PhotoProprietes]
VALUES('testtt2', 'photo 2', 2)