USE [H15_PROJET_E05]
GO

--ID	Description
--1		Demand�e
--2		Confirm�e
--3		Report�e
--4		R�alis�e
--5		Livr�e
--6		Factur�e

CREATE TRIGGER RDV.trg_GererStatut
ON RDV.RDVs
AFTER UPDATE, INSERT
AS
	DECLARE @RDVID INT
	DECLARE @NouveauStatut NVARCHAR(50)
	DECLARE @DateRdvUpdate DATE

	--SET NouveauStatut � DEMAND�E
	SELECT @RDVID = RDVID FROM inserted

	IF((SELECT COUNT(StatutID) FROM RDV.Statuts WHERE RDVID = @RDVID) = 0) BEGIN --Si le nombre total de statuts de RDVID est �gal a 0, ...
		SET @NouveauStatut = 'Demand�e'
	END
		
	SELECT @DateRdvUpdate = DateRDV
	FROM deleted

	--SET NouveauStatut � CONFIRM�E
	IF ((SELECT TOP 1 DateRDV FROM RDV.RDVS WHERE RDVID = @RDVID) IS NOT NULL) BEGIN --Si la date du RDV
		SET @NouveauStatut = 'Confirm�e'
	END

	--SET NouveauStatut � Report�e
	IF((SELECT TOP 1 DateRDV FROM RDV.RDVS WHERE RDVID = @RDVID) != @DateRdvUpdate) BEGIN
		SET @NouveauStatut = 'Report�e'
	END

	--SET NouveauStatut � r�alis�e
	--IF () BEGIN
	--	SET @NouveauStatut = 'R�alis�e'
	--END

	--SET NouveauStatut � Livr�
	IF ((SELECT Url FROM RDV.PhotoProprietes WHERE RDVID = @RDVID) IS NOT NULL) BEGIN
		SET @NouveauStatut = 'Livr�'
	END


	--UPDATE le statut � la fin selon si c'est un update ou un insert
	INSERT INTO RDV.Statuts
	VALUES (GETDATE(), @NouveauStatut, @RDVID)
GO

UPDATE RDV.RDVS
SET DateRDV = '2015-07-07'
WHERE RDVID = 26
GO

CREATE TRIGGER RDV.trg_Forfait
ON RDV.Forfaits
AFTER UPDATE, INSERT
AS
	DECLARE @ForfaitID int
	SELECT @ForfaitID = ForfaitID FROM inserted

	DECLARE @RDVID INT
	select @RDVID = RDVID from RDV.RDVs
	where ForfaitID = @ForfaitID 
	
	DECLARE @NouveauStatut NVARCHAR(50)

	IF((SELECT FactureFinal FROM RDV.RDVs WHERE RDVID = @RDVID) = 1)BEGIN
		SET @NouveauStatut = 'Factur�e'
	END

	INSERT INTO RDV.Statuts
	VALUES (GETDATE(), @NouveauStatut, @RDVID)
GO