CREATE TABLE [dbo].[Account] (
    [AccountId] BIGINT       IDENTITY (1, 1) NOT NULL,
    [Name]      VARCHAR (50) NOT NULL,
    [Address]   VARCHAR (50) NOT NULL,
    [Telephone] NCHAR (10)   NOT NULL,
    CONSTRAINT [PK_Account] PRIMARY KEY CLUSTERED ([AccountId] ASC)
);


GO

CREATE TRIGGER [dbo].[Account_Trg_Delete]
ON [dbo].[Account]
AFTER Delete AS

SET NOCOUNT ON;

INSERT INTO Hist.HAccount (HAction, AccountId, Name, Address, Telephone)
SELECT 
	CASE 
        WHEN EXISTS(SELECT * FROM DELETED)
        THEN 'D'  -- Set Action to Deleted.
        ELSE NULL -- Skip. It may have been a "failed delete".   
    END Action,
	AccountId, Name, Address, Telephone
FROM deleted



GO

CREATE TRIGGER [dbo].[Account_Trg_Update]
ON [dbo].[Account]
AFTER INSERT, UPDATE AS

SET NOCOUNT ON;

INSERT INTO Hist.HAccount (HAction, AccountId, Name, Address, Telephone)
SELECT 
	CASE WHEN EXISTS(SELECT * FROM INSERTED)
            AND EXISTS(SELECT * FROM DELETED)
        THEN 'U'  -- Set Action to Updated.
        WHEN EXISTS(SELECT * FROM INSERTED)
        THEN 'I'  -- Set Action to Insert.
        WHEN EXISTS(SELECT * FROM DELETED)
        THEN 'D'  -- Set Action to Deleted.
        ELSE NULL -- Skip. It may have been a "failed delete".   
    END Action,
	AccountId, Name,  Address, Telephone
FROM inserted


