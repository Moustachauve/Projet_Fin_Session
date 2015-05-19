USE [H15_PROJET_E05]
GO

--Agent
----------------------------------------------------------------------
CREATE TABLE Agent.Agent(
	AgentID INT NOT NULL IDENTITY,
	NomAgent NVARCHAR(50) NOT NULL,
	PrenomAgent NVARCHAR(50) NOT NULL,
	NomEntreprise NVARCHAR(50) NOT NULL,
	Adresse NVARCHAR(50) NOT NULL,
	CodePostal NVARCHAR(7) NOT NULL,
	TelPrincipal BIGINT NOT NULL,
	TelSecondaire BIGINT NOT NULL

	PRIMARY KEY (AgentID)
) ON [PRIMARY];
GO