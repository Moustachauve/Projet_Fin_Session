USE [H15_PROJET_E05]
GO

--RDV
-------------------------------------------------------------------

--DROP TABLE RDV.RDVs

CREATE TABLE RDV.RDVs(
	RDVID INT NOT NULL IDENTITY,
	DateDemande DATETIME NOT NULL,
	DateRDV DATE Null,
	HeureRDV TIME NULL,
	Commentaire NVARCHAR(MAX) NULL,
	NomPrenomProprietaire NVARCHAR(70) NOT NULL,
	TelPrincipalProprietaire NVARCHAR(10) NOT NULL,
	TelSecondaire NVARCHAR(10) NULL,
	AdressePropriete NVARCHAR(70) NOT NULL,
	EmailProprietaire NVARCHAR(30) NULL,
	ForfaitID INT NOT NULL

	--NOUVEAU SPRINT 1 (ENLEVER POUR SCREENSHOT)  -- !!! PAS BON !!!
	--Etat nvarchar(50) NOT NULL DEFAULT 'Aucun statut',

	PRIMARY KEY (RDVID)
) ON [PRIMARY];
GO

--Forfait
-------------------------------------------------------------------

CREATE TABLE RDV.Forfaits(
	ForfaitID INT NOT NULL IDENTITY,
	Nom NVARCHAR(30) NOT NULL,
	DescriptionForfait NVARCHAR(MAX),
	Prix MONEY NOT NULL,

	PRIMARY KEY (ForfaitID)
) ON [PRIMARY];

--Keys
-------------------------------------------------------------------

ALTER TABLE RDV.RDVs
	ADD CONSTRAINT FK_RDVs_Forfaits_ForfaitID
	FOREIGN KEY (ForfaitID) 
	REFERENCES RDV.RDVs