USE [H15_PROJET_E05]
GO

--RDV
-------------------------------------------------------------------
CREATE TABLE RDV.RDVs(
	RDVID int NOT NULL IDENTITY,
	DateRDV DateTime Null,
	HeureRDV time NULL,
	Commentaire nvarchar(MAX) NULL,
	NomPrenomProprietaire nvarchar(70) NOT NULL,
	TelPrincipalProprietaire nvarchar(10) NOT NULL,
	TelCellProprietaire nvarchar(10) NOT NULL,
	AdressePropriete nvarchar(70) NOT NULL,
	EmailProprietaire nvarchar(30) NULL

	PRIMARY KEY (RDVID)
) ON [PRIMARY];
GO
