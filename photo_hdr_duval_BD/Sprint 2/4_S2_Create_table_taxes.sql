USE [H15_PROJET_E05]
GO

--Taxe
-------------------------------------------------------------------  --DROP TABLE Paiement.Taxe
CREATE TABLE Paiement.Taxes(
	TaxeID INT NOT NULL IDENTITY,
	Nom nvarchar(5) NOT NULL,
	Pourcentage DECIMAL NOT NULL

	PRIMARY KEY(TaxeID)
)ON [PRIMARY]