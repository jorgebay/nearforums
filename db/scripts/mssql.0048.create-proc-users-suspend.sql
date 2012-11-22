IF EXISTS(SELECT * FROM [dbo].[sysobjects]
	WHERE ID = object_id(N'[dbo].[SPUsersSuspend]') 
	AND xtype in ('U', 'P', 'IF', 'V'))
	DROP PROCEDURE SPUsersSuspend;
GO

CREATE PROCEDURE dbo.SPUsersSuspend
(
	@UserId int
	, @ModeratorUserId int
	, @ModeratorReason int
	, @ModeratorReasonFull nvarchar(max)
	, @SuspendedEnd datetime
)
AS

UPDATE Users
SET
	SuspendedStart = GETUTCDATE()
	, SuspendedEnd = @SuspendedEnd
	, ModeratorReason = @ModeratorReason
	, ModeratorReasonFull = @ModeratorReasonFull
	, ModeratorUserId = @ModeratorUserId
WHERE 
	UserId = @UserId