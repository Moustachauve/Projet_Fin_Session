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
	
	SELECT @RDVID = RDVID FROM inserted
	SELECT @DateRdvUpdate = DateRDV	FROM deleted

	--SET NouveauStatut à DEMANDÉE
	IF((SELECT COUNT(RDVID) FROM RDV.Statuts WHERE RDVID = @RDVID) = 0) BEGIN --Si le nombre total de statuts de RDVID est égal a 0, ...
		SET @NouveauStatut = 'Demandée'
	END

	--SET NouveauStatut à CONFIRMÉE
	IF ((SELECT TOP 1 DateRDV FROM RDV.RDVS WHERE RDVID = @RDVID) IS NOT NULL) BEGIN --Si la date du RDV
		SET @NouveauStatut = 'Confirmée'
	END

	IF(UPDATE(DateRDV)) BEGIN
		--SET NouveauStatut à Reportée
		IF((SELECT TOP 1 DateRDV FROM RDV.RDVS WHERE RDVID = @RDVID) != @DateRdvUpdate) BEGIN
			SET @NouveauStatut = 'Reportée'
		END
	END

	--SET NouveauStatut à Livré
	IF ((SELECT DateLivraison FROM RDV.RDVs WHERE RDVID = @RDVID) IS NOT NULL) BEGIN
		SET @NouveauStatut = 'Livré'
	END
	
	--SET NouveauStatut à Facturée
	IF((SELECT DateFacturation FROM RDV.RDVs WHERE RDVID = @RDVID) IS NOT NULL) BEGIN
		SET @NouveauStatut = 'Facturée'
	END


	--UPDATE le statut à la fin selon si c'est un update ou un insert
	INSERT INTO RDV.Statuts
	VALUES (GETDATE(), @NouveauStatut, @RDVID)
GO

CREATE TRIGGER RDV.trg_GererPhotos
ON [RDV].[PhotoProprietes]
AFTER UPDATE, INSERT
AS
	DECLARE @RDVID INT
	DECLARE @NouveauStatut NVARCHAR(50)
	
	SELECT @RDVID = RDVID FROM inserted

	--SET NouveauStatut à réalisée
	IF ((SELECT COUNT(Url) FROM RDV.PhotoProprietes WHERE RDVID = @RDVID) != 0) BEGIN
		SET @NouveauStatut = 'Réalisée'
	END

	INSERT INTO RDV.Statuts
	VALUES (GETDATE(), @NouveauStatut, @RDVID)
GO

/*
--TESTS STATUTS
UPDATE RDV.RDVS
SET DateRDV = '2015-07-07'
WHERE RDVID = 2
GO

UPDATE RDV.RDVs
SET DateFacturation = '2015-05-15'
WHERE RDVID = 1
GO

UPDATE RDV.RDVs
SET DateLivraison = '2015-08-12'
WHERE RDVID = 3
GO

INSERT INTO [RDV].[PhotoProprietes]
VALUES('testtt2', 'photo 2', 2)
*/





--UDF
/* Quand prix change(update prix)/créer rdv, va falloir additionne prix forfait + frais déplacement + visite virtuel

prix = cout total avant taxe

prix calcul après taxes

taxe = prix * 1.15
*/

CREATE FUNCTION RDV.udf_CoutTotalAvantTaxes (
	@RDVID AS INT
)
RETURNS MONEY
AS 
BEGIN
	DECLARE @ForfaitIDselonRDVID INT
	DECLARE @prixBaseForfait MONEY
	DECLARE @CoutDeplacement MONEY
	DECLARE @CoutVisiteVirtuelle MONEY
	DECLARE @CoutTotalAvantTaxes MONEY

	--SET ForfaitID SELON LE RDVID (PLUS SIMPLE QU'UN INNER JOIN ET ON A BESOIN DE SE SELECT), LE COUT DE DEPLACEMENT ET LE COUT DE LA VISITE VIRTUELLE
	SELECT	@ForfaitIDselonRDVID = ForfaitID,
			@CoutDeplacement = Deplacement,
			@CoutVisiteVirtuelle = VisiteVirtuelle
	FROM RDV.RDVs
	WHERE RDVID = @RDVID
	
	--SET LE PRIX
	SELECT @prixBaseForfait = Prix
	FROM RDV.Forfaits
	WHERE ForfaitID = @ForfaitIDselonRDVID
	
	--CALCULE LE @CoutTotalAvantTaxes
	SET @CoutTotalAvantTaxes = (@prixBaseForfait + @CoutDeplacement + @CoutVisiteVirtuelle)

	RETURN @CoutTotalAvantTaxes
END


GO
CREATE FUNCTION RDV.udf_CoutTotalApresTaxes (
	@RDVID AS INT
)
RETURNS MONEY
AS 
BEGIN
	DECLARE @CoutFinalAvecTaxes MONEY
	DECLARE @CoutTotalAvantTaxes MONEY
	DECLARE @PrixTPS MONEY
	DECLARE @PrixTVQ MONEY

	SET @CoutTotalAvantTaxes = RDV.udf_CoutTotalAvantTaxes(@RDVID)
	
	--CALCULE LES PRIX SELON LA TPS ET LA TVQ
	SELECT @PrixTPS = ROUND((@CoutTotalAvantTaxes*(Pourcentage/100)), 2,1) FROM [Paiement].[Taxes] WHERE Nom = 'TPS'
	SELECT @PrixTVQ = ROUND((@CoutTotalAvantTaxes*(Pourcentage/100)), 2,1) FROM Paiement.Taxes WHERE Nom = 'TVQ'

	SET @CoutFinalAvecTaxes = @CoutTotalAvantTaxes + @PrixTPS + @PrixTVQ

	RETURN @CoutFinalAvecTaxes
END
GO


SELECT RDVID, NomProprietaire + ', '+ PrenomProprietaire AS 'Nom, Prénom', RDV.udf_CoutTotalAvantTaxes(RDVID) AS 'Cout Avant Taxes', RDV.udf_CoutTotalApresTaxes(RDVID) AS 'Cout Après Taxes', Deplacement, VisiteVirtuelle FROM RDV.RDVs