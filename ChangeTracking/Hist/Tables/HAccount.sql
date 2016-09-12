CREATE TABLE [Hist].[HAccount] (
    [HAccountId]  BIGINT         IDENTITY (1, 1) NOT NULL,
    [HCreateDate] DATETIME2 (7)  CONSTRAINT [DF_HAccount_HCreateDate] DEFAULT (getdate()) NOT NULL,
    [HAction]     CHAR (1)       NOT NULL,
    [AccountId]   BIGINT         NOT NULL,
    [Name]        VARCHAR (50)   NOT NULL,
    [Address]     NVARCHAR (100) NOT NULL,
    [Telephone]   NCHAR (10)     NOT NULL,
    CONSTRAINT [PK_Hist.HAccount] PRIMARY KEY CLUSTERED ([HAccountId] ASC)
);

