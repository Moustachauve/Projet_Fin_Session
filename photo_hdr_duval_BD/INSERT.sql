USE [H15_PROJET_E05]
GO

--RDV.forfaits
INSERT INTO RDV.Forfaits VALUES
('Bronze', '20 photos et 35 minutes', 90),
('Argent', '26 photos et 50 mintues', 105),
('Or', '32 photos et 70 mintues', 120),
('Personnalis�', '� la discretion du photographe', 0)
GO

--Agent.Agent
INSERT INTO Agent.Agents VALUES
('Monette','Jamy-jeff', 'soci�t� 1', '123 une adresse','H0H 0H0', '1231231234', NULL),
('Despins','Francis', '1 soci�t�', '321 adresse une','H0H 0H0', '4321321321', NULL),
('Fortier','Kevin', 'soci�t� 2', '472 rue secondaire','H0H 0H0', '7531594862', NULL)
GO

--Agent.Emails
INSERT INTO Agent.Emails VALUES
('jjeff@hotmail.com', 1, 1),
('francisDespins@hotmail.com', 2, 1),
('FrancisCool123@hotmail.com', 2, 0),
('KevinFortier@hotmail.com', 3, 1)

--RDV.RDVs
--DELETE FROM RDV.Statuts
--DELETE FROM RDV.RDVs
GO
INSERT INTO RDV.RDVs VALUES (GETDATE(),	NULL,  NULL,'Appeller telephone secondaire avant 17h', 'Leduc',	'Eric',	4501231234,	NULL, '4321 Pas la vrai rue', 'H0H 0H0', 'Longueuil', 'EricCoolFriend@hotmail.com', 2, 0, 0, 0, 0, NULL, NULL, 2)
INSERT INTO RDV.RDVs VALUES (GETDATE(),	'2015-06-06', '15:10', 'N/A', 'Fafard','Pamela', 4501231235, 5141231234, '123 Sesame Street', 'H0H 0H0','Saint-Amable', 'unEmail@email.com', 1, 0, 0, 0, 0,	NULL, NULL, 1)
INSERT INTO RDV.RDVs VALUES (GETDATE(), NULL, NULL, 'N/A', 'Bastien','�ve', 4501231236, NULL, 'rue Principal','H0H 0H0', 'Saint-Amable', 'unAutreEmail@email.com', 3, 0, 0, 0, 0, NULL, NULL, 3)
INSERT INTO RDV.RDVs VALUES (GETDATE(),	'2015-05-29',  '15:35','Appeller avant 19h', 'Gigu�re', 'Charles', 4501231234,	NULL, '3042 Rue des pins', 'H0H 0H0', 'Longueuil', 'Mium_Mium_Mium@hotmail.com', 2, 0, 0, 0, 0, NULL, NULL, 1)
INSERT INTO RDV.RDVs VALUES (GETDATE(),	'2015-05-18', '15:10', 'N/A', 'Tristan','H�tu', 4501231235, 5141231234, '4123 Rue des �rables', 'H0H 0H0','Longueuil', 'email@email.com', 1, 0, 0, 0, 0, NULL, NULL, 1)
INSERT INTO RDV.RDVs VALUES (GETDATE(), NULL, NULL, 'N/A', 'Rasicot','Tristan', 4501231236, NULL, '3214 Rue Des bouleaux','H0H 0H0', 'Saint-Julie', 'CeciEstUnEmailValide@email.com', 3, 0, 0, 0, 0, NULL, NULL, 3)
GO

--Paiement.Taxes
INSERT INTO Paiement.Taxes VALUES
('TPS', 5),
('TVQ', 9.975)