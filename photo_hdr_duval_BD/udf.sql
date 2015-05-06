USE [H15_PROJET_E05]
GO

--ID	Description
--1		Demand�e
--2		Confirm�e
--3		Report�e
--4		R�alis�e
--5		Livr�e
--6		Factur�e

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

	--SET ID � DEMAND�E
	IF(StatutID = 0) BEGIN
		SET @NouveauStatut = 1
	END

	--SET ID � CONFIRM�E
	IF (DateRDV IS NOT NULL) BEGIN
		SET @NouveauStatut = 2
	END

	--SET ID � Report�e
	IF(DateRDV != @DateRdvUpdate) BEGIN
		SET @NouveauStatut = 3
	END

	--UPDATE le statut � la fin selon si c'est un update ou un insert
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

