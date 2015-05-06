USE [H15_PROJET_E05]
GO

--RDV.forfaits
INSERT INTO RDV.Forfaits
VALUES('Bronze', '20 photos et 35 minutes', 90),
('Argent', '26 photos et 50 mintues', 105),
('Or', '32 photos et 70 mintues', 120),
('Personnalis�', '� la discretion du photographe', 0)

--RDV.RDVs

INSERT INTO RDV.RDVs VALUES
(GETDATE(), NULL, NULL, 'Appeller telephone secondaire avant 17h', 'Leduc, Eric', 4501231234, 0, '4321 Pas la vrai rue', 'Longueuil', 'EricCoolFriend@hotmail.com', 2),
(GETDATE(), '2015-06-06', '15:10', 'N/A', 'Fafard, Pamela', 4501231235, 5141231234, '123 Sesame Street', 'Saint-Amable', 'unEmail@email.com', 1),
(GETDATE(), NULL, NULL, 'N/A', 'Bastien, �ve', 4501231236, 0, 'rue Principal', 'Saint-Amable', 'unAutreEmail@email.com', 3)

--Agent.Agent
INSERT INTO Agent.Agent VALUES
('Monette, Jamy-jeff', 'soci�t� 1', '123 une adresse', '1231231234', 0),
('Despins, Francis', '1 soci�t�', '321 adresse une', '4321321321', 0),
('Fortier, Kevin', 'soci�t� 2', '472 rue secondaire', '7531594862', 0)

--Agent.Emails
INSERT INTO Agent.Emails VALUES
('jjeff@hotmail.com', 1, 1),
('francisDespins', 2, 1),
('FrancisCool123@hotmail.com', 2, 0),
('KevinFortier@hotmail.com', 3, 1)