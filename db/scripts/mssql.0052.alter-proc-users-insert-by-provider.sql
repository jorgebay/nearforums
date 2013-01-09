
ALTER PROCEDURE [dbo].[SPUsersInsertFromProvider]
	(@UserName nvarchar(50)
	,@UserProfile nvarchar(max)
	,@UserSignature nvarchar(max)
	,@UserGroupId smallint
	,@UserBirthDate datetime
	,@UserWebsite nvarchar(255)
	,@UserGuid char(32)
	,@UserTimezone decimal(9,2)
	,@UserEmail nvarchar(100)
	,@UserEmailPolicy int
	,@UserPhoto nvarchar(1024)
	,@UserExternalProfileUrl nvarchar(255)
	,@UserProvider nvarchar(32)
	,@UserProviderId nvarchar(64))
AS

--If it is the first active user -> make it an admin
DECLARE @UserCount int
SELECT @UserCount=COUNT(UserId) FROM Users WHERE Active = 1
IF ISNULL(@UserCount, 0) = 0
	SELECT @UserGroupId = MAX(UserGroupId) FROM UsersGroups


INSERT INTO Users
   (UserName
   ,UserProfile
   ,UserSignature
   ,UserGroupId
   ,Active
   ,UserBirthDate
   ,UserWebsite
   ,UserGuid
   ,UserTimezone
   ,UserEmail
   ,UserEmailPolicy
   ,UserPhoto
   ,UserRegistrationDate
   ,UserExternalProfileUrl
   ,UserProvider
   ,UserProviderId
   ,UserProviderLastCall)
VALUES
	(@UserName
   ,@UserProfile
   ,@UserSignature
   ,@UserGroupId
   ,1 --Active
   ,@UserBirthDate
   ,@UserWebsite
   ,@UserGuid
   ,@UserTimezone
   ,@UserEmail
   ,@UserEmailPolicy
   ,@UserPhoto
   ,GETUTCDATE() --RegitrationDate
   ,@UserExternalProfileUrl
   ,@UserProvider
   ,@UserProviderId
   ,GETUTCDATE() --UserProviderLastCall
	);

DECLARE @UserId int;
SELECT @UserId = @@IDENTITY;
EXEC dbo.SPUsersGetByProvider @UserProvider, @UserProviderId;

GO