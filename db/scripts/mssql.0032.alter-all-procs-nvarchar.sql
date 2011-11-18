/****** Object:  StoredProcedure [dbo].[SPMessagesFlag]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPMessagesFlag]
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesFlagsClear]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPMessagesFlagsClear]
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesFlagsGetAll]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPMessagesFlagsGetAll]
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesGetByTopic]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPMessagesGetByTopic]
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesGetByTopicFrom]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPMessagesGetByTopicFrom]
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesGetByTopicLatest]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPMessagesGetByTopicLatest]
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesGetByTopicUpTo]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPMessagesGetByTopicUpTo]
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsUpdate]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTopicsUpdate]
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsInsert]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTopicsInsert]
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsMove]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTopicsMove]
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsDelete]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTopicsDelete]
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGet]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTopicsGet]
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByForum]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTopicsGetByForum]
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByForumLatest]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTopicsGetByForumLatest]
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByForumUnanswered]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTopicsGetByForumUnanswered]
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByRelated]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTopicsGetByRelated]
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByTag]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTopicsGetByTag]
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByUser]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTopicsGetByUser]
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetLatest]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTopicsGetLatest]
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetMessagesByUser]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTopicsGetMessagesByUser]
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetUnanswered]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTopicsGetUnanswered]
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsSubscriptionsDelete]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTopicsSubscriptionsDelete]
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsSubscriptionsGetByTopic]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTopicsSubscriptionsGetByTopic]
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsSubscriptionsGetByUser]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTopicsSubscriptionsGetByUser]
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsSubscriptionsInsert]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTopicsSubscriptionsInsert]
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesInsert]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPMessagesInsert]
GO
/****** Object:  StoredProcedure [dbo].[SPTagsGetMostViewed]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTagsGetMostViewed]
GO
/****** Object:  StoredProcedure [dbo].[SPTagsInsert]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTagsInsert]
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesDelete]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPMessagesDelete]
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsAddVisit]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTopicsAddVisit]
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsClose]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTopicsClose]
GO
/****** Object:  StoredProcedure [dbo].[SPForumsUpdateLastMessage]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPForumsUpdateLastMessage]
GO
/****** Object:  StoredProcedure [dbo].[SPForumsUpdateRecount]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPForumsUpdateRecount]
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsUpdateLastMessage]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTopicsUpdateLastMessage]
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsOpen]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTopicsOpen]
GO
/****** Object:  StoredProcedure [dbo].[SPForumsDelete]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPForumsDelete]
GO
/****** Object:  StoredProcedure [dbo].[SPForumsGetByCategory]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPForumsGetByCategory]
GO
/****** Object:  StoredProcedure [dbo].[SPForumsGetByShortName]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPForumsGetByShortName]
GO
/****** Object:  StoredProcedure [dbo].[SPForumsGetUsedShortNames]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPForumsGetUsedShortNames]
GO
/****** Object:  StoredProcedure [dbo].[SPForumsInsert]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPForumsInsert]
GO
/****** Object:  StoredProcedure [dbo].[SPForumsUpdate]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPForumsUpdate]
GO
/****** Object:  StoredProcedure [dbo].[SPUsersDelete]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPUsersDelete]
GO
/****** Object:  StoredProcedure [dbo].[SPUsersDemote]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPUsersDemote]
GO
/****** Object:  StoredProcedure [dbo].[SPUsersGet]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPUsersGet]
GO
/****** Object:  StoredProcedure [dbo].[SPUsersGetAll]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPUsersGetAll]
GO
/****** Object:  StoredProcedure [dbo].[SPUsersGetByName]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPUsersGetByName]
GO
/****** Object:  StoredProcedure [dbo].[SPUsersGetByPasswordResetGuid]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPUsersGetByPasswordResetGuid]
GO
/****** Object:  StoredProcedure [dbo].[SPUsersGetByProvider]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPUsersGetByProvider]
GO
/****** Object:  StoredProcedure [dbo].[SPUsersGetTestUser]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPUsersGetTestUser]
GO
/****** Object:  StoredProcedure [dbo].[SPUsersInsertFromProvider]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPUsersInsertFromProvider]
GO
/****** Object:  StoredProcedure [dbo].[SPUsersPromote]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPUsersPromote]
GO
/****** Object:  StoredProcedure [dbo].[SPUsersUpdate]    Script Date: 11/18/2011 11:34:46 ******/
DROP PROCEDURE [dbo].[SPUsersUpdate]
GO
/****** Object:  StoredProcedure [dbo].[SPUsersUpdateEmail]    Script Date: 11/18/2011 11:34:46 ******/
DROP PROCEDURE [dbo].[SPUsersUpdateEmail]
GO
/****** Object:  StoredProcedure [dbo].[SPUsersUpdatePasswordResetGuid]    Script Date: 11/18/2011 11:34:46 ******/
DROP PROCEDURE [dbo].[SPUsersUpdatePasswordResetGuid]
GO
/****** Object:  StoredProcedure [dbo].[SPUsersGroupsGet]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPUsersGroupsGet]
GO
/****** Object:  StoredProcedure [dbo].[SPForumsCategoriesGetAll]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPForumsCategoriesGetAll]
GO
/****** Object:  StoredProcedure [dbo].[SPTemplatesDelete]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTemplatesDelete]
GO
/****** Object:  StoredProcedure [dbo].[SPTemplatesGet]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTemplatesGet]
GO
/****** Object:  StoredProcedure [dbo].[SPTemplatesGetAll]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTemplatesGetAll]
GO
/****** Object:  StoredProcedure [dbo].[SPTemplatesGetCurrent]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTemplatesGetCurrent]
GO
/****** Object:  StoredProcedure [dbo].[SPTemplatesInsert]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTemplatesInsert]
GO
/****** Object:  StoredProcedure [dbo].[SPTemplatesUpdateCurrent]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPTemplatesUpdateCurrent]
GO
/****** Object:  StoredProcedure [dbo].[SPPageContentsDelete]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPPageContentsDelete]
GO
/****** Object:  StoredProcedure [dbo].[SPPageContentsGet]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPPageContentsGet]
GO
/****** Object:  StoredProcedure [dbo].[SPPageContentsGetAll]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPPageContentsGetAll]
GO
/****** Object:  StoredProcedure [dbo].[SPPageContentsGetUsedShortNames]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPPageContentsGetUsedShortNames]
GO
/****** Object:  StoredProcedure [dbo].[SPPageContentsInsert]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPPageContentsInsert]
GO
/****** Object:  StoredProcedure [dbo].[SPPageContentsUpdate]    Script Date: 11/18/2011 11:34:45 ******/
DROP PROCEDURE [dbo].[SPPageContentsUpdate]
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 11/18/2011 11:34:47 ******/
DROP FUNCTION [dbo].[Split]
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 11/18/2011 11:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Split] (@s nvarchar(512), @sep char(1))
RETURNS table
AS
RETURN (
    WITH Pieces(pn, start, stop) AS (
      SELECT 1, 1, CHARINDEX(@sep, @s)
      UNION ALL
      SELECT pn + 1, stop + 1, CHARINDEX(@sep, @s, stop + 1)
      FROM Pieces
      WHERE stop > 0
    )
    SELECT pn AS position,
      SUBSTRING(@s, start, CASE WHEN stop > 0 THEN stop-start ELSE 512 END) AS part
    FROM Pieces
  )
GO
/****** Object:  StoredProcedure [dbo].[SPPageContentsUpdate]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPPageContentsUpdate]
	@PageContentShortName nvarchar(128)
	,@PageContentTitle nvarchar(128)
	,@PageContentBody nvarchar(max)
AS
UPDATE PageContents 
SET
	PageContentTitle = @PageContentTitle
	,PageContentBody = @PageContentBody
	,PageContentEditDate = GETUTCDATE()
WHERE
	PageContentShortName = @PageContentShortName
GO
/****** Object:  StoredProcedure [dbo].[SPPageContentsInsert]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPPageContentsInsert]
	@PageContentShortName nvarchar(128)
	,@PageContentTitle nvarchar(128)
	,@PageContentBody nvarchar(max)
AS
INSERT INTO PageContents 
(
PageContentTitle
,PageContentBody
,PageContentShortName
,PageContentEditDate
)
VALUES
(
@PageContentTitle
,@PageContentBody
,@PageContentShortName
,GETUTCDATE()
)
GO
/****** Object:  StoredProcedure [dbo].[SPPageContentsGetUsedShortNames]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPPageContentsGetUsedShortNames]
(
	@PageContentShortName nvarchar(32), 
	@SearchShortName nvarchar(32)
)
AS
/*
	Gets used short names for PageContents
	returns:
		IF NOT USED SHORTNAME: empty result set
		IF USED SHORTNAME: resultset with amount of rows used
*/
DECLARE @CurrentValue nvarchar(32)
SELECT 
	@CurrentValue = PageContentShortName
FROM 
	PageContents
WHERE
	PageContentShortName = @PageContentShortName
	

IF @CurrentValue IS NULL
	SELECT NULL As ForumShortName WHERE 1=0
ELSE
	SELECT 
		PageContentShortName
	FROM
		PageContents
	WHERE
		PageContentShortName LIKE @SearchShortName + '%'
		OR
		PageContentShortName = @PageContentShortName
GO
/****** Object:  StoredProcedure [dbo].[SPPageContentsGetAll]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPPageContentsGetAll]
	
AS
SELECT
	PageContentId
	,PageContentTitle
	,PageContentBody
	,PageContentShortName
FROM
	dbo.PageContents
ORDER BY
	PageContentTitle
GO
/****** Object:  StoredProcedure [dbo].[SPPageContentsGet]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPPageContentsGet]
	@PageContentShortName nvarchar(128)='about'
AS
SELECT
	PageContentId
	,PageContentTitle
	,PageContentBody
	,PageContentShortName
FROM
	dbo.PageContents
WHERE
	PageContentShortName = @PageContentShortName
GO
/****** Object:  StoredProcedure [dbo].[SPPageContentsDelete]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPPageContentsDelete]
	@PageContentShortName nvarchar(128)
AS
DELETE FROM PageContents 
WHERE
	PageContentShortName = @PageContentShortName
GO
/****** Object:  StoredProcedure [dbo].[SPTemplatesUpdateCurrent]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTemplatesUpdateCurrent]
	@TemplateId int
AS
UPDATE T
SET
	TemplateIsCurrent = 
		CASE WHEN TemplateId = @TemplateId THEN 1 ELSE 0 END
FROM
	Templates T
GO
/****** Object:  StoredProcedure [dbo].[SPTemplatesInsert]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTemplatesInsert]
	@TemplateKey nvarchar(64)
	,@TemplateDescription nvarchar(256)
	,@TemplateId int OUTPUT
AS

SELECT @TemplateId = TemplateId 
FROM Templates WHERE TemplateKey=@TemplateKey;

IF @TemplateId IS NULL
	BEGIN
	INSERT INTO Templates
	(
		TemplateKey
		,TemplateDescription
		,TemplateDate
		,TemplateIsCurrent
	)
	VALUES
	(
		@TemplateKey
		,@TemplateDescription
		,GETUTCDATE()
		,0
	);

	SELECT @TemplateId = @@IDENTITY;
	
	END
ELSE
	BEGIN
	UPDATE Templates
	SET
		TemplateDescription = @TemplateDescription
		,TemplateDate = GETUTCDATE()
	WHERE 
		TemplateKey=@TemplateKey;
	END
GO
/****** Object:  StoredProcedure [dbo].[SPTemplatesGetCurrent]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTemplatesGetCurrent]

AS
SELECT
	TemplateId
	,TemplateKey
	,TemplateDescription
FROM
	Templates
WHERE
	TemplateIsCurrent = 1
GO
/****** Object:  StoredProcedure [dbo].[SPTemplatesGetAll]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTemplatesGetAll]
AS
SELECT
	TemplateId
	,TemplateKey
	,TemplateDescription
	,TemplateIsCurrent
FROM
	Templates
GO
/****** Object:  StoredProcedure [dbo].[SPTemplatesGet]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTemplatesGet]
	@TemplateId int
AS
SELECT
	TemplateId
	,TemplateKey
	,TemplateDescription
	,TemplateIsCurrent
FROM
	Templates
WHERE
	TemplateId = @TemplateId
GO
/****** Object:  StoredProcedure [dbo].[SPTemplatesDelete]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTemplatesDelete]
	@TemplateId int
AS
DELETE FROM Templates WHERE TemplateId = @TemplateId
GO
/****** Object:  StoredProcedure [dbo].[SPForumsCategoriesGetAll]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPForumsCategoriesGetAll]
AS
SELECT 
	CategoryId
	,CategoryName
	,CategoryOrder
FROM
	ForumsCategories
ORDER BY
	CategoryOrder
GO
/****** Object:  StoredProcedure [dbo].[SPUsersGroupsGet]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPUsersGroupsGet]
	@UserGroupId smallint=1
AS
SELECT 
	UserGroupId
	,UserGroupName
FROM
	UsersGroups
WHERE
	UserGroupId = @UserGroupId
GO
/****** Object:  StoredProcedure [dbo].[SPUsersUpdatePasswordResetGuid]    Script Date: 11/18/2011 11:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPUsersUpdatePasswordResetGuid]
	@UserId int
	,@PasswordResetGuid nvarchar(100)
	,@PasswordResetGuidExpireDate datetime
AS
UPDATE Users
SET
	PasswordResetGuid = @PasswordResetGuid
	,PasswordResetGuidExpireDate = @PasswordResetGuidExpireDate
WHERE
	UserId = @UserId
GO
/****** Object:  StoredProcedure [dbo].[SPUsersUpdateEmail]    Script Date: 11/18/2011 11:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPUsersUpdateEmail]
	@UserId int
	,@UserEmail nvarchar(100)
	,@UserEmailPolicy int
AS
UPDATE Users
SET
	UserEmail = @UserEmail
	,UserEmailPolicy = @UserEmailPolicy
WHERE
	UserId = @UserId
GO
/****** Object:  StoredProcedure [dbo].[SPUsersUpdate]    Script Date: 11/18/2011 11:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPUsersUpdate]
	@UserId int
	,@UserName nvarchar(50)
	,@UserProfile nvarchar(max)
	,@UserSignature nvarchar(max)
	,@UserBirthDate datetime
	,@UserWebsite nvarchar(255)
	,@UserTimezone decimal(9,2)
	,@UserEmail nvarchar(100)
	,@UserEmailPolicy int
	,@UserPhoto nvarchar(1024)
	,@UserExternalProfileUrl nvarchar(255)
AS

UPDATE Users
SET 
UserName = @UserName
,UserProfile = @UserProfile
,UserSignature = @UserSignature
,UserBirthDate = @UserBirthDate
,UserWebsite = @UserWebsite
,UserTimezone = @UserTimezone
,UserEmail = @UserEmail
,UserEmailPolicy = @UserEmailPolicy
,UserPhoto = @UserPhoto
,UserExternalProfileUrl = @UserExternalProfileUrl
WHERE 
	UserId = @UserId;
GO
/****** Object:  StoredProcedure [dbo].[SPUsersPromote]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPUsersPromote]
	@UserId int
AS
DECLARE @UserGroupId int
SELECT @UserGroupId = UserGroupId FROM Users WHERE UserId = @UserId
SELECT @UserGroupId = MIN(UserGroupId) FROM UsersGroups WHERE UserGroupId > @UserGroupId

IF @UserGroupId IS NOT NULL
	UPDATE Users
	SET
		UserGroupId = @UserGroupId
	WHERE
		UserId = @UserId
GO
/****** Object:  StoredProcedure [dbo].[SPUsersInsertFromProvider]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPUsersInsertFromProvider]
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
SELECT 	
	U.UserId
	,U.UserName
	,U.UserGroupId
	,U.UserGuid
	,U.UserTimeZone
	,U.UserExternalProfileUrl
	,U.UserProviderLastCall
	,U.UserEmail
FROM
	Users U
WHERE
	U.UserId = @UserId;
GO
/****** Object:  StoredProcedure [dbo].[SPUsersGetTestUser]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPUsersGetTestUser]
	
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
	,U.UserEmail
FROM
	Users U
WHERE
	U.Active = 1
ORDER BY
	U.UserGroupId DESC
GO
/****** Object:  StoredProcedure [dbo].[SPUsersGetByProvider]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPUsersGetByProvider]
	@Provider nvarchar(32)
	,@ProviderId nvarchar(64)
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
FROM
	Users U
WHERE
	UserProvider = @Provider
	AND
	UserProviderId = @ProviderId
	AND
	U.Active = 1
GO
/****** Object:  StoredProcedure [dbo].[SPUsersGetByPasswordResetGuid]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPUsersGetByPasswordResetGuid]
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
FROM
	Users U
WHERE
	UserProvider = @Provider
	AND
	PasswordResetGuid = @PasswordResetGuid
GO
/****** Object:  StoredProcedure [dbo].[SPUsersGetByName]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPUsersGetByName]
	@UserName nvarchar(50)='Jorge'	
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
/****** Object:  StoredProcedure [dbo].[SPUsersGetAll]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPUsersGetAll]
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
/****** Object:  StoredProcedure [dbo].[SPUsersGet]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPUsersGet]
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
FROM
	Users U
	INNER JOIN UsersGroups UG ON UG.UserGroupId = U.UserGroupId
WHERE
	U.UserId = @UserId
GO
/****** Object:  StoredProcedure [dbo].[SPUsersDemote]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPUsersDemote]
	@UserId int
AS
DECLARE @UserGroupId int
SELECT @UserGroupId = UserGroupId FROM Users WHERE UserId = @UserId
SELECT @UserGroupId = MAX(UserGroupId) FROM UsersGroups WHERE UserGroupId < @UserGroupId

IF @UserGroupId IS NOT NULL
	UPDATE Users
	SET
		UserGroupId = @UserGroupId
	WHERE
		UserId = @UserId
GO
/****** Object:  StoredProcedure [dbo].[SPUsersDelete]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPUsersDelete]
	@UserId int
AS
UPDATE Users
SET	
	Active = 0
WHERE 
	UserId = @UserId
GO
/****** Object:  StoredProcedure [dbo].[SPForumsUpdate]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPForumsUpdate]
(
	@ForumShortName nvarchar(32)
	,@ForumName nvarchar(255)
	,@ForumDescription nvarchar(max)
	,@CategoryId int
	,@UserId int
)
AS
UPDATE Forums
SET
	ForumName = @ForumName
	,ForumDescription = @ForumDescription 
	,CategoryId = @CategoryId
	,ForumLastEditDate = GETUTCDATE()
	,ForumLastEditUser = @UserId
WHERE
	ForumShortName = @ForumShortName
GO
/****** Object:  StoredProcedure [dbo].[SPForumsInsert]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPForumsInsert]
(
	@ForumName nvarchar(255)
	,@ForumShortName nvarchar(32)
	,@ForumDescription nvarchar(max)
	,@CategoryId int
	,@UserId int
)
AS
INSERT INTO Forums
(
	ForumName
	,ForumShortName
	,ForumDescription
	,CategoryId
	,UserId
	,ForumCreationDate
	,ForumLastEditDate
	,ForumLastEditUser
	,Active
	,ForumTopicCount
	,ForumMessageCount
	,ForumOrder
)
VALUES
(
	@ForumName
	,@ForumShortName
	,@ForumDescription
	,@CategoryId
	,@UserId
	,GETUTCDATE()
	,GETUTCDATE()
	,@UserId
	,1
	,0
	,0
	,0
)
GO
/****** Object:  StoredProcedure [dbo].[SPForumsGetUsedShortNames]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPForumsGetUsedShortNames]
(
	@ForumShortName nvarchar(32), 
	@SearchShortName nvarchar(32)
)
AS
/*
	Gets used short names for forums
	returns:
		IF NOT USED SHORTNAME: empty result set
		IF USED SHORTNAME: resultset with amount of rows used
*/
DECLARE @CurrentValue nvarchar(32)
SELECT 
	@CurrentValue = ForumShortName
FROM 
	Forums
WHERE
	ForumShortName = @ForumShortName
	

IF @CurrentValue IS NULL
	SELECT NULL As ForumShortName WHERE 1=0
ELSE
	SELECT 
		ForumShortName
	FROM
		Forums
	WHERE
		ForumShortName LIKE @SearchShortName + '%'
		OR
		ForumShortName = @ForumShortName
GO
/****** Object:  StoredProcedure [dbo].[SPForumsGetByShortName]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPForumsGetByShortName]
	@ShortName nvarchar(32)
AS
SELECT
	F.ForumId
	,F.ForumName
	,F.ForumShortName
	,F.ForumDescription
	,F.UserId
	,F.ForumCreationDate
	,F.ForumTopicCount
	,F.ForumMessageCount
	,C.CategoryId
	,C.CategoryName
FROM
	Forums F 
	INNER JOIN ForumsCategories C ON F.CategoryId = C.CategoryId
WHERE
	F.ForumShortName = @ShortName
	AND
	F.Active = 1
GO
/****** Object:  StoredProcedure [dbo].[SPForumsGetByCategory]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPForumsGetByCategory]
AS
SELECT
	F.ForumId
	,F.ForumName
	,F.ForumShortName
	,F.ForumDescription
	,F.UserId
	,F.ForumCreationDate
	,F.ForumTopicCount
	,F.ForumMessageCount
	,C.CategoryId
	,C.CategoryName
FROM
	ForumsCategories C
	INNER JOIN Forums F ON F.CategoryId = C.CategoryId
WHERE
	F.Active = 1
ORDER BY
	C.CategoryOrder,
	F.ForumOrder
GO
/****** Object:  StoredProcedure [dbo].[SPForumsDelete]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPForumsDelete]
	@ForumShortName nvarchar(32)
AS

UPDATE Forums
SET
	Active = 0
WHERE
	ForumShortName = @ForumShortName
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsOpen]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTopicsOpen]
	@TopicId int
	,@UserId int
	,@Ip varchar (39)
AS
	UPDATE Topics
	SET
		TopicIsClose = 0
		,TopicLastEditDate = GETUTCDATE()
		,TopicLastEditUser = @UserId
		,TopicLastEditIp = @Ip
	WHERE
		TopicId = @TopicId
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsUpdateLastMessage]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTopicsUpdateLastMessage]
	@TopicId int
	,@MessageId int
AS

UPDATE Topics
SET
	TopicReplies = TopicReplies + 1
	,LastMessageId = @MessageId
WHERE
	TopicId = @TopicId
GO
/****** Object:  StoredProcedure [dbo].[SPForumsUpdateRecount]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPForumsUpdateRecount]
	@ForumId int = 2
AS
/*
	RECOUNTS THE CHILDREN MESSAGES AND TOPICS
*/
DECLARE @ForumTopicCount int, @ForumMessageCount int;

SELECT
	@ForumTopicCount = COUNT(TopicId)
	,@ForumMessageCount = SUM(TopicReplies)
FROM
	Topics
WHERE
	ForumId = @ForumId
	AND
	Active = 1;

UPDATE Forums
SET 
	ForumTopicCount = ISNULL(@ForumTopicCount, 0)
	,ForumMessageCount = ISNULL(@ForumMessageCount, 0)
WHERE	
	ForumId = @ForumId;
