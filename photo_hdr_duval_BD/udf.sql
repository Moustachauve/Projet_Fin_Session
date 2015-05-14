USE [H15_PROJET_E05]
GO

--ID	Description
--1		Demandée
--2		Confirmée
--3		Reportée
--4		Réalisée
--5		Livrée
--6		Facturée

CREATE TRIGGER RDV.trg_GererStatut
ON RDV.RDVs
AFTER UPDATE, INSERT
AS
	DECLARE @RDVID INT
	DECLARE @NouveauStatut NVARCHAR(50)
	DECLARE @DateRdvUpdate DATE

	--SET NouveauStatut à DEMANDÉE
	SELECT @RDVID = RDVID FROM inserted

	IF((SELECT COUNT(StatutID) FROM RDV.Statuts WHERE RDVID = @RDVID) = 0) BEGIN --Si le nombre total de statuts de RDVID est égal a 0, ...
		SET @NouveauStatut = 'Demandée'
	END
		
	SELECT @DateRdvUpdate = DateRDV
	FROM deleted

	--SET NouveauStatut à CONFIRMÉE
	IF ((SELECT TOP 1 DateRDV FROM RDV.RDVS WHERE RDVID = @RDVID) IS NOT NULL) BEGIN --Si la date du RDV
		SET @NouveauStatut = 'Confirmée'
	END

	--SET NouveauStatut à Reportée
	IF((SELECT TOP 1 DateRDV FROM RDV.RDVS WHERE RDVID = @RDVID) != @DateRdvUpdate) BEGIN
		SET @NouveauStatut = 'Reportée'
	END

	--SET NouveauStatut à réalisée
	--IF () BEGIN
	--	SET @NouveauStatut = 'Réalisée'
	--END

	--SET NouveauStatut à Livré
	IF ((SELECT Url FROM RDV.PhotoProprietes WHERE RDVID = @RDVID) IS NOT NULL) BEGIN
		SET @NouveauStatut = 'Livré'
	END


	--UPDATE le statut à la fin selon si c'est un update ou un insert
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
		SET @NouveauStatut = 'Facturée'
	END

	INSERT INTO RDV.Statuts
	VALUES (GETDATE(), @NouveauStatut, @RDVID)
GO