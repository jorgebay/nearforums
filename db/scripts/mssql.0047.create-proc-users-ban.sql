IF EXISTS(SELECT * FROM [dbo].[sysobjects]
	WHERE ID = object_id(N'[dbo].[SPUsersBan]') 
	AND xtype in ('U', 'P', 'IF', 'V'))
	DROP PROCEDURE SPUsersBan;
GO

CREATE PROCEDURE dbo.SPUsersBan
(
	@UserId int
	, @ModeratorUserId int
	, @ModeratorReason int
	, @ModeratorReasonFull nvarchar(max)
)
AS

UPDATE Users
SET
	BannedStart = GETUTCDATE()
	, ModeratorReason = @ModeratorReason
	, ModeratorReasonFull = @ModeratorReasonFull
	, ModeratorUserId = @ModeratorUserId
WHERE 
	UserId = @UserId