USE [H15_PROJET_E05]
GO

--Statut
------------------------------------------------------------------- --DROP TABLE RDV.Statut

CREATE TABLE RDV.Statut(
	StatutID INT NOT NULL IDENTITY,
	DateModification DateTime NOT NULL DEFAULT(GETDATE()), 
	DescriptionStatut NVARCHAR(50) NOT NULL,
	Statut int NOT NULL,
	RDVID int NOT NULL

	PRIMARY KEY (StatutID)
) ON [PRIMARY];


--Foreign Keys
-------------------------------------------------------------------

ALTER TABLE RDV.Statut
	ADD CONSTRAINT FK_RDV_Statut_StatutID
	FOREIGN KEY (StatutID)
	REFERENCES RDV.RDVs

--DONN�ES DE LA TABLE RDV.STATUT
-------------------------------------------------------------------

INSERT INTO RDV.Statut(DescriptionStatut) VALUES ('Demand�e'), ('Confirm�e'), ('Report�e'), ('R�alis�e'), ('Livr�e'), ('Factur�e')