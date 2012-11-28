IF EXISTS(SELECT * FROM [dbo].[sysobjects]
	WHERE ID = object_id(N'[dbo].[SPUsersWarnDismiss]') 
	AND xtype in ('P'))
	DROP PROCEDURE SPUsersWarnDismiss;
GO

CREATE PROCEDURE dbo.SPUsersWarnDismiss
(
	@UserId int
)
AS

UPDATE Users
SET
	WarningRead = 1
WHERE 
	UserId = @UserId