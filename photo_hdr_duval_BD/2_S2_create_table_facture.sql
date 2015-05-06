USE [H15_PROJET_E05]
GO

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
-------------------------------------------------------------------  --DROP TABLE Paiement.Taxe
CREATE TABLE Paiement.Taxes(
	TaxeID INT NOT NULL IDENTITY,
	Nom nvarchar(5) NOT NULL,
	Pourcentage DECIMAL NOT NULL

	PRIMARY KEY(TaxeID)
)ON [PRIMARY]