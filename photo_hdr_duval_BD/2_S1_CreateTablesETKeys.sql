USE [H15_PROJET_E05]
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
	TelPrincipalProprietaire INT NOT NULL,
	TelSecondaire INT NULL,
	AdressePropriete NVARCHAR(70) NOT NULL,
	Ville NVARCHAR(70) NOT NULL DEFAULT('N/A'), -- ajouté 2015-05-06 11:34
	EmailProprietaire NVARCHAR(30) NULL,
	ForfaitID INT NOT NULL,
	--StatutID INT NOT NULL DEFAULT 0

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

INSERT INTO RDV.Forfaits
VALUES('Bronze', '20 photos et 35 minutes', 90),
('Argent', '26 photos et 50 mintues', 105),
('Or', '32 photos et 70 mintues', 120),
('Personnalisé', 'À la discretion du photographe', 0)

--Foreign Keys
-------------------------------------------------------------------

ALTER TABLE RDV.RDVs
	ADD CONSTRAINT FK_RDVs_Forfaits_ForfaitID
	FOREIGN KEY (ForfaitID) 
	REFERENCES RDV.Forfaits