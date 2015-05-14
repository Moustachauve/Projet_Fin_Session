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

	IF(UPDATE(DateRDV)) BEGIN
		--SET NouveauStatut � Report�e
		IF((SELECT TOP 1 DateRDV FROM RDV.RDVS WHERE RDVID = @RDVID) != @DateRdvUpdate) BEGIN
			SET @NouveauStatut = 'Report�e'
		END
	END

	--SET NouveauStatut � r�alis�e
	IF ((SELECT Url FROM RDV.PhotoProprietes WHERE RDVID = @RDVID) IS NOT NULL) BEGIN
		SET @NouveauStatut = 'R�alis�e'
	END

	--Date livraison
	--SET NouveauStatut � Livr�
	IF ((SELECT DateLivraison FROM RDV.PhotoProprietes WHERE RDVID = @RDVID) IS NOT NULL) BEGIN
		SET @NouveauStatut = 'Livr�'
	END

	--SET NouveauStatut � Factur�e
	IF((SELECT DateFacturation FROM RDV.RDVs WHERE RDVID = @RDVID) IS NOT NULL) BEGIN
		SET @NouveauStatut = 'Factur�e'
	END

	--UPDATE le statut � la fin selon si c'est un update ou un insert
	INSERT INTO RDV.Statuts
	VALUES (GETDATE(), @NouveauStatut, @RDVID)
GO

UPDATE RDV.RDVS
SET DateRDV = '2015-07-07'
WHERE RDVID = 26
GO


--UDF
/* Quand prix change(update prix)/cr�er rdv, va falloir additionne prix forfait + frais d�placement + visite virtuel

prix = cout total avant taxe

prix calcul apr�s taxes

taxe = prix * 1.15
*/