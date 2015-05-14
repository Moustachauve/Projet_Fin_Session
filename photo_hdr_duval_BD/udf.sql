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
	
	SELECT @RDVID = RDVID FROM inserted
	SELECT @DateRdvUpdate = DateRDV	FROM deleted

	--SET NouveauStatut � DEMAND�E
	IF((SELECT COUNT(RDVID) FROM RDV.Statuts WHERE RDVID = @RDVID) = 0) BEGIN --Si le nombre total de statuts de RDVID est �gal a 0, ...
		SET @NouveauStatut = 'Demand�e'
	END

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

	--SET NouveauStatut � Livr�
	IF ((SELECT DateLivraison FROM RDV.RDVs WHERE RDVID = @RDVID) IS NOT NULL) BEGIN
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

CREATE TRIGGER RDV.trg_GererPhotos
ON [RDV].[PhotoProprietes]
AFTER UPDATE, INSERT
AS
	DECLARE @RDVID INT
	DECLARE @NouveauStatut NVARCHAR(50)
	
	SELECT @RDVID = RDVID FROM inserted

	--SET NouveauStatut � r�alis�e
	IF ((SELECT COUNT(Url) FROM RDV.PhotoProprietes WHERE RDVID = @RDVID) != 0) BEGIN
		SET @NouveauStatut = 'R�alis�e'
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
/* Quand prix change(update prix)/cr�er rdv, va falloir additionne prix forfait + frais d�placement + visite virtuel

prix = cout total avant taxe

prix calcul apr�s taxes

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


SELECT RDVID, NomProprietaire + ', '+ PrenomProprietaire AS 'Nom, Pr�nom', RDV.udf_CoutTotalAvantTaxes(RDVID) AS 'Cout Avant Taxes', RDV.udf_CoutTotalApresTaxes(RDVID) AS 'Cout Apr�s Taxes', Deplacement, VisiteVirtuelle FROM RDV.RDVs