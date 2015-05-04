USE [H15_PROJET_E05]
GO

--RDV
-------------------------------------------------------------------

--DROP TABLE RDV.RDVs

CREATE TABLE RDV.RDVs(
	RDVID int NOT NULL IDENTITY,
	DateRDV DateTime Null,
	HeureRDV time NULL,
	Commentaire nvarchar(MAX) NULL,
	NomPrenomProprietaire nvarchar(70) NOT NULL,
	TelPrincipalProprietaire nvarchar(10) NOT NULL,
	TelSecondaire nvarchar(10) NULL,
	AdressePropriete nvarchar(70) NOT NULL,
	EmailProprietaire nvarchar(30) NULL,

	--NOUVEAU SPRINT 1 (ENLEVER POUR SCREENSHOT)
	Etat nvarchar(50) NOT NULL DEFAULT 'Aucun statut',
	DateDemande DateTime NOT NULL

	PRIMARY KEY (RDVID)
) ON [PRIMARY];
GO
