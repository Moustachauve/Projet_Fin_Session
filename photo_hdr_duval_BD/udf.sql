USE [H15_PROJET_E05]
GO

--ID	Description
--1		Demandée
--2		Confirmée
--3		Reportée
--4		Réalisée
--5		Livrée
--6		Facturée

CREATE TRIGGER trg_RDV.GererStatut
ON RDV.RDVs
AFTER UPDATE, INSERT
AS
	DECLARE @NouveauStatut INT
	DECLARE @RDVIDaChanger INT
	DECLARE @DateRdvUpdate DATE

	SELECT @RDVIDaChanger = RDVID
	FROM inserted

	SELECT @DateRdvUpdate = DateRDV
	FROM updated

	--SET ID à DEMANDÉE
	IF(StatutID = 0) BEGIN
		SET @NouveauStatut = 1
	END

	--SET ID à CONFIRMÉE
	IF (DateRDV IS NOT NULL) BEGIN
		SET @NouveauStatut = 2
	END

	--SET ID à Reportée
	IF(DateRDV != @DateRdvUpdate) BEGIN
		SET @NouveauStatut = 3
	END

	--UPDATE le statut à la fin selon si c'est un update ou un insert
	IF (inserted IS NOT NULL) BEGIN
		UPDATE RDV.RDVs
		SET StatutID = @NouveauStatut
		WHERE RDVID = @RDVIDaChanger
	END ELSE IF( updated IS NOT NULL) BEGIN
		UPDATE RDV.RDVs
		SET StatutID = @NouveauStatut
		WHERE RDVID = @RDVIDaChanger
	END
GO

