USE [H15_PROJET_E05]
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

--Foreign Keys
-------------------------------------------------------------------

ALTER TABLE RDV.RDVs
	ADD CONSTRAINT FK_RDVs_Forfaits_ForfaitID
	FOREIGN KEY (ForfaitID) 
	REFERENCES RDV.Forfaits