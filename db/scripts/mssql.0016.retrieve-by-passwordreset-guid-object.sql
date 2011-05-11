IF EXISTS(SELECT * FROM [dbo].[sysobjects]
	WHERE ID = object_id(N'[dbo].[SPUsersGetByPasswordResetGuid]') 
	AND xtype in ('U', 'P', 'IF', 'V'))
	DROP PROCEDURE SPUsersGetByPasswordResetGuid;
GO


CREATE PROCEDURE [dbo].[SPUsersGetByPasswordResetGuid]
	@Provider varchar(32)
	,@PasswordResetGuid varchar(64)
AS
SELECT 
	U.UserId
	,U.UserName
	,U.UserGroupId
	,U.UserGuid
	,U.UserTimeZone
	,U.UserExternalProfileUrl
	,U.UserProviderLastCall
	,U.UserEmail
	,U.UserProviderId
	,U.PasswordResetGuid
	,U.PasswordResetGuidExpireDate
FROM
	Users U
WHERE
	UserProvider = @Provider
	AND
	PasswordResetGuid = @PasswordResetGuid

GO