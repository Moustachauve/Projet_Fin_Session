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
	
	--SI LA TABLE UPDATE N'EST PAS NULL 
	IF((SELECT RDVID FROM updated) IS NOT NULL) BEGIN
		SELECT @RDVID = RDVID FROM updated
		
		SELECT @DateRdvUpdate = DateRDV
		FROM updated

		--SET NouveauStatut à CONFIRMÉE
		IF ((SELECT TOP 1 DateRDV FROM RDV.RDVS WHERE RDVID = @RDVID) IS NOT NULL) BEGIN --Si la date du RDV
			SET @NouveauStatut = 'Confirmée'
		END

		--SET NouveauStatut à Reportée
		IF((SELECT TOP 1 DateRDV FROM RDV.RDVS WHERE RDVID = @RDVID) != @DateRdvUpdate) BEGIN
			SET @NouveauStatut = 'Reportée'
		END

		--SET NouveauStatut à Reportée
		--IF () BEGIN
		--	SET @NouveauStatut = 'Facturée'
		--END

		--SET NouveauStatut à réalisée
		--IF () BEGIN
		--	SET @NouveauStatut = 'Réalisée'
		--END
	END	

	--UPDATE le statut à la fin selon si c'est un update ou un insert
	INSERT INTO RDV.Statuts
	VALUES (GETDATE(), @NouveauStatut, @RDVID)
GO

INSERT INTO RDV.RDVs
VALUES (GETDATE(), NULL, NULL, 'Ceci est le text #1', 'Leduc','Eric', 4501231234, NULL, 'rue', 'ville', 'EricCoolFriend@hotmail.com', 2,0,0,0)

/*
CREATE TRIGGER trg_Forfait
ON RDV.Forfaits
AFTER UPDATE, INSERT
AS
	DECLARE @RDVID INT
--	SELECT @RDVID = RDVID FROM updated
	DECLARE @NouveauStatut NVARCHAR(50)

	IF((SELECT FactureFinal FROM RDV.Forfaits) = 1)BEGIN
		SET @NouveauStatut = 'Facturée'
	END

	INSERT INTO RDV.Statuts
	VALUES (GETDATE(), @NouveauStatut, @RDVID)
GO
*/