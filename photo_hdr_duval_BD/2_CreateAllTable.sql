USE [H15_PROJET_E05]
GO
CREATE SCHEMA RDV;
GO
CREATE SCHEMA Agent;
GO
CREATE SCHEMA Paiement
GO

/*
DROP TABLE Agent.Agents
DROP TABLE Agent.Emails
DROP TABLE RDV.PhotoProprietes
DROP TABLE RDV.Statuts
DROP TABLE Paiement.Factures
DROP TABLE Paiement.Taxes
DROP TABLE RDV.Forfaits
DROP TABLE RDV.RDVs
*/

--RDV
-------------------------------------------------------------------  --DROP TABLE RDV.RDVs

CREATE TABLE RDV.RDVs(
	RDVID INT NOT NULL IDENTITY,
	DateDemande DATETIME NOT NULL,
	DateRDV DATE NULL,
	HeureRDV TIME NULL,
	Commentaire NVARCHAR(MAX) NULL DEFAULT('N/A'),
	NomProprietaire NVARCHAR(70) NOT NULL,
	PrenomProprietaire NVARCHAR(70) NOT NULL,
	TelPrincipalProprietaire BIGINT NOT NULL,
	TelSecondaire BIGINT NULL,
	AdressePropriete NVARCHAR(70) NOT NULL,
	Ville NVARCHAR(70) NOT NULL DEFAULT('N/A'), -- ajouté 2015-05-06 11:34
	EmailProprietaire NVARCHAR(30) NULL,
	ForfaitID INT NOT NULL,
	FactureID INT NULL
	--StatutID INT NOT NULL DEFAULT 0

	PRIMARY KEY (RDVID)
) ON [PRIMARY];
GO

--Agent.Agents
-------------------------------------------------------------------  --DROP TABLE Agent.Agents
CREATE TABLE Agent.Agents(
	AgentID INT NOT NULL IDENTITY,
	NomAgent NVARCHAR(50) NOT NULL,
	PrenomAgent NVARCHAR(50) NOT NULL,
	NomEntreprise NVARCHAR(50) NOT NULL,
	Adresse NVARCHAR(50) NOT NULL,
	TelPrincipal BIGINT NOT NULL,
	TelSecondaire BIGINT NULL

	PRIMARY KEY (AgentID)
) ON [PRIMARY];
GO

--Agent.Emails
-------------------------------------------------------------------  --DROP TABLE Agent.Emails
CREATE TABLE Agent.Emails(
	EmailID int NOT NULL IDENTITY,
	Email NVARCHAR(50) NOT NULL,
	AgentID INT NOT NULL,
	IsPrimary Bit NOT NULL DEFAULT 0

	PRIMARY KEY (EmailID)
) ON [PRIMARY]
GO

--RDV.PhotoProprietes
-------------------------------------------------------------------  --DROP TABLE RDV.PhotoProprietes
CREATE TABLE RDV.PhotoProprietes(
	PhotoProprieteID INT NOT NULL IDENTITY,
	Url NVARCHAR(100) NOT NULL,
	DescriptionPhoto NVARCHAR(300) NULL,
	RDVID INT NOT NULL

	PRIMARY KEY (PhotoProprieteID)
) ON [PRIMARY];


--RDV.Forfaits
-------------------------------------------------------------------  --DROP TABLE RDV.Forfaits
CREATE TABLE RDV.Forfaits(
	ForfaitID INT NOT NULL IDENTITY,
	Nom NVARCHAR(30) NOT NULL,
	DescriptionForfait NVARCHAR(MAX),
	Prix MONEY NOT NULL,

	PRIMARY KEY (ForfaitID)
) ON [PRIMARY];

-- RDV.Statuts
-------------------------------------------------------------------  --DROP TABLE RDV.Statuts
CREATE TABLE RDV.Statuts(
	StatutID INT NOT NULL IDENTITY,
	DateModification DATETIME NOT NULL DEFAULT(GETDATE()), 
	DescriptionStatut NVARCHAR(50) NOT NULL,
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
	REFERENCES Agent.Agents

ALTER TABLE RDV.PhotoProprietes
	ADD CONSTRAINT FK_RDVs_PhotoPropriete_RDVID
	FOREIGN KEY (RDVID) 
	REFERENCES RDV.RDVs

ALTER TABLE RDV.Statuts
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