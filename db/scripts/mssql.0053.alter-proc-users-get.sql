
GO
ALTER PROCEDURE [dbo].[SPUsersGet]
	@UserId int=11
AS
SELECT
	U.UserId
	,U.UserName
	,U.UserProfile
	,U.UserSignature
	,U.UserGroupId
	,U.UserBirthDate
	,U.UserWebsite
	,U.UserTimezone
	,U.UserPhoto
	,U.UserRegistrationDate
	,U.UserExternalProfileUrl
	,U.UserEmail
	,U.UserEmailPolicy
	,UG.UserGroupId
	,UG.UserGroupName
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
	INNER JOIN UsersGroups UG ON UG.UserGroupId = U.UserGroupId
WHERE
	U.UserId = @UserId;
GO