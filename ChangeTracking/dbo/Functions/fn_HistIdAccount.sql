/*
Description:
The [fn_HistIdAccount] is used to quickly select records.

Arguments:
	@id_from - From id when the first change was made.
	@id_to - To id when the last change was made
*/

CREATE function [dbo].[fn_HistIdAccount]
	(
		@id_from BIGINT,
		@id_to BIGINT
	)
	
	RETURNS @resultset table (  
		[HAccountId] [bigint],
		[HCreateDate] [datetime2](7),
		[HAction] [char](1),
		[AccountId] [bigint],
		[Name] [varchar](50),
		[Address] [varchar](50),
		[Telephone] char(10)
	) AS
	BEGIN

		DECLARE @startId bigint
		DECLARE @endId bigint

		SET @startId = @id_from
		IF (@startId IS NULL)
			SELECT TOP 1 @startId = [HAccountId] FROM Hist.HAccount (NOLOCK) ORDER BY HCreateDate

		SET @endId = @id_to
		IF (@endId IS NULL)
			SELECT TOP 1 @endId =  [HAccountId] FROM Hist.HAccount (NOLOCK) ORDER BY HCreateDate DESC

        INSERT INTO @resultset
		SELECT     
			[HAccountId],
			[HCreateDate], 
			[HAction], 
			[AccountId], 
			[Name], 
			[Address], 
			[Telephone]
		FROM Hist.HAccount (NOLOCK)
		WHERE
			HAccountId >= @startId
			AND HAccountId <= @endId

		RETURN 
	END

