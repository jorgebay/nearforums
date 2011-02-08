/*CREATE NULLABLE COLUMNS*/
ALTER TABLE Users
	ADD [UserProvider] [varchar](32) NULL;
ALTER TABLE Users
	ADD [UserProviderId] [varchar](64) NULL;
ALTER TABLE Users
	ADD [UserProviderLastCall] [datetime] NULL;
GO

/*FILL ROWS*/
UPDATE U
SET
	[UserProvider] = 'FACEBOOK'
	,[UserProviderId] = UF.FacebookUserId
	,[UserProviderLastCall] = GETUTCDATE()
FROM
	Users U
	INNER JOIN UsersFacebook UF ON UF.UserId = U.UserId

/*SET NOT NULLABLE COLUMNS*/

ALTER TABLE	Users
	ALTER COLUMN [UserProvider] [varchar](32) NOT NULL;
ALTER TABLE	Users
	ALTER COLUMN [UserProviderId] [varchar](64) NOT NULL;
ALTER TABLE	Users
	ALTER COLUMN [UserProviderLastCall] [datetime] NOT NULL;

GO
/*DROP UsersFacebook*/
DROP TABLE UsersFacebook;

GO
/*PROCEDURES*/
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
	,UG.UserGroupId
	,UG.UserGroupName
FROM
	Users U
	INNER JOIN UsersGroups UG ON UG.UserGroupId = U.UserGroupId
WHERE
	U.UserId = @UserId

GO

ALTER PROCEDURE [dbo].[SPUsersGetAll]
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
	,UG.UserGroupId
	,UG.UserGroupName
FROM
	Users U
	INNER JOIN UsersGroups UG ON UG.UserGroupId = U.UserGroupId
WHERE
	U.Active = 1
ORDER BY 
	U.UserName
GO
ALTER PROCEDURE [dbo].[SPUsersGetByName]
	@UserName varchar(50)='Jorge'	
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
	,UG.UserGroupId
	,UG.UserGroupName
FROM
	Users U
	INNER JOIN UsersGroups UG ON UG.UserGroupId = U.UserGroupId
WHERE
	U.UserName LIKE '%' + @UserName +  '%'
	AND
	U.Active = 1
ORDER BY 
	U.UserName


GO
/****** Object:  StoredProcedure [dbo].[SPUsersGetByProvider]    Script Date: 07/20/2010 16:14:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SPUsersGetByProvider]
	@Provider varchar(32)
	,@ProviderId varchar(64)
AS
SELECT 
	U.UserId
	,U.UserName
	,U.UserGroupId
	,U.UserGuid
	,U.UserTimeZone
	,U.UserExternalProfileUrl
	,U.UserProviderLastCall
FROM
	Users U
WHERE
	UserProvider = @Provider
	AND
	UserProviderId = @ProviderId
	AND
	U.Active = 1

GO

ALTER PROCEDURE [dbo].[SPUsersGetTestUser]
	
AS
SELECT 
	Top 1
	U.UserId
	,U.UserName
	,U.UserGroupId
	,U.UserGuid
	,U.UserTimeZone
	,U.UserExternalProfileUrl
	,U.UserProviderLastCall
FROM
	Users U
WHERE
	U.Active = 1
ORDER BY
	U.UserGroupId DESC

GO

CREATE PROCEDURE [dbo].[SPUsersInsertFromProvider]
	(@UserName varchar(50)
	,@UserProfile varchar(max)
	,@UserSignature varchar(max)
	,@UserGroupId smallint
	,@UserBirthDate datetime
	,@UserWebsite varchar(255)
	,@UserGuid char(32)
	,@UserTimezone decimal(9,2)
	,@UserEmail varchar(100)
	,@UserEmailPolicy int
	,@UserPhoto varchar(1024)
	,@UserExternalProfileUrl varchar(255)
	,@UserProvider varchar(32)
	,@UserProviderId varchar(64))
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
SELECT 	
	U.UserId
	,U.UserName
	,U.UserGroupId
	,U.UserGuid
	,U.UserTimeZone
	,U.UserExternalProfileUrl
	,U.UserProviderLastCall
FROM
	Users U
WHERE
	U.UserId = @UserId;

GO
DROP PROCEDURE SPUsersGetByFacebookId		
GO
DROP PROCEDURE SPUsersInsertFromFacebook

