/*
DROP TABLE RDV.Statuts
DROP TABLE RDV.PhotoProprietes
DROP TABLE Paiement.Taxes
DROP TABLE Agent.Agents
DROP TABLE RDV.RDVs
DROP TABLE RDV.Forfaits
*/

CREATE DATABASE H15_PROJET_E05
GO
USE [H15_PROJET_E05]
GO
CREATE SCHEMA RDV;
GO
CREATE SCHEMA Agent;
GO
CREATE SCHEMA Paiement
GO

--RDV
-------------------------------------------------------------------  --DROP TABLE RDV.RDVs

CREATE TABLE RDV.RDVs(
	RDVID INT NOT NULL IDENTITY,
	DateDemande DATETIME NOT NULL,
	DateRDV DATE NULL,
	HeureRDV TIME NULL,
	Commentaire NVARCHAR(MAX) NULL,
	NomPrenomProprietaire NVARCHAR(70) NOT NULL,
	TelPrincipalProprietaire BIGINT NOT NULL,
	TelSecondaire BIGINT NULL,
	AdressePropriete NVARCHAR(70) NOT NULL,
	EmailProprietaire NVARCHAR(30) NULL,
	ForfaitID INT NOT NULL

	PRIMARY KEY (RDVID)
) ON [PRIMARY];
GO

--Forfaits
------------------------------------------------------------------- --DROP TABLE RDV.Forfaits

CREATE TABLE RDV.Forfaits(
	ForfaitID INT NOT NULL IDENTITY,
	Nom NVARCHAR(30) NOT NULL,
	DescriptionForfait NVARCHAR(MAX),
	Prix MONEY NOT NULL,

	PRIMARY KEY (ForfaitID)
) ON [PRIMARY];

--Foreign Keys
-------------------------------------------------------------------

ALTER TABLE RDV.RDVs
	ADD CONSTRAINT FK_RDVs_Forfaits_ForfaitID
	FOREIGN KEY (ForfaitID) 
	REFERENCES RDV.Forfaits

--RDV
-------------------------------------------------------------------  --DROP TABLE RDV.RDVs

ALTER TABLE RDV.RDVs
DROP COLUMN NomPrenomProprietaire

ALTER TABLE RDV.RDVs
ADD NomProprietaire NVARCHAR(70) NOT NULL,
	PrenomProprietaire NVARCHAR(70) NOT NULL DEFAULT 'N/D',
	CodePostal NVARCHAR(7) NOT NULL DEFAULT 'N/D',
	CoutTotalAvantTaxes MONEY NOT NULL DEFAULT 0,
	CoutTotalApresTaxes MONEY NOT NULL DEFAULT 0,
	Deplacement MONEY NULL DEFAULT 0,
	VisiteVirtuelle MONEY NULL DEFAULT 0,
	DateFacturation DATE NULL,
	DateLivraison DATE NULL,
	Ville NVARCHAR(70) NOT NULL DEFAULT('N/D')
GO


--Agent
----------------------------------------------------------------------
CREATE TABLE Agent.Agents(
	AgentID INT NOT NULL IDENTITY,
	NomAgent NVARCHAR(50) NOT NULL,
	PrenomAgent NVARCHAR(50) NOT NULL,
	NomEntreprise NVARCHAR(50) NOT NULL,
	Adresse NVARCHAR(50) NOT NULL,
	CodePostal NVARCHAR(7) NOT NULL,
	TelPrincipal BIGINT NOT NULL,
	TelSecondaire BIGINT NULL DEFAULT 'N/D'

	PRIMARY KEY (AgentID)
) ON [PRIMARY];
GO

--Taxe
-------------------------------------------------------------------  --DROP TABLE Paiement.Taxe
CREATE TABLE Paiement.Taxes(
	TaxeID INT NOT NULL IDENTITY,
	Nom nvarchar(5) NOT NULL,
	Pourcentage DECIMAL NOT NULL

	PRIMARY KEY(TaxeID)
)ON [PRIMARY]

--Statut
------------------------------------------------------------------- --DROP TABLE RDV.Statut

CREATE TABLE RDV.Statuts(
	StatutID INT NOT NULL IDENTITY,
	DateModification DATETIME NOT NULL DEFAULT(GETDATE()), 
	DescriptionStatut NVARCHAR(50) NOT NULL,
	RDVID INT NOT NULL,
	Importance INT NOT NULL DEFAULT 0

	PRIMARY KEY (StatutID)
) ON [PRIMARY];


--Foreign Keys
-------------------------------------------------------------------

ALTER TABLE RDV.Statuts
	ADD CONSTRAINT FK_RDV_Statut_StatutID
	FOREIGN KEY (RDVID)
	REFERENCES RDV.RDVs (RDVID)

--PhotoPropriete
-------------------------------------------------------------------  --DROP TABLE RDV.PhotoPropriete

CREATE TABLE RDV.PhotoProprietes(
	PhotoProprieteID INT NOT NULL IDENTITY,
	Url NVARCHAR(100) NOT NULL,
	DescriptionPhoto NVARCHAR(300) NULL,
	RDVID INT NOT NULL

	PRIMARY KEY (PhotoProprieteID)
) ON [PRIMARY];

ALTER TABLE RDV.PhotoProprietes
	ADD CONSTRAINT FK_RDVs_PhotoPropriete_RDVID
	FOREIGN KEY (RDVID) 
	REFERENCES RDV.RDVs

ALTER TABLE Agent.Agents
ADD Email1 NVARCHAR(30) NOT NULL DEFAULT 'N/D',
	Email2 NVARCHAR(30) NULL,
	Email3 NVARCHAR(30) NULL


ALTER TABLE RDV.RDVs
ADD AgentID int NOT NULL DEFAULT 0


ALTER TABLE RDV.RDVs
	ADD CONSTRAINT FK_RDVs_Agents_AgentID
	FOREIGN KEY (AgentID) 
	REFERENCES Agent.Agents

USE [H15_PROJET_E05]
GO

--ID	Description
--1		Demandée
--2		Confirmée
--3		Reportée
--4		Réalisée
--5		Livrée
--6		Facturée

