﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE Procedure [dbo].[FetchEvents]
	-- Add the parameters for the stored procedure here
	@SubscriptionId bigint,
	@SuggestedCount int,
	@CurrentTime datetime2(4)
AS
BEGIN
	Declare @CurrentBookmark datetime2(4);
	Declare @NextBookmark datetime2(4);
	Declare @Context nvarchar(50);
	Declare @Filter nvarchar(200);
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	Select @CurrentBookmark=CurrentBookmark, @NextBookmark=NextBookmark
	FROM Subscriptions
	Where @SubscriptionId = SubscriptionId

	if @CurrentBookmark = @NextBookmark
	begin 
		With 
			cte AS (
				SELECT TOP (@SuggestedCount) ew.TimeStamp, s.Context, s.Filter
				FROM EventWrappers ew inner join Subscriptions s
				on ew.ContextName = s.Context
				where s.SubscriptionId = @SubscriptionId
				AND
				ew.TimeStamp >= s.CurrentBookmark
				AND
				(s.Filter = '*' OR ew.StreamId like s.Filter + '%')
				Order By ew.TimeStamp
			)
		SELECT @NextBookmark=Max(Timestamp), @Context=Context, @Filter=Filter from cte
		Group By Context, Filter		
		
		Update Subscriptions SET NextBookmark = @NextBookmark, 
			LastActive = @CurrentTime
		WHERE SubscriptionId = @SubscriptionId
	end
	else
	begin
		Update Subscriptions SET LastActive = @CurrentTime,
		@Context = Context, 
		@Filter = Filter
		WHERE SubscriptionId = @SubscriptionId
	end
	
	SELECT * from EventWrappers WHERE
		ContextName = @Context AND
		(@Filter = '*' OR StreamId like @Filter + '%') AND
		TimeStamp BETWEEN @CurrentBookmark AND @NextBookmark
		order by TimeStamp,Sequence;

	if @Context is not null
	begin
		Select @Context as 'Context'
	end
	else
	begin
		Select top (1) Context from Subscriptions
			WHERE SubscriptionId = @SubscriptionId
	end

END


GO