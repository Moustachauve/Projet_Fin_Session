USE [H15_PROJET_E05]
GO

--ID	Description
--1		Demand�e
--2		Confirm�e
--3		Report�e
--4		R�alis�e
--5		Livr�e
--6		Factur�e

--UDF
IF OBJECT_ID ('RDV.udf_CoutTotalAvantTaxes') IS NOT NULL DROP FUNCTION RDV.udf_CoutTotalAvantTaxes
GO
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

IF OBJECT_ID ('RDV.udf_CoutTotalApresTaxes') IS NOT NULL DROP FUNCTION RDV.udf_CoutTotalApresTaxes
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

	--SET @CoutTotalAvantTaxes = RDV.udf_CoutTotalAvantTaxes(@RDVID)
	SELECT @CoutTotalAvantTaxes = CoutTotalAvantTaxes FROM RDV.RDVs WHERE RDVID = @RDVID

	--CALCULE LES PRIX SELON LA TPS ET LA TVQ
	SELECT @PrixTPS = ROUND((@CoutTotalAvantTaxes*(Pourcentage/100)), 2,1) FROM [Paiement].[Taxes] WHERE Nom = 'TPS'
	SELECT @PrixTVQ = ROUND((@CoutTotalAvantTaxes*(Pourcentage/100)), 2,1) FROM Paiement.Taxes WHERE Nom = 'TVQ'

	SET @CoutFinalAvecTaxes = @CoutTotalAvantTaxes + @PrixTPS + @PrixTVQ

	RETURN  @CoutFinalAvecTaxes
END
GO



IF OBJECT_ID ('RDV.trg_GererStatutETTaxes') IS NOT NULL DROP TRIGGER RDV.trg_GererStatutETTaxes
GO
CREATE TRIGGER RDV.trg_GererStatutETTaxes
ON RDV.RDVs
AFTER INSERT, UPDATE
AS
	
	DECLARE @RDVID INT
	DECLARE @NouveauStatut NVARCHAR(50) = 'Demand�e'
	DECLARE @DateRdvUpdate DATE
	
	DECLARE @importance INT = 1

	SELECT @RDVID = RDVID FROM inserted
	SELECT @DateRdvUpdate = DateRDV	FROM deleted
	--SET NouveauStatut � DEMAND�E
	IF((SELECT COUNT(RDVID) FROM RDV.Statuts WHERE RDVID = @RDVID) = 0) BEGIN --Si le nombre total de statuts de RDVID est �gal a 0, ...
		SET @NouveauStatut = 'Demand�e'
		SET @importance = 1
	END

	--SET NouveauStatut � CONFIRM�E
	IF ((SELECT TOP 1 DateRDV FROM RDV.RDVs WHERE RDVID = @RDVID) IS NOT NULL) BEGIN --Si la date du RDV
		SET @NouveauStatut = 'Confirm�e'
		SET @importance = 2
	END

	IF(UPDATE(DateRDV)) BEGIN
		--SET NouveauStatut � Report�e
		IF((SELECT TOP 1 DateRDV FROM RDV.RDVs WHERE RDVID = @RDVID) != @DateRdvUpdate) BEGIN
			SET @NouveauStatut = 'Report�e'
			SET @importance = 3
		END
	END

	--SET NouveauStatut � Livr�
	IF ((SELECT DateLivraison FROM RDV.RDVs WHERE RDVID = @RDVID) IS NOT NULL) BEGIN
		SET @NouveauStatut = 'Livr�e'
		SET @importance = 5
	END


	--SET NouveauStatut � Factur�e
	IF((SELECT DateFacturation FROM RDV.RDVs WHERE RDVID = @RDVID) IS NOT NULL) BEGIN
		SET @NouveauStatut = 'Factur�e'
		SET @importance = 6
	END 

	INSERT INTO RDV.Statuts
	VALUES (GETDATE(), @NouveauStatut, @RDVID, @importance)
	
		DECLARE @IDaChanger INT
	SELECT @IDaChanger = RDVID FROM inserted
	
	DECLARE @TotalAvantTaxes MONEY
	SET @TotalAvantTaxes = RDV.udf_CoutTotalAvantTaxes (@IDaChanger)

	UPDATE RDV.RDVs
	SET [CoutTotalAvantTaxes] = @TotalAvantTaxes
	WHERE RDVID = @IDaChanger

	DECLARE @TotalApresTaxes MONEY
	SET @TotalApresTaxes = RDV.udf_CoutTotalApresTaxes(@IDaChanger)

	UPDATE RDV.RDVs
	SET [CoutTotalApresTaxes] = @TotalApresTaxes
	WHERE RDVID = @IDaChanger

GO



/*
IF OBJECT_ID ('RDV.trg_GererTaxes') IS NOT NULL DROP TRIGGER RDV.trg_GererTaxes
GO
CREATE TRIGGER RDV.trg_GererTaxes
ON RDV.Statuts
AFTER INSERT
AS
	DECLARE @IDaChanger INT
	SELECT @IDaChanger = RDVID FROM inserted
	
	DECLARE @TotalAvantTaxes MONEY
	SET @TotalAvantTaxes = RDV.udf_CoutTotalAvantTaxes (@IDaChanger)

	UPDATE RDV.RDVs
	SET [CoutTotalAvantTaxes] = @TotalAvantTaxes
	WHERE RDVID = @IDaChanger

	DECLARE @TotalApresTaxes MONEY
	SET @TotalApresTaxes = RDV.udf_CoutTotalApresTaxes(@IDaChanger)

	UPDATE RDV.RDVs
	SET [CoutTotalApresTaxes] = @TotalApresTaxes
	WHERE RDVID = @IDaChanger
GO
*/







IF OBJECT_ID ('RDV.trg_GererStatutPhotos') IS NOT NULL DROP TRIGGER RDV.trg_GererStatutPhotos
GO
CREATE TRIGGER RDV.trg_GererStatutPhotos
ON [RDV].[PhotoProprietes]
AFTER UPDATE, INSERT
AS
	DECLARE @RDVID INT
	DECLARE @NouveauStatut NVARCHAR(50)
	DECLARE @importance INT

	SELECT @RDVID = RDVID FROM inserted

	--SET NouveauStatut � r�alis�e
	IF ((SELECT COUNT(Url) FROM RDV.PhotoProprietes WHERE RDVID = @RDVID) != 0) BEGIN
		SET @NouveauStatut = 'R�alis�e'
		SET @importance = 4
	END

	INSERT INTO RDV.Statuts
	VALUES (GETDATE(), @NouveauStatut, @RDVID, @importance)
GO

/*IF OBJECT_ID ('RDV.CalculCoutTotalAvantApresTaxes') IS NOT NULL DROP TRIGGER RDV.CalculCoutTotalAvantApresTaxes
GO
CREATE TRIGGER RDV.CalculCoutTotalAvantApresTaxes
ON RDV.RDVs
AFTER INSERT
AS
	
	DECLARE @IDaChanger INT
	SELECT @IDaChanger = RDVID FROM inserted
	
	DECLARE @TotalAvantTaxes MONEY
	SET @TotalAvantTaxes = RDV.udf_CoutTotalAvantTaxes (@IDaChanger)

	UPDATE RDV.RDVs
	SET [CoutTotalAvantTaxes] = @TotalAvantTaxes
	WHERE RDVID = @IDaChanger

	DECLARE @TotalApresTaxes MONEY
	SET @TotalApresTaxes = RDV.udf_CoutTotalApresTaxes(@IDaChanger)

	UPDATE RDV.RDVs
	SET [CoutTotalApresTaxes] = @TotalApresTaxes
	WHERE RDVID = @IDaChanger

GO*/

--SELECT RDVID, NomProprietaire + ', '+ PrenomProprietaire AS 'Nom, Pr�nom', RDV.udf_CoutTotalAvantTaxes(RDVID) AS 'Cout Avant Taxes', RDV.udf_CoutTotalApresTaxes(RDVID) AS 'Cout Apr�s Taxes', Deplacement, VisiteVirtuelle FROM RDV.RDVs
GO

IF OBJECT_ID ('Agent.RapportMensuel') IS NOT NULL DROP PROCEDURE Agent.RapportMensuel
GO
CREATE PROCEDURE Agent.RapportMensuel
@mois int,
@ann�e int
AS
BEGIN
	select r.DateDemande, a.NomAgent + ', ' + a.PrenomAgent AS 'Nom, Pr�nom', a.NomEntreprise, r.CoutTotalAvantTaxes, r.Deplacement, r.VisiteVirtuelle , r.CoutTotalApresTaxes
	from RDV.RDVs r INNER JOIN [Agent].[Agents] a ON  a.AgentID = r.AgentID
	WHERE	YEAR(r.DateFacturation) = @ann�e AND
			MONTH(r.DateFacturation) = @mois
	ORDER BY a.NomAgent, a.PrenomAgent
END

--EXEC Agent.RapportMensuel @mois = 05, @ann�e = 2015