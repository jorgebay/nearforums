IF EXISTS(SELECT * FROM [dbo].[sysobjects]
	WHERE ID = object_id(N'[dbo].[SPUsersWarn]') 
	AND xtype in ('U', 'P', 'IF', 'V'))
	DROP PROCEDURE SPUsersWarn;
GO

CREATE PROCEDURE dbo.SPUsersWarn
(
	@UserId int
	, @ModeratorUserId int
	, @ModeratorReason int
	, @ModeratorReasonFull nvarchar(max)
)
AS

UPDATE Users
SET
	WarningStart = GETUTCDATE()
	, WarningRead = 0
	, ModeratorReason = @ModeratorReason
	, ModeratorReasonFull = @ModeratorReasonFull
	, ModeratorUserId = @ModeratorUserId
WHERE 
	UserId = @UserId