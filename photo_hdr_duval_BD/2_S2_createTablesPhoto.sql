USE [H15_PROJET_E05]
GO

--PhotoPropriete
-------------------------------------------------------------------  --DROP TABLE RDV.PhotoPropriete

CREATE TABLE RDV.PhotoPropriete(
	PhotoProprieteID INT NOT NULL IDENTITY,
	Url NVARCHAR(100) NOT NULL,
	DescriptionPhoto NVARCHAR(300) NULL,
	RDVID INT NOT NULL

	PRIMARY KEY (PhotoProprieteID)
) ON [PRIMARY];

ALTER TABLE RDV.PhotoPropriete
	ADD CONSTRAINT FK_RDVs_PhotoPropriete_RDVID
	FOREIGN KEY (RDVID) 
	REFERENCES RDV.RDVs