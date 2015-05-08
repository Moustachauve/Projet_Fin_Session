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
	Commentaire NVARCHAR(MAX) NULL DEFAULT('N/A'),
	NomPrenomProprietaire NVARCHAR(70) NOT NULL,
	TelPrincipalProprietaire BIGINT NOT NULL,
	TelSecondaire BIGINT NULL,
	AdressePropriete NVARCHAR(70) NOT NULL,
	Ville NVARCHAR(70) NOT NULL DEFAULT('N/A'), -- ajout� 2015-05-06 11:34
	EmailProprietaire NVARCHAR(30) NULL,
	ForfaitID INT NOT NULL,
	--StatutID INT NOT NULL DEFAULT 0

	PRIMARY KEY (RDVID)
) ON [PRIMARY];
GO

--Agent
CREATE TABLE Agent.Agent(
	AgentID INT NOT NULL IDENTITY,
	NomPrenomAgent NVARCHAR(50) NOT NULL,
	NomEntreprise NVARCHAR(50) NOT NULL,
	Adresse NVARCHAR(50) NOT NULL,
	TelPrincipal BIGINT NOT NULL,
	TelSecondaire BIGINT NOT NULL

	PRIMARY KEY (AgentID)
) ON [PRIMARY];
GO

--Emails
CREATE TABLE Agent.Emails(
	EmailID int NOT NULL IDENTITY,
	Email NVARCHAR(50) NOT NULL,
	AgentID INT NOT NULL,
	IsPrimary Bit NOT NULL DEFAULT 0

	PRIMARY KEY (EmailID)
) ON [PRIMARY]
GO

--PhotoPropriete
CREATE TABLE RDV.PhotoPropriete(
	PhotoProprieteID INT NOT NULL IDENTITY,
	Url NVARCHAR(100) NOT NULL,
	DescriptionPhoto NVARCHAR(300) NULL,
	RDVID INT NOT NULL

	PRIMARY KEY (PhotoProprieteID)
) ON [PRIMARY];


--Forfaits
CREATE TABLE RDV.Forfaits(
	ForfaitID INT NOT NULL IDENTITY,
	Nom NVARCHAR(30) NOT NULL,
	DescriptionForfait NVARCHAR(MAX),
	Prix MONEY NOT NULL,

	PRIMARY KEY (ForfaitID)
) ON [PRIMARY];

-- RDV.Statut
CREATE TABLE RDV.Statut(
	StatutID INT NOT NULL IDENTITY,
	DateModification DATETIME NOT NULL DEFAULT(GETDATE()), 
	DescriptionStatut NVARCHAR(50) NOT NULL,
	Statut INT NOT NULL,
	RDVID INT NOT NULL

	PRIMARY KEY (StatutID)
) ON [PRIMARY];


--Foreign Keys
-------------------------------------------------------------------

ALTER TABLE RDV.RDVs
	ADD CONSTRAINT FK_RDVs_Forfaits_ForfaitID
	FOREIGN KEY (ForfaitID) 
	REFERENCES RDV.Forfaits
	
ALTER TABLE Agent.Emails
	ADD CONSTRAINT FK_Agent_Emails_EmailID
	FOREIGN KEY (AgentID)
	REFERENCES Agent.Agent

ALTER TABLE RDV.PhotoPropriete
	ADD CONSTRAINT FK_RDVs_PhotoPropriete_RDVID
	FOREIGN KEY (RDVID) 
	REFERENCES RDV.RDVs

ALTER TABLE RDV.Statut
	ADD CONSTRAINT FK_RDV_Statut_StatutID
	FOREIGN KEY (StatutID)
	REFERENCES RDV.RDVs

	--Facture
-------------------------------------------------------------------  --DROP TABLE Paiement.Factures

CREATE TABLE Paiement.Factures(
	FactureID INT NOT NULL IDENTITY,
	CoutTotal INT NULL,
	Deplacement INT NULL,
	VisiteVirtuelle INT NULL,
	AsVisiteVirtuelle binary NOT NULL DEFAULT 0,
	RDVID INT NOT NULL

	PRIMARY KEY (FactureID)
) ON [PRIMARY];

ALTER TABLE Paiement.Factures
	ADD CONSTRAINT FK_RDVs_Factures_RDVID
	FOREIGN KEY (RDVID) 
	REFERENCES RDV.RDVs

--Taxe
-------------------------------------------------------------------  --DROP TABLE Paiement.Taxes
CREATE TABLE Paiement.Taxes(
	TaxeID INT NOT NULL IDENTITY,
	Nom nvarchar(5) NOT NULL,
	Pourcentage DECIMAL(3,2) NOT NULL

	PRIMARY KEY(TaxeID)
)ON [PRIMARY]