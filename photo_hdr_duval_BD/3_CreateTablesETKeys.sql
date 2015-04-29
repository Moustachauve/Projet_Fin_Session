USE [H15_PROJET_E05]
GO

--RDV
-------------------------------------------------------------------
CREATE TABLE RDV.RDVs(
	RDVID int NOT NULL IDENTITY,
	DateRDV DateTime Null,
	HeureRDV time NULL,
	Commentaire nvarchar(4000) NULL,
	NomPrenomProprio nvarchar(70) NOT NULL,
	TelProprietaire nvarchar(10) NOT NULL,
	AdressePropriete nvarchar(70) NOT NULL,
	EmailProprietaire nvarchar(30) NULL
) ON [PRIMARY];
GO
