
ALTER PROCEDURE [dbo].[SPUsersGetByPasswordResetGuid]
	@Provider nvarchar(32)
	,@PasswordResetGuid nvarchar(64)
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
	,U.UserProfile
	,U.UserSignature
	,U.WarningStart
	,U.WarningRead
	,U.SuspendedStart
	,U.SuspendedEnd
	,U.BannedStart
	,U.ModeratorReasonFull
	,U.ModeratorReason
	,U.ModeratorUserId
FROM
	Users U
WHERE
	UserProvider = @Provider
	AND
	PasswordResetGuid = @PasswordResetGuid
GO