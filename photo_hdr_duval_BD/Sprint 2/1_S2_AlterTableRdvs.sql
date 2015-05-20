USE [H15_PROJET_E05]
GO

--RDV
-------------------------------------------------------------------  --DROP TABLE RDV.RDVs

ALTER TABLE RDV.RDVs
DROP COLUMN NomPrenomProprietaire

ALTER TABLE RDV.RDVs
ADD NomProprietaire NVARCHAR(70) NOT NULL,
	PrenomProprietaire NVARCHAR(70) NOT NULL DEFAULT 'N/D',
	CodePostal NVARCHAR(7) NOT NULL DEFAULT 'N/D',
	CoutTotalAvantTaxes MONEY NOT NULL DEFAULT 0 CHECK(CoutTotalAvantTaxes >= 0),
	CoutTotalApresTaxes MONEY NOT NULL DEFAULT 0 CHECK(CoutTotalApresTaxes >= 0),
	Deplacement MONEY NOT NULL DEFAULT 0,
	VisiteVirtuelle MONEY NOT NULL DEFAULT 0,
	DateFacturation DATE NULL,
	DateLivraison DATE NULL,
	Ville NVARCHAR(70) NOT NULL DEFAULT('N/D')
GO