GO
/****** Object:  StoredProcedure [dbo].[SPForumsUpdateLastMessage]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPForumsUpdateLastMessage]
	@TopicId int
	,@MessageId int
AS

UPDATE F
SET
	F.ForumMessageCount = F.ForumMessageCount + 1
FROM
	Topics T
	INNER JOIN Forums F ON F.ForumId = T.ForumId
WHERE
  T.TopicId = @TopicId;
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsClose]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTopicsClose]
	@TopicId int
	,@UserId int
	,@Ip varchar (39)
AS
	UPDATE Topics
	SET
		TopicIsClose = 1
		,TopicLastEditDate = GETUTCDATE()
		,TopicLastEditUser = @UserId
		,TopicLastEditIp = @Ip
	WHERE
		TopicId = @TopicId
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsAddVisit]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTopicsAddVisit]
	@TopicId int=2
AS
UPDATE Topics
SET
	TopicViews = TopicViews+1
WHERE
	TopicId = @TopicId
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesDelete]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPMessagesDelete]
	@TopicId int
	,@MessageId int
	,@UserId int
AS
UPDATE Messages
SET
	Active = 0
	,MessageLastEditDate = GETUTCDATE()
	,MessageLastEditUser = @UserId
WHERE
	TopicId = @TopicId
	AND
	MessageId = @MessageId
GO
/****** Object:  StoredProcedure [dbo].[SPTagsInsert]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTagsInsert]
	@Tags nvarchar(256),
	@TopicId int,
	@PreviousTags nvarchar(256)=NULL
AS

IF NOT @PreviousTags IS NULL
	BEGIN
	DELETE FROM Tags
	WHERE
		Tag IN (SELECT part FROM dbo.Split(@PreviousTags, ' '))
		AND
		TopicId = @TopicId
	END

INSERT INTO Tags
(Tag,TopicId)
SELECT part, @TopicId FROM dbo.Split(@Tags, ' ')
GO
/****** Object:  StoredProcedure [dbo].[SPTagsGetMostViewed]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTagsGetMostViewed]
	@ForumId int=2
	,@Top bigint=5
AS
SELECT
	Tag, 
	TagViews, 
	(TagViews*100.00)/SUM(case when TagViews > 0 then TagViews else 1 end) OVER() AS Weight
FROM
	(
	SELECT
		TOP (@Top)
		Tags.Tag
		,SUM(T.TopicViews) As TagViews
		,COUNT(T.TopicId) As TopicCount
	FROM
		Tags
		INNER JOIN Topics T ON Tags.TopicId = T.TopicId
	WHERE
		T.ForumId = @ForumId
		AND
		T.Active = 1
	GROUP BY
		Tags.Tag
	ORDER BY SUM(T.TopicViews) desc
	) T
ORDER BY Tag
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesInsert]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPMessagesInsert]
	@TopicId int
	,@MessageBody nvarchar(max)
	,@UserId int
	,@MessageId int OUTPUT
	,@Ip varchar (39)
	,@ParentId int
AS

UPDATE T
	SET
	MessagesIdentity = MessagesIdentity+1
	,@MessageId = MessagesIdentity+1
FROM
	Topics T
WHERE
	TopicId = @TopicId


BEGIN TRY
	BEGIN TRANSACTION

	INSERT INTO Messages
	(
	TopicId
	,MessageId
	,MessageBody
	,MessageCreationDate
	,MessageLastEditDate
	,MessageLastEditUser
	,UserId
	,Active
	,EditIp
	,ParentId
	)
	VALUES
	(
	@TopicId
	,@MessageId
	,@MessageBody
	,GETUTCDATE()
	,GETUTCDATE()
	,@UserId
	,@UserId
	,1
	,@Ip
	,@ParentId
	)


	
	--Update topic
	exec SPTopicsUpdateLastMessage @TopicId=@TopicId, @MessageId=@MessageId
	--Update forums
	exec SPForumsUpdateLastMessage @TopicId=@TopicId, @MessageId=@MessageId
	COMMIT

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK

  -- Raise an error with the details of the exception
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	SELECT @ErrMsg = ERROR_MESSAGE(),
		 @ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)

END CATCH
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsSubscriptionsInsert]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTopicsSubscriptionsInsert]
	@TopicId int
	,@UserId int
AS
IF NOT EXISTS (SELECT TopicId FROM TopicsSubscriptions WHERE TopicId = @TopicId AND UserID = @UserId)
BEGIN
	INSERT INTO TopicsSubscriptions
	(TopicId, UserId)
	VALUES
	(@TopicId, @UserId)
END
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsSubscriptionsGetByUser]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTopicsSubscriptionsGetByUser]
	@UserId int=21
AS
SELECT
	T.TopicId
	,T.TopicTitle
	,T.TopicShortName
	,T.ForumId
	,T.ForumName
	,T.ForumShortName
FROM
	TopicsSubscriptions S
	INNER JOIN TopicsComplete T ON T.TopicId = S.TopicId
WHERE
	S.UserId = @UserId
ORDER BY
	S.TopicId DESC
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsSubscriptionsGetByTopic]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTopicsSubscriptionsGetByTopic]
	@TopicId int
AS
SELECT
	U.UserId
	,U.UserName
	,U.UserEmail
	,U.UserEmailPolicy
	,U.UserGuid
FROM
	TopicsSubscriptions S
	INNER JOIN Users U ON U.UserId = S.UserId
WHERE
	TopicId = @TopicId
	AND
	U.Active = 1
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsSubscriptionsDelete]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTopicsSubscriptionsDelete]
	@TopicId int
	,@UserId int
	,@Userguid char(32)
AS
DELETE S
FROM 
	TopicsSubscriptions S
	INNER JOIN Users U ON U.UserId = S.UserId
WHERE
	S.TopicId = @TopicId
	AND
	S.UserId = @UserId	
	AND
	U.UserGuid = @UserGuid
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetUnanswered]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTopicsGetUnanswered]
AS
SELECT
	T.TopicId
	,T.TopicTitle
	,T.TopicShortName
	,T.TopicDescription
	,T.TopicCreationDate
	,T.TopicViews
	,T.TopicReplies
	,T.UserId
	,T.TopicTags
	,T.TopicIsClose
	,T.TopicOrder
	,T.LastMessageId
	,T.UserName
	,M.MessageCreationDate
	,T.ForumId
	,T.ForumName
	,T.ForumShortName
FROM
	TopicsComplete T
	LEFT JOIN Messages M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
WHERE
	T.TopicReplies = 0 -- Unanswered
	AND
	T.TopicOrder IS NULL -- Not sticky	
ORDER BY 
	TopicId DESC
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetMessagesByUser]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTopicsGetMessagesByUser]
	@UserId int	
AS
/*
Gets the messages posted by the user grouped by topic
*/
SELECT
	T.TopicId
	,M.MessageId
	,M.MessageCreationDate
	,T.TopicTitle
	,T.TopicShortName
	,T.TopicDescription
	,T.TopicCreationDate
	,T.TopicViews
	,T.TopicReplies
	,T.UserId
	,T.TopicTags
	,T.TopicIsClose
	,T.TopicOrder
FROM
	TopicsComplete T
	INNER JOIN Messages M ON M.TopicId = T.TopicId
WHERE
	M.UserId = @UserId
ORDER BY T.TopicId desc, M.MessageId desc
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetLatest]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTopicsGetLatest]
AS
	SELECT
		TOP 20
		T.TopicId
		,T.TopicTitle
		,T.TopicShortName
		,T.TopicDescription
		,T.TopicCreationDate
		,T.TopicViews
		,T.TopicReplies
		,T.UserId
		,T.TopicTags
		,T.TopicIsClose
		,T.TopicOrder
		,T.LastMessageId
		,T.UserName
		,M.MessageCreationDate
	FROM
		TopicsComplete T
		LEFT JOIN Messages M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
	
	ORDER BY T.TopicId desc
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByUser]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTopicsGetByUser]
	@UserId int	
AS
SELECT
	T.TopicId
	,T.TopicTitle
	,T.TopicShortName
	,T.TopicDescription
	,T.TopicCreationDate
	,T.TopicViews
	,T.TopicReplies
	,T.UserId
	,T.TopicTags
	,T.TopicIsClose
	,T.TopicOrder
	,T.LastMessageId
	,T.UserName
	,M.MessageCreationDate
FROM
	TopicsComplete T
	LEFT JOIN Messages M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
WHERE
	T.UserId = @UserId
ORDER BY T.TopicId desc
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByTag]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTopicsGetByTag]
	@Tag nvarchar(50)='forum',
	@ForumId int=2
AS

--Remove the last char
SET @Tag = SUBSTRING(@Tag, 1, LEN(@Tag)-1)
SELECT
		T.TopicId
		,T.TopicTitle
		,T.TopicShortName
		,T.TopicDescription
		,T.TopicCreationDate
		,T.TopicViews
		,T.TopicReplies
		,T.UserId
		,T.TopicTags
		,T.TopicIsClose
		,T.TopicOrder
		,T.LastMessageId
		,T.UserName
		,M.MessageCreationDate
		,M.UserId AS MessageUserId
		,MU.UserName AS MessageUserName
FROM
	Tags
	INNER JOIN TopicsComplete T ON T.TopicId = Tags.TopicId
	LEFT JOIN Messages M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
	LEFT JOIN Users MU ON MU.UserId = M.UserId
WHERE
	Tags.Tag LIKE @Tag + '%'
	AND
	T.ForumId = @ForumId
ORDER BY TopicOrder DESC,TopicViews DESC
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByRelated]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTopicsGetByRelated]
	@Tag1 nvarchar(50)='problem'
	,@Tag2 nvarchar(50)='installation'
	,@Tag3 nvarchar(50)='copy'
	,@Tag4 nvarchar(50)=null
	,@Tag5 nvarchar(50)=null
	,@Tag6 nvarchar(50)=null
	,@TopicId int=1
	,@Amount int=5
AS
	
WITH TagsParams (Tag) AS
(
	SELECT @Tag1
	UNION
	SELECT @Tag2
	UNION
	SELECT @Tag3
	UNION
	SELECT @Tag4
	UNION
	SELECT @Tag5
	UNION
	SELECT @Tag6
)
SELECT
	TOP (@Amount)
	Ta.TagCount
	,Topics.TopicId
	,Topics.TopicTitle
	,Topics.TopicShortName
	,Topics.TopicDescription
	,Topics.TopicCreationDate
	,Topics.TopicViews
	,Topics.TopicReplies
	,Topics.ForumId
	,Topics.ForumName
	,Topics.ForumShortName
	,Topics.TopicIsClose
	,Topics.TopicOrder
FROM
	(
	SELECT 
		T.TopicId
		,COUNT(T.Tag) AS TagCount
	FROM 
		Tags T
		INNER JOIN TagsParams P ON T.Tag=P.Tag
	WHERE
		T.Tag=P.Tag
	GROUP BY
		T.TopicId
	)
	Ta
	INNER JOIN TopicsComplete Topics ON Topics.TopicId = Ta.TopicId
WHERE
	Topics.TopicId <> @TopicId
ORDER BY
	1 desc, Topics.TopicViews desc
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByForumUnanswered]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTopicsGetByForumUnanswered]
	@ForumId int = 2
AS
SELECT
	T.TopicId
	,T.TopicTitle
	,T.TopicShortName
	,T.TopicDescription
	,T.TopicCreationDate
	,T.TopicViews
	,T.TopicReplies
	,T.UserId
	,T.TopicTags
	,T.TopicIsClose
	,T.TopicOrder
	,T.LastMessageId
	,T.UserName
	,M.MessageCreationDate
	,M.UserId AS MessageUserId
	,MU.UserName AS MessageUserName
FROM
	TopicsComplete T
	LEFT JOIN Messages M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
	LEFT JOIN Users MU ON MU.UserId = M.UserId
WHERE
	T.ForumId = @ForumId
	AND
	T.TopicReplies = 0 -- Unanswered
	AND
	T.TopicOrder IS NULL -- Not sticky	
ORDER BY 
	TopicViews DESC, TopicId DESC
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByForumLatest]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTopicsGetByForumLatest]
	@ForumId int = 2
	,@StartIndex int = 0
	,@Length int = 10
AS
SELECT
	*
FROM
	(SELECT
		ROW_NUMBER()
			OVER 
				(ORDER BY TopicOrder desc
				 ,
				 (CASE 
					WHEN M.MessageCreationDate > T.TopicCreationDate THEN M.MessageCreationDate
					ELSE T.TopicCreationDate
				END) desc)
			AS RowNumber
		,T.TopicId
		,T.TopicTitle
		,T.TopicShortName
		,T.TopicDescription
		,T.TopicCreationDate
		,T.TopicViews
		,T.TopicReplies
		,T.UserId
		,T.TopicTags
		,T.TopicIsClose
		,T.TopicOrder
		,T.LastMessageId
		,T.UserName
		,M.MessageCreationDate
		,M.UserId AS MessageUserId
		,MU.UserName AS MessageUserName
	FROM
		TopicsComplete T
		LEFT JOIN Messages M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
		LEFT JOIN Users MU ON MU.UserId = M.UserId
	WHERE
		T.ForumId = @ForumId
	) T
WHERE
	RowNumber BETWEEN @StartIndex+1 AND @StartIndex + @Length
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByForum]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTopicsGetByForum]
	@ForumId int = 2
	,@StartIndex int = 0
	,@Length int = 10
AS
SELECT
	*
FROM
	(SELECT
		ROW_NUMBER()
			OVER 
				(ORDER BY TopicOrder desc
				 ,TopicViews desc)
			AS RowNumber
		,T.TopicId
		,T.TopicTitle
		,T.TopicShortName
		,T.TopicDescription
		,T.TopicCreationDate
		,T.TopicViews
		,T.TopicReplies
		,T.UserId
		,T.TopicTags
		,T.TopicIsClose
		,T.TopicOrder
		,T.LastMessageId
		,T.UserName
		,M.MessageCreationDate
		,M.UserId AS MessageUserId
		,MU.UserName AS MessageUserName
	FROM
		TopicsComplete T
		LEFT JOIN Messages M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
		LEFT JOIN Users MU ON MU.UserId = M.UserId
	WHERE
		T.ForumId = @ForumId
	) T
WHERE
	RowNumber BETWEEN @StartIndex+1 AND @StartIndex + @Length
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGet]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTopicsGet]
	@TopicId int=1
AS
SELECT
	T.TopicId
	,T.TopicTitle
	,T.TopicShortName
	,T.TopicDescription
	,T.TopicCreationDate
	,T.TopicViews
	,T.TopicReplies
	,T.UserId
	,T.TopicTags
	,T.TopicIsClose
	,T.TopicOrder
	,T.LastMessageId
	,T.UserName
	,T.ForumId
	,T.ForumName
	,T.ForumShortName
FROM 
	TopicsComplete T
WHERE
	T.TopicId = @TopicId
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsDelete]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTopicsDelete]
	@TopicId int
	,@UserId int
	,@Ip varchar (39)
AS
/*
- SETS THE TOPIC ACTIVE=0
- UPDATES RECOUNT ON FORUM
*/

DECLARE @ForumId int;
SELECT @ForumId = ForumId FROM Topics WHERE TopicId = @TopicId;

UPDATE Topics
SET
	Active = 0
	,TopicLastEditDate = GETUTCDATE()
	,TopicLastEditUser = @UserId
	,TopicLastEditIp = @Ip
WHERE
	TopicId = @TopicId;

exec dbo.SPForumsUpdateRecount @ForumId;
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsMove]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTopicsMove]
	@TopicId int
	,@ForumId int
	,@UserId int
	,@Ip varchar (39)
AS
DECLARE @PreviousForumId int
SELECT @PreviousForumId = ForumId FROM Topics WHERE TopicId = @TopicId
BEGIN TRY
	BEGIN TRANSACTION
	
	UPDATE Topics
	SET
		ForumId = @ForumId
		,TopicLastEditDate = GETUTCDATE()
		,TopicLastEditUser = @UserId
		,TopicLastEditIp = @Ip
	WHERE
		TopicId = @TopicId

	exec SPForumsUpdateRecount @ForumId
	exec SPForumsUpdateRecount @PreviousForumId

	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK

  -- Raise an error with the details of the exception
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	SELECT @ErrMsg = ERROR_MESSAGE(),
		 @ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)

END CATCH
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsInsert]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTopicsInsert]
(
	@TopicTitle nvarchar(255)
	,@TopicShortName nvarchar(64)
	,@TopicDescription nvarchar(max)
	,@UserId int
	,@TopicTags nvarchar(256)
	,@TopicOrder int
	,@Forum nvarchar(32)
	,@Ip varchar (39)
	,@TopicId int OUTPUT
)
AS
/*
- Inserts topic
- Insert tags
- Updates recount on father
*/

DECLARE @ForumId int

SELECT @ForumId = ForumId FROM Forums WHERE ForumShortName = @Forum
SET @TopicTags = LOWER(@TopicTags)

IF @TopicOrder IS NOT NULL
	BEGIN
	SELECT @TopicOrder = MAX(TopicOrder)+1 FROM Topics
	SELECT @TopicOrder = ISNULL(@TopicOrder, 1)
	END

BEGIN TRY
	BEGIN TRANSACTION
	
	INSERT INTO dbo.Topics
	(
	TopicTitle
	,TopicShortName
	,TopicDescription
	,TopicCreationDate
	,TopicLastEditDate
	,TopicViews
	,TopicReplies
	,UserId
	,TopicTags
	,ForumId
	,TopicLastEditUser
	,TopicLastEditIp
	,Active
	,TopicIsClose
	,TopicOrder
	,MessagesIdentity
	)
	VALUES
	(
	@TopicTitle
	,@TopicShortName
	,@TopicDescription
	,GETUTCDATE()
	,GETUTCDATE()
	,0--TopicViews
	,0--TopicReplies
	,@UserId
	,@TopicTags
	,@ForumId
	,@UserId
	,@Ip
	,1--Active
	,0--TopicIsClose
	,@TopicOrder
	,0--MessageIdentity
	);

	SELECT @TopicId = @@IDENTITY;

	--Add tags
	exec dbo.SPTagsInsert @Tags=@TopicTags, @TopicId=@TopicId;

	--Recount
	exec dbo.SPForumsUpdateRecount @ForumId=@ForumId;
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK

  -- Raise an error with the details of the exception
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	SELECT @ErrMsg = ERROR_MESSAGE(),
		 @ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)

END CATCH
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsUpdate]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPTopicsUpdate]
	@TopicId int
	,@TopicTitle nvarchar(256)
	,@TopicDescription nvarchar(max)
	,@UserId int
	,@TopicTags nvarchar(256)
	,@TopicOrder int
	,@Ip varchar (39)
AS
DECLARE @PreviousTags nvarchar(256)
SELECT @PreviousTags=TopicTags FROM Topics WHERE TopicId=@TopicId

IF @TopicOrder IS NOT NULL
	BEGIN
	SELECT @TopicOrder = MAX(TopicOrder)+1 FROM Topics
	SELECT @TopicOrder = ISNULL(@TopicOrder, 1)
	END

BEGIN TRY
	BEGIN TRANSACTION

	UPDATE T
	SET
		TopicTitle = @TopicTitle
		,TopicDescription = @TopicDescription
		,TopicLastEditDate = GETUTCDATE()
		,TopicTags = @TopicTags
		,TopicLastEditUser = @UserId
		,TopicLastEditIp = @Ip
		,TopicOrder = @TopicOrder
	FROM
		Topics T
	WHERE
		TopicId = @TopicId

	--Edit tags
	EXEC dbo.[SPTagsInsert] @Tags=@TopicTags, @TopicId=@TopicId, @PreviousTags=@PreviousTags

	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK

  -- Raise an error with the details of the exception
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	SELECT @ErrMsg = ERROR_MESSAGE(),
		 @ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)

END CATCH
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesGetByTopicUpTo]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPMessagesGetByTopicUpTo]
	@TopicId int=1,
	@FirstMsg int=3,
	@LastMsg int=28
AS
SELECT 
	ROW_NUMBER()
			OVER 
				(ORDER BY M.TopicId, M.MessageId)
			AS RowNumber
	,M.TopicId
	,M.MessageId
	,M.MessageBody
	,M.MessageCreationDate
	,M.MessageLastEditDate
	,M.ParentId
	,UserId
	,UserName
	,UserSignature
	,UserGroupId
	,UserGroupName
	,UserPhoto
	,UserRegistrationDate
	,M.Active
FROM 
	dbo.MessagesComplete M
WHERE 
	M.TopicId = @TopicId
	AND
	M.MessageId > @FirstMsg
	AND
	M.MessageId <= @LastMsg
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesGetByTopicLatest]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPMessagesGetByTopicLatest]
	@TopicId int=2
AS
SELECT 
	TOP 20
	M.TopicId
	,M.MessageId
	,M.MessageBody
	,M.MessageCreationDate
	,M.MessageLastEditDate
	,M.ParentId
	,UserId
	,UserName
	,UserSignature
	,UserGroupId
	,UserGroupName
	,M.Active
FROM 
	dbo.MessagesComplete M
WHERE 
	M.TopicId = @TopicId
ORDER BY
	TopicId, MessageId DESC
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesGetByTopicFrom]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPMessagesGetByTopicFrom]
	@TopicId int=1,
	@FirstMsg int=13,
	@Amount int=10
AS
SELECT
*
FROM
	(
	SELECT 
		ROW_NUMBER()
				OVER 
					(ORDER BY M.TopicId, M.MessageId)
				AS RowNumber
		,M.TopicId
		,M.MessageId
		,M.MessageBody
		,M.MessageCreationDate
		,M.MessageLastEditDate
		,M.ParentId
		,UserId
		,UserName
		,UserSignature
		,UserGroupId
		,UserGroupName
		,UserPhoto
		,UserRegistrationDate
		,M.Active
	FROM 
		dbo.MessagesComplete M
	WHERE 
		M.TopicId = @TopicId
		AND
		M.MessageId > @FirstMsg
	) M
WHERE
	RowNumber <= @Amount
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesGetByTopic]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPMessagesGetByTopic]
	@TopicId int=2
AS
SELECT 
	ROW_NUMBER()
			OVER 
				(ORDER BY M.TopicId, M.MessageId)
			AS RowNumber
	,M.TopicId
	,M.MessageId
	,M.MessageBody
	,M.MessageCreationDate
	,M.MessageLastEditDate
	,M.ParentId
	,UserId
	,UserName
	,UserSignature
	,UserGroupId
	,UserGroupName
	,UserPhoto
	,UserRegistrationDate
	,M.Active
FROM 
	dbo.MessagesComplete M
WHERE 
	M.TopicId = @TopicId
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesFlagsGetAll]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPMessagesFlagsGetAll]
AS
/*
	Lists all flagged messages (not topics)
*/
SELECT
	F.TopicId
	,F.MessageId
	,COUNT(FlagId) AS TotalFlags
	,T.TopicTitle
	,T.TopicShortName
	,Forums.ForumId
	,Forums.ForumShortName
	,Forums.ForumName
	,M.MessageBody
	,M.UserName
	,M.UserId
FROM
	Flags F
	INNER JOIN Topics T ON T.TopicId = F.TopicId
	INNER JOIN Forums ON Forums.ForumId = T.ForumId
	INNER JOIN MessagesComplete M ON M.TopicId = T.TopicId AND M.MessageId = F.MessageId
WHERE
	T.Active = 1
	AND	
	M.Active = 1
GROUP BY	
	F.TopicId
	,F.MessageId
	,T.TopicTitle
	,T.TopicShortName
	,Forums.ForumId
	,Forums.ForumShortName
	,Forums.ForumName
	,M.MessageBody
	,M.UserName
	,M.UserId
ORDER BY COUNT(FlagId) DESC, F.TopicId
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesFlagsClear]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPMessagesFlagsClear]
(
	@TopicId int=1
	,@MessageId int=1
)
AS
DELETE FROM 
	Flags
WHERE
	TopicId = @TopicId
	AND
	MessageId = @MessageId
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesFlag]    Script Date: 11/18/2011 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPMessagesFlag]
(
	@TopicId int=1
	,@MessageId int=1
	,@Ip varchar (39)='127.0.0.1'
)
AS
IF NOT EXISTS (SELECT * FROM Flags WHERE TopicId=@TopicId AND IP=@Ip AND (MessageId=@MessageId OR (@MessageId IS NULL AND MessageId IS NULL)))
	BEGIN
	INSERT INTO Flags
	(TopicId, MessageId, Ip, FlagDate)
	VALUES
	(@TopicId, @MessageId, @Ip, GETUTCDATE())
	END
GO
