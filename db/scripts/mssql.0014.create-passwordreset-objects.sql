IF EXISTS(SELECT * FROM [dbo].[sysobjects]
	WHERE ID = object_id(N'[dbo].[SPUsersUpdatePasswordResetGuid]') 
	AND xtype in ('U', 'P', 'IF', 'V'))
	DROP PROCEDURE SPUsersUpdatePasswordResetGuid;
GO


CREATE PROCEDURE [dbo].[SPUsersUpdatePasswordResetGuid]
	@UserId int
	,@PasswordResetGuid varchar(100)
	,@PasswordResetGuidExpireDate datetime
AS
UPDATE Users
SET
	PasswordResetGuid = @PasswordResetGuid
	,PasswordResetGuidExpireDate = @PasswordResetGuidExpireDate
WHERE
	UserId = @UserId

GO