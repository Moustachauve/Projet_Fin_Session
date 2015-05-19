USE [H15_PROJET_E05]
GO

--Emails
---------------------------------------------------------------
CREATE TABLE Agent.Emails(
	EmailID int NOT NULL IDENTITY,
	Email NVARCHAR(50) NOT NULL,
	AgentID INT NOT NULL,
	IsPrimary Bit NOT NULL DEFAULT 0

	PRIMARY KEY (EmailID)
) ON [PRIMARY]
GO

ALTER TABLE Agent.Emails
	ADD CONSTRAINT FK_Agent_Emails_EmailID
	FOREIGN KEY (AgentID)
	REFERENCES Agent.Agent