/*
Description:
The [fn_HistAccount] is used to quickly select only those Account records that were modified during the inputted
time period

Arguments:
	@start_time - From when the first change was made.
	@end_time - To when the last change was made
*/

CREATE function [dbo].[fn_HistAccount]
	(	@date_from datetime2,
		@date_to datetime2
	)
	
	returns @resultset table (  
		[HAccountId] [bigint],
		[HCreatedDate] [datetime2](7),
		[HAction] [char](1),
		[AccountId] [bigint],
		[Name] [varchar](50),
		[Address] [varchar](50),
		[Telephone] [char](10)
	) as
	BEGIN

		DECLARE @startHistId BIGINT
		DECLARE @endHistId BIGINT

		SELECT TOP 1 @startHistId = [HAccountId] FROM Hist.HAccount (NOLOCK) WHERE HCreateDate >= @date_from ORDER BY HCreateDate
		IF (@startHistId IS NULL)
			SELECT TOP 1 @startHistId = [HAccountId] FROM Hist.HAccount (NOLOCK) ORDER BY HCreateDate

		SELECT TOP 1 @endHistId = [HAccountId] FROM Hist.HAccount (NOLOCK) WHERE HCreateDate <= @date_to ORDER BY HCreateDate DESC
		IF (@endHistId IS NULL)
			SELECT TOP 1 @endHistId = [HAccountId] FROM Hist.HAccount (NOLOCK) ORDER BY HCreateDate DESC

        INSERT INTO @resultset
		SELECT     
			[HAccountId], 
			[HCreateDate], 
			[HAction], 
			[HAccountId], 
			[Name], 
			[Address], 
			[Telephone]
		FROM Hist.HAccount (NOLOCK)
		WHERE
			[HAccountId] >= @startHistId
			AND [HAccountId] <= @endHistId

		RETURN 
	END