--UDF
IF OBJECT_ID ('RDV.udf_CoutTotalAvantTaxes') IS NOT NULL DROP FUNCTION RDV.udf_CoutTotalAvantTaxes
GO
CREATE FUNCTION RDV.udf_CoutTotalAvantTaxes (
	@RDVID AS INT
)
RETURNS MONEY
AS 
BEGIN
	DECLARE @ForfaitIDselonRDVID INT
	DECLARE @prixBaseForfait MONEY
	DECLARE @CoutDeplacement MONEY
	DECLARE @CoutVisiteVirtuelle MONEY
	DECLARE @CoutTotalAvantTaxes MONEY

	--SET ForfaitID SELON LE RDVID (PLUS SIMPLE QU'UN INNER JOIN ET ON A BESOIN DE SE SELECT), LE COUT DE DEPLACEMENT ET LE COUT DE LA VISITE VIRTUELLE
	SELECT	@ForfaitIDselonRDVID = ForfaitID,
			@CoutDeplacement = Deplacement,
			@CoutVisiteVirtuelle = VisiteVirtuelle
	FROM RDV.RDVs
	WHERE RDVID = @RDVID
	
	--SET LE PRIX
	SELECT @prixBaseForfait = Prix
	FROM RDV.Forfaits
	WHERE ForfaitID = @ForfaitIDselonRDVID
	
	--CALCULE LE @CoutTotalAvantTaxes
	SET @CoutTotalAvantTaxes = (@prixBaseForfait + @CoutDeplacement + @CoutVisiteVirtuelle)
	
	RETURN @CoutTotalAvantTaxes
END
GO

IF OBJECT_ID ('RDV.udf_CoutTotalApresTaxes') IS NOT NULL DROP FUNCTION RDV.udf_CoutTotalApresTaxes
GO
CREATE FUNCTION RDV.udf_CoutTotalApresTaxes (
	@RDVID AS INT
)
RETURNS MONEY
AS 
BEGIN
	DECLARE @CoutFinalAvecTaxes MONEY
	DECLARE @CoutTotalAvantTaxes MONEY
	DECLARE @PrixTPS MONEY
	DECLARE @PrixTVQ MONEY

	--SET @CoutTotalAvantTaxes = RDV.udf_CoutTotalAvantTaxes(@RDVID)
	SELECT @CoutTotalAvantTaxes = CoutTotalAvantTaxes FROM RDV.RDVs WHERE RDVID = @RDVID

	--CALCULE LES PRIX SELON LA TPS ET LA TVQ
	SELECT @PrixTPS = ROUND((@CoutTotalAvantTaxes*(Pourcentage/100)), 2,1) FROM [Paiement].[Taxes] WHERE Nom = 'TPS'
	SELECT @PrixTVQ = ROUND((@CoutTotalAvantTaxes*(Pourcentage/100)), 2,1) FROM Paiement.Taxes WHERE Nom = 'TVQ'

	SET @CoutFinalAvecTaxes = @CoutTotalAvantTaxes + @PrixTPS + @PrixTVQ

	RETURN  @CoutFinalAvecTaxes
END
GO

IF OBJECT_ID ('RDV.trg_GererStatutETTaxes') IS NOT NULL DROP TRIGGER RDV.trg_GererStatutETTaxes
GO
CREATE TRIGGER RDV.trg_GererStatutETTaxes
ON RDV.RDVs
AFTER INSERT
AS
	
	DECLARE @RDVID INT
	DECLARE @NouveauStatut NVARCHAR(50) = 'Demandée'
	DECLARE @DateRdvUpdate DATE
	
	DECLARE @importance INT = 1

	SELECT @RDVID = RDVID FROM inserted
	SELECT @DateRdvUpdate = DateRDV	FROM deleted
	--SET NouveauStatut à DEMANDÉE
	IF((SELECT COUNT(RDVID) FROM RDV.Statuts WHERE RDVID = @RDVID) = 0) BEGIN --Si le nombre total de statuts de RDVID est égal a 0, ...
		SET @NouveauStatut = 'Demandée'
		SET @importance = 1
	END

	--SET NouveauStatut à CONFIRMÉE
	IF ((SELECT TOP 1 DateRDV FROM RDV.RDVs WHERE RDVID = @RDVID) IS NOT NULL) BEGIN --Si la date du RDV
		SET @NouveauStatut = 'Confirmée'
		SET @importance = 2
	END

	IF(UPDATE(DateRDV)) BEGIN
		--SET NouveauStatut à Reportée
		IF((SELECT TOP 1 DateRDV FROM RDV.RDVs WHERE RDVID = @RDVID) != @DateRdvUpdate) BEGIN
			SET @NouveauStatut = 'Reportée'
			SET @importance = 3
		END
	END

	--SET NouveauStatut à Livré
	IF ((SELECT DateLivraison FROM RDV.RDVs WHERE RDVID = @RDVID) IS NOT NULL) BEGIN
		SET @NouveauStatut = 'Livrée'
		SET @importance = 5
	END


	--SET NouveauStatut à Facturée
	IF((SELECT DateFacturation FROM RDV.RDVs WHERE RDVID = @RDVID) IS NOT NULL) BEGIN
		SET @NouveauStatut = 'Facturée'
		SET @importance = 6
	END 

	INSERT INTO RDV.Statuts
	VALUES (GETDATE(), @NouveauStatut, @RDVID, @importance)
	
	
GO

IF OBJECT_ID ('RDV.trg_GererTaxes') IS NOT NULL DROP TRIGGER RDV.trg_GererTaxes
GO
CREATE TRIGGER RDV.trg_GererTaxes
ON RDV.Statuts
AFTER INSERT
AS
	DECLARE @IDaChanger INT
	SELECT @IDaChanger = RDVID FROM inserted
	
	DECLARE @TotalAvantTaxes MONEY
	SET @TotalAvantTaxes = RDV.udf_CoutTotalAvantTaxes (@IDaChanger)

	UPDATE RDV.RDVs
	SET [CoutTotalAvantTaxes] = @TotalAvantTaxes
	WHERE RDVID = @IDaChanger

	DECLARE @TotalApresTaxes MONEY
	SET @TotalApresTaxes = RDV.udf_CoutTotalApresTaxes(@IDaChanger)

	UPDATE RDV.RDVs
	SET [CoutTotalApresTaxes] = @TotalApresTaxes
	WHERE RDVID = @IDaChanger
GO

IF OBJECT_ID ('RDV.trg_GererStatutPhotos') IS NOT NULL DROP TRIGGER RDV.trg_GererStatutPhotos
GO
CREATE TRIGGER RDV.trg_GererStatutPhotos
ON [RDV].[PhotoProprietes]
AFTER UPDATE, INSERT
AS
	DECLARE @RDVID INT
	DECLARE @NouveauStatut NVARCHAR(50)
	DECLARE @importance INT

	SELECT @RDVID = RDVID FROM inserted

	--SET NouveauStatut à réalisée
	IF ((SELECT COUNT(Url) FROM RDV.PhotoProprietes WHERE RDVID = @RDVID) != 0) BEGIN
		SET @NouveauStatut = 'Réalisée'
		SET @importance = 4
	END

	INSERT INTO RDV.Statuts
	VALUES (GETDATE(), @NouveauStatut, @RDVID, @importance)
GO

--SELECT RDVID, NomProprietaire + ', '+ PrenomProprietaire AS 'Nom, Prénom', RDV.udf_CoutTotalAvantTaxes(RDVID) AS 'Cout Avant Taxes', RDV.udf_CoutTotalApresTaxes(RDVID) AS 'Cout Après Taxes', Deplacement, VisiteVirtuelle FROM RDV.RDVs
GO

IF OBJECT_ID ('Agent.RapportMensuel') IS NOT NULL DROP PROCEDURE Agent.RapportMensuel
GO
CREATE PROCEDURE Agent.RapportMensuel
@mois int,
@année int
AS
BEGIN
	select r.DateDemande, a.NomAgent + ', ' + a.PrenomAgent AS 'Nom, Prénom', a.NomEntreprise, r.CoutTotalAvantTaxes, r.Deplacement, r.VisiteVirtuelle , r.CoutTotalApresTaxes
	from RDV.RDVs r INNER JOIN [Agent].[Agents] a ON  a.AgentID = r.AgentID
	WHERE	YEAR(r.DateFacturation) = @année AND
			MONTH(r.DateFacturation) = @mois
	ORDER BY a.NomAgent, a.PrenomAgent
END

--EXEC Agent.RapportMensuel @mois = 05, @année = 2015

GO

USE [H15_PROJET_E05]
GO

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
(GETDATE(), NULL, NULL, NULL,4501231234, NULL, '3045 Paquin', 'EricCoolFriend@hotmail.com',3, 'Sylvain','Rodrigue', 'H0H 0H0', 0, 0, NULL, NULL, 'Sainte-Madeleine', 3, 0, 0)
INSERT INTO RDV.RDVs (DateDemande, DateRDV, HeureRDV, Commentaire, TelPrincipalProprietaire, TelSecondaire, AdressePropriete, EmailProprietaire, ForfaitID, NomProprietaire, PrenomProprietaire, CodePostal, Deplacement, VisiteVirtuelle, DateFacturation, DateLivraison, Ville, AgentID, CoutTotalAvantTaxes, CoutTotalApresTaxes) VALUES
(GETDATE(), '2015-05-29', '15:35', 'Extérieur seulement. Intérieur pas prêt', 4501231234, NULL, '5525-5527 Baldwin', 'EricCoolFriend@hotmail.com',3, 'France','Mayer', 'H0H 0H0', 0, 0, NULL, NULL, 'Sainte-Madeleine', 3, 0, 0)
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

INSERT INTO [RDV].[PhotoProprietes]
VALUES('testtt2', 'photo 2', 2)