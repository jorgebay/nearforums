/****** Object:  Table [dbo].[Templates]    Script Date: 02/22/2012 16:34:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Templates]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Templates](
	[TemplateId] [int] IDENTITY(1,1) NOT NULL,
	[TemplateKey] [nvarchar](64) NOT NULL,
	[TemplateDescription] [nvarchar](256) NULL,
	[TemplateIsCurrent] [bit] NOT NULL,
	[TemplateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Templates] PRIMARY KEY CLUSTERED 
(
	[TemplateId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[UsersGroups]    Script Date: 02/22/2012 16:34:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UsersGroups]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UsersGroups](
	[UserGroupId] [smallint] NOT NULL,
	[UserGroupName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_UsersGroups] PRIMARY KEY CLUSTERED 
(
	[UserGroupId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[PageContents]    Script Date: 02/22/2012 16:34:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageContents]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PageContents](
	[PageContentId] [int] IDENTITY(1,1) NOT NULL,
	[PageContentTitle] [nvarchar](128) NOT NULL,
	[PageContentBody] [nvarchar](max) NOT NULL,
	[PageContentShortName] [nvarchar](128) NOT NULL,
	[PageContentEditDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PageContents] PRIMARY KEY CLUSTERED 
(
	[PageContentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ForumsCategories]    Script Date: 02/22/2012 16:34:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ForumsCategories]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ForumsCategories](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](255) NOT NULL,
	[CategoryOrder] [int] NOT NULL,
 CONSTRAINT [PK_ForumsCategories] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 02/22/2012 16:34:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Split]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[Split] (@s nvarchar(512), @sep char(1))
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
  )' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPPageContentsUpdate]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPPageContentsUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPPageContentsUpdate]
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
	PageContentShortName = @PageContentShortName' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPPageContentsInsert]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPPageContentsInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPPageContentsInsert]
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
)' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPPageContentsGetUsedShortNames]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPPageContentsGetUsedShortNames]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPPageContentsGetUsedShortNames]
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
		PageContentShortName LIKE @SearchShortName + ''%''
		OR
		PageContentShortName = @PageContentShortName' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPPageContentsGetAll]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPPageContentsGetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPPageContentsGetAll]
	
AS
SELECT
	PageContentId
	,PageContentTitle
	,PageContentBody
	,PageContentShortName
FROM
	dbo.PageContents
ORDER BY
	PageContentTitle' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPPageContentsGet]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPPageContentsGet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPPageContentsGet]
	@PageContentShortName nvarchar(128)=''about''
AS
SELECT
	PageContentId
	,PageContentTitle
	,PageContentBody
	,PageContentShortName
FROM
	dbo.PageContents
WHERE
	PageContentShortName = @PageContentShortName' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPPageContentsDelete]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPPageContentsDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPPageContentsDelete]
	@PageContentShortName nvarchar(128)
AS
DELETE FROM PageContents 
WHERE
	PageContentShortName = @PageContentShortName' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTemplatesUpdateCurrent]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTemplatesUpdateCurrent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTemplatesUpdateCurrent]
	@TemplateId int
AS
UPDATE T
SET
	TemplateIsCurrent = 
		CASE WHEN TemplateId = @TemplateId THEN 1 ELSE 0 END
FROM
	Templates T' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTemplatesInsert]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTemplatesInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTemplatesInsert]
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
	END' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTemplatesGetCurrent]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTemplatesGetCurrent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTemplatesGetCurrent]

AS
SELECT
	TemplateId
	,TemplateKey
	,TemplateDescription
FROM
	Templates
WHERE
	TemplateIsCurrent = 1' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTemplatesGetAll]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTemplatesGetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTemplatesGetAll]
AS
SELECT
	TemplateId
	,TemplateKey
	,TemplateDescription
	,TemplateIsCurrent
FROM
	Templates' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTemplatesGet]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTemplatesGet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTemplatesGet]
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
	TemplateId = @TemplateId' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTemplatesDelete]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTemplatesDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTemplatesDelete]
	@TemplateId int
AS
DELETE FROM Templates WHERE TemplateId = @TemplateId' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPForumsCategoriesGetAll]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPForumsCategoriesGetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPForumsCategoriesGetAll]
AS
SELECT 
	CategoryId
	,CategoryName
	,CategoryOrder
FROM
	ForumsCategories
ORDER BY
	CategoryOrder' 
END
GO
/****** Object:  Table [dbo].[Users]    Script Date: 02/22/2012 16:34:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[UserProfile] [nvarchar](max) NULL,
	[UserSignature] [nvarchar](max) NULL,
	[UserGroupId] [smallint] NOT NULL,
	[Active] [bit] NOT NULL,
	[UserBirthDate] [datetime] NULL,
	[UserWebsite] [nvarchar](255) NULL,
	[UserGuid] [char](32) NOT NULL,
	[UserTimezone] [decimal](9, 2) NOT NULL,
	[UserEmail] [nvarchar](100) NULL,
	[UserEmailPolicy] [int] NULL,
	[UserPhoto] [nvarchar](1024) NULL,
	[UserRegistrationDate] [datetime] NOT NULL,
	[UserExternalProfileUrl] [nvarchar](255) NULL,
	[UserProvider] [nvarchar](32) NOT NULL,
	[UserProviderId] [nvarchar](64) NOT NULL,
	[UserProviderLastCall] [datetime] NOT NULL,
	[PasswordResetGuid] [nvarchar](100) NULL,
	[PasswordResetGuidExpireDate] [datetime] NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[SPUsersGroupsGetAll]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPUsersGroupsGetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[SPUsersGroupsGetAll]
	
AS
SELECT 
	UserGroupId
	,UserGroupName
FROM
	UsersGroups
ORDER BY 
	UserGroupId asc' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPUsersGroupsGet]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPUsersGroupsGet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPUsersGroupsGet]
	@UserGroupId smallint=1
AS
SELECT 
	UserGroupId
	,UserGroupName
FROM
	UsersGroups
WHERE
	UserGroupId = @UserGroupId' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPUsersUpdatePasswordResetGuid]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPUsersUpdatePasswordResetGuid]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPUsersUpdatePasswordResetGuid]
	@UserId int
	,@PasswordResetGuid nvarchar(100)
	,@PasswordResetGuidExpireDate datetime
AS
UPDATE Users
SET
	PasswordResetGuid = @PasswordResetGuid
	,PasswordResetGuidExpireDate = @PasswordResetGuidExpireDate
WHERE
	UserId = @UserId' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPUsersUpdateEmail]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPUsersUpdateEmail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPUsersUpdateEmail]
	@UserId int
	,@UserEmail nvarchar(100)
	,@UserEmailPolicy int
AS
UPDATE Users
SET
	UserEmail = @UserEmail
	,UserEmailPolicy = @UserEmailPolicy
WHERE
	UserId = @UserId' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPUsersUpdate]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPUsersUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPUsersUpdate]
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
	UserId = @UserId;' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPUsersPromote]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPUsersPromote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPUsersPromote]
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
		UserId = @UserId' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPUsersInsertFromProvider]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPUsersInsertFromProvider]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPUsersInsertFromProvider]
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
	U.UserId = @UserId;' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPUsersGetTestUser]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPUsersGetTestUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPUsersGetTestUser]
	
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
	U.UserGroupId DESC' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPUsersGetByProvider]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPUsersGetByProvider]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPUsersGetByProvider]
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
	U.Active = 1' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPUsersGetByPasswordResetGuid]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPUsersGetByPasswordResetGuid]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPUsersGetByPasswordResetGuid]
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
	PasswordResetGuid = @PasswordResetGuid' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPUsersGetByName]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPUsersGetByName]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPUsersGetByName]
	@UserName nvarchar(50)=''Jorge''	
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
	U.UserName LIKE ''%'' + @UserName +  ''%''
	AND
	U.Active = 1
ORDER BY 
	U.UserName' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPUsersGetAll]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPUsersGetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPUsersGetAll]
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
	U.UserName' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPUsersGet]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPUsersGet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPUsersGet]
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
	U.UserId = @UserId' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPUsersDemote]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPUsersDemote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPUsersDemote]
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
		UserId = @UserId' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPUsersDelete]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPUsersDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPUsersDelete]
	@UserId int
AS
UPDATE Users
SET	
	Active = 0
WHERE 
	UserId = @UserId' 
END
GO
/****** Object:  Table [dbo].[Forums]    Script Date: 02/22/2012 16:34:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Forums]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Forums](
	[ForumId] [int] IDENTITY(1,1) NOT NULL,
	[ForumName] [nvarchar](255) NOT NULL,
	[ForumShortName] [nvarchar](32) NOT NULL,
	[ForumDescription] [nvarchar](max) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[ForumCreationDate] [datetime] NOT NULL,
	[ForumLastEditDate] [datetime] NOT NULL,
	[ForumLastEditUser] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[ForumTopicCount] [int] NOT NULL,
	[ForumMessageCount] [int] NOT NULL,
	[ForumOrder] [int] NOT NULL,
	[ReadAccessGroupId] [smallint] NULL,
	[PostAccessGroupId] [smallint] NOT NULL,
 CONSTRAINT [PK_Forums] PRIMARY KEY CLUSTERED 
(
	[ForumId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  StoredProcedure [dbo].[SPForumsUpdate]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPForumsUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPForumsUpdate]
(
	@ForumShortName nvarchar(32)
	,@ForumName nvarchar(255)
	,@ForumDescription nvarchar(max)
	,@CategoryId int
	,@UserId int
	,@ReadAccessGroupId smallint
	,@PostAccessGroupId smallint
)
AS
UPDATE Forums
SET
	ForumName = @ForumName
	,ForumDescription = @ForumDescription 
	,CategoryId = @CategoryId
	,ForumLastEditDate = GETUTCDATE()
	,ForumLastEditUser = @UserId
	,ReadAccessGroupId = @ReadAccessGroupId
	,PostAccessGroupId = @PostAccessGroupId
WHERE
	ForumShortName = @ForumShortName' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPForumsInsert]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPForumsInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPForumsInsert]
(
	@ForumName nvarchar(255)
	,@ForumShortName nvarchar(32)
	,@ForumDescription nvarchar(max)
	,@CategoryId int
	,@UserId int
	,@ReadAccessGroupId smallint
	,@PostAccessGroupId smallint
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
	,ReadAccessGroupId
	,PostAccessGroupId
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
	,@ReadAccessGroupId
	,@PostAccessGroupId
)' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPForumsGetUsedShortNames]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPForumsGetUsedShortNames]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPForumsGetUsedShortNames]
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
		ForumShortName LIKE @SearchShortName + ''%''
		OR
		ForumShortName = @ForumShortName' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPForumsGetByShortName]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPForumsGetByShortName]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPForumsGetByShortName]
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
	,F.ReadAccessGroupId
	,F.PostAccessGroupId
FROM
	Forums F 
	INNER JOIN ForumsCategories C ON F.CategoryId = C.CategoryId
WHERE
	F.ForumShortName = @ShortName
	AND
	F.Active = 1' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPForumsGetByCategory]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPForumsGetByCategory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPForumsGetByCategory]
	@UserGroupId smallint=NULL
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
	AND
	ISNULL(F.ReadAccessGroupId,-1) <= ISNULL(@UserGroupId,-1)
ORDER BY
	C.CategoryOrder,
	F.ForumOrder' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPForumsDelete]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPForumsDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPForumsDelete]
	@ForumShortName nvarchar(32)
AS

UPDATE Forums
SET
	Active = 0
WHERE
	ForumShortName = @ForumShortName' 
END
GO
/****** Object:  Table [dbo].[Topics]    Script Date: 02/22/2012 16:34:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Topics]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Topics](
	[TopicId] [int] IDENTITY(1,1) NOT NULL,
	[TopicTitle] [nvarchar](256) NOT NULL,
	[TopicShortName] [nvarchar](64) NOT NULL,
	[TopicDescription] [nvarchar](max) NOT NULL,
	[TopicCreationDate] [datetime] NOT NULL,
	[TopicLastEditDate] [datetime] NOT NULL,
	[TopicViews] [int] NOT NULL,
	[TopicReplies] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[TopicTags] [nvarchar](256) NOT NULL,
	[ForumId] [int] NOT NULL,
	[TopicLastEditUser] [int] NOT NULL,
	[TopicLastEditIp] [varchar](39) NOT NULL,
	[Active] [bit] NOT NULL,
	[TopicIsClose] [bit] NOT NULL,
	[TopicOrder] [int] NULL,
	[LastMessageId] [int] NULL,
	[MessagesIdentity] [int] NOT NULL,
	[ReadAccessGroupId] [smallint] NULL,
	[PostAccessGroupId] [smallint] NOT NULL,
 CONSTRAINT [PK_Topics] PRIMARY KEY CLUSTERED 
(
	[TopicId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsOpen]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTopicsOpen]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTopicsOpen]
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
		TopicId = @TopicId' 
END
GO
/****** Object:  Table [dbo].[TopicsSubscriptions]    Script Date: 02/22/2012 16:34:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TopicsSubscriptions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TopicsSubscriptions](
	[TopicId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
 CONSTRAINT [PK_TopicsSubscriptions] PRIMARY KEY CLUSTERED 
(
	[TopicId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  View [dbo].[TopicsComplete]    Script Date: 02/22/2012 16:34:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[TopicsComplete]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[TopicsComplete] 
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
		,U.UserName
		,F.ForumId
		,F.ForumName
		,F.ForumShortName
		,CASE 
			WHEN ISNULL(T.ReadAccessGroupId, -1) >= ISNULL(F.ReadAccessGroupId, -1) THEN T.ReadAccessGroupId
			ELSE F.ReadAccessGroupId END AS ReadAccessGroupId
		,CASE 
			WHEN T.PostAccessGroupId >= ISNULL(F.ReadAccessGroupId,-1) THEN T.PostAccessGroupId -- Do not inherit post access
			ELSE F.ReadAccessGroupId END AS PostAccessGroupId -- use the parent read access, if greater
	FROM
		Topics T
		INNER JOIN Users U ON U.UserId = T.UserId
		INNER JOIN Forums F ON F.ForumId = T.ForumId
	WHERE
		T.Active = 1
		AND
		F.Active = 1'
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsUpdateLastMessage]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTopicsUpdateLastMessage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTopicsUpdateLastMessage]
	@TopicId int
	,@MessageId int
AS

UPDATE Topics
SET
	TopicReplies = TopicReplies + 1
	,LastMessageId = @MessageId
WHERE
	TopicId = @TopicId' 
END
GO
/****** Object:  Table [dbo].[Tags]    Script Date: 02/22/2012 16:34:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tags]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Tags](
	[Tag] [nvarchar](50) NOT NULL,
	[TopicId] [int] NOT NULL,
 CONSTRAINT [PK_Tags] PRIMARY KEY CLUSTERED 
(
	[Tag] ASC,
	[TopicId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  StoredProcedure [dbo].[SPForumsUpdateRecount]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPForumsUpdateRecount]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPForumsUpdateRecount]
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
	ForumId = @ForumId;' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPForumsUpdateLastMessage]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPForumsUpdateLastMessage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPForumsUpdateLastMessage]
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
  T.TopicId = @TopicId;' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsClose]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTopicsClose]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTopicsClose]
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
		TopicId = @TopicId' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsAddVisit]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTopicsAddVisit]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTopicsAddVisit]
	@TopicId int=2
AS
UPDATE Topics
SET
	TopicViews = TopicViews+1
WHERE
	TopicId = @TopicId' 
END
GO
/****** Object:  Table [dbo].[Messages]    Script Date: 02/22/2012 16:34:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Messages]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Messages](
	[TopicId] [int] NOT NULL,
	[MessageId] [int] NOT NULL,
	[MessageBody] [nvarchar](max) NOT NULL,
	[MessageCreationDate] [datetime] NOT NULL,
	[MessageLastEditDate] [datetime] NOT NULL,
	[UserId] [int] NOT NULL,
	[ParentId] [int] NULL,
	[Active] [bit] NOT NULL,
	[EditIp] [varchar](39) NULL,
	[MessageLastEditUser] [int] NOT NULL,
 CONSTRAINT [PK_Messages] PRIMARY KEY CLUSTERED 
(
	[TopicId] ASC,
	[MessageId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[MessagesComplete]    Script Date: 02/22/2012 16:34:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[MessagesComplete]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[MessagesComplete]
AS
SELECT
	M.TopicId
	,M.MessageId
	,M.MessageBody
	,M.MessageCreationDate
	,M.MessageLastEditDate
	,M.ParentId
	,M.UserId
	,M.Active
	,U.UserName
	,U.UserSignature
	,U.UserGroupId
	,G.UserGroupName
	,U.UserPhoto
	,U.UserRegistrationDate
FROM
	dbo.Messages M
	INNER JOIN dbo.Users U ON U.UserId = M.UserId
	INNER JOIN dbo.UsersGroups G ON G.UserGroupId = U.UserGroupId
	LEFT JOIN dbo.Messages P ON P.TopicId = M.TopicId AND P.MessageId = M.ParentId AND P.Active = 1'
GO
/****** Object:  Table [dbo].[Flags]    Script Date: 02/22/2012 16:34:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Flags]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Flags](
	[FlagId] [int] IDENTITY(1,1) NOT NULL,
	[TopicId] [int] NOT NULL,
	[MessageId] [int] NULL,
	[Ip] [varchar](39) NOT NULL,
	[FlagDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Flags] PRIMARY KEY CLUSTERED 
(
	[FlagId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesDelete]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPMessagesDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPMessagesDelete]
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
	MessageId = @MessageId' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTagsInsert]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTagsInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTagsInsert]
	@Tags nvarchar(256),
	@TopicId int,
	@PreviousTags nvarchar(256)=NULL
AS

IF NOT @PreviousTags IS NULL
	BEGIN
	DELETE FROM Tags
	WHERE
		Tag IN (SELECT part FROM dbo.Split(@PreviousTags, '' ''))
		AND
		TopicId = @TopicId
	END

INSERT INTO Tags
(Tag,TopicId)
SELECT part, @TopicId FROM dbo.Split(@Tags, '' '')' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTagsGetMostViewed]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTagsGetMostViewed]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTagsGetMostViewed]
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
ORDER BY Tag' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesInsert]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPMessagesInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPMessagesInsert]
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

END CATCH' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsSubscriptionsInsert]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTopicsSubscriptionsInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTopicsSubscriptionsInsert]
	@TopicId int
	,@UserId int
AS
IF NOT EXISTS (SELECT TopicId FROM TopicsSubscriptions WHERE TopicId = @TopicId AND UserID = @UserId)
BEGIN
	INSERT INTO TopicsSubscriptions
	(TopicId, UserId)
	VALUES
	(@TopicId, @UserId)
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsSubscriptionsGetByUser]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTopicsSubscriptionsGetByUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTopicsSubscriptionsGetByUser]
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
	S.TopicId DESC' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsSubscriptionsGetByTopic]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTopicsSubscriptionsGetByTopic]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTopicsSubscriptionsGetByTopic]
	@TopicId int
AS
/*
	Gets the active users subscribed to a topic.
	Checks read access of topic vs user role
*/
SELECT
	U.UserId
	,U.UserName
	,U.UserEmail
	,U.UserEmailPolicy
	,U.UserGuid
FROM
	TopicsSubscriptions S
	INNER JOIN Topics T ON T.TopicId = S.TopicId
	INNER JOIN Users U ON U.UserId = S.UserId
WHERE
	S.TopicId = @TopicId
	AND
	U.Active = 1
	AND
	U.UserGroupId >= ISNULL(T.ReadAccessGroupId, -1)' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsSubscriptionsDelete]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTopicsSubscriptionsDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTopicsSubscriptionsDelete]
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
	U.UserGuid = @UserGuid' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetUnanswered]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTopicsGetUnanswered]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTopicsGetUnanswered]
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
	TopicId DESC' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetMessagesByUser]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTopicsGetMessagesByUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTopicsGetMessagesByUser]
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
ORDER BY T.TopicId desc, M.MessageId desc' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetLatest]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTopicsGetLatest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTopicsGetLatest]
	@UserGroupId int = null
AS
/*
	Gets the latest messages in all forums	
*/
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
	WHERE
		ISNULL(T.ReadAccessGroupId,-1) <= ISNULL(@UserGroupId,-1)
	ORDER BY T.TopicId desc' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByUser]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTopicsGetByUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTopicsGetByUser]
	@UserId int
	,@UserGroupId int = null
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
	,T.ReadAccessGroupId
	,T.PostAccessGroupId
FROM
	TopicsComplete T
	LEFT JOIN Messages M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
WHERE
	T.UserId = @UserId
	AND
	ISNULL(T.ReadAccessGroupId,-1) <= ISNULL(@UserGroupId,-1)
ORDER BY T.TopicId DESC' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByTag]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTopicsGetByTag]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTopicsGetByTag]
	@Tag nvarchar(50)=''forum''
	,@ForumId int=2
	,@UserGroupId int = null
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
		,T.ReadAccessGroupId
		,T.PostAccessGroupId
FROM
	Tags
	INNER JOIN TopicsComplete T ON T.TopicId = Tags.TopicId
	LEFT JOIN Messages M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
	LEFT JOIN Users MU ON MU.UserId = M.UserId
WHERE
	Tags.Tag LIKE @Tag + ''%''
	AND
	T.ForumId = @ForumId
	AND
	ISNULL(T.ReadAccessGroupId,-1) <= ISNULL(@UserGroupId,-1)
ORDER BY TopicOrder DESC,TopicViews DESC' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByRelated]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTopicsGetByRelated]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTopicsGetByRelated]
	@Tag1 nvarchar(50)=''problem''
	,@Tag2 nvarchar(50)=''installation''
	,@Tag3 nvarchar(50)=''copy''
	,@Tag4 nvarchar(50)=null
	,@Tag5 nvarchar(50)=null
	,@Tag6 nvarchar(50)=null
	,@TopicId int=1
	,@Amount int=5
	,@UserGroupId int = null
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
	,Topics.ReadAccessGroupId
	,Topics.PostAccessGroupId
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
	AND
	ISNULL(Topics.ReadAccessGroupId,-1) <= ISNULL(@UserGroupId,-1)
ORDER BY
	1 desc, Topics.TopicViews DESC' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByForumUnanswered]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTopicsGetByForumUnanswered]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTopicsGetByForumUnanswered]
	@ForumId int = 2
	,@UserGroupId int = null
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
	,T.ReadAccessGroupId
	,T.PostAccessGroupId
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
	AND
	ISNULL(T.ReadAccessGroupId,-1) <= ISNULL(@UserGroupId,-1)
ORDER BY 
	TopicViews DESC, TopicId DESC' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByForumLatest]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTopicsGetByForumLatest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTopicsGetByForumLatest]
	@ForumId int = 2
	,@StartIndex int = 0
	,@Length int = 10
	,@UserGroupId int = null
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
		,T.ReadAccessGroupId
		,T.PostAccessGroupId
	FROM
		TopicsComplete T
		LEFT JOIN [Messages] M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
		LEFT JOIN Users MU ON MU.UserId = M.UserId
	WHERE
		T.ForumId = @ForumId
		AND
		ISNULL(T.ReadAccessGroupId,-1) <= ISNULL(@UserGroupId,-1)
	) T
WHERE
	RowNumber BETWEEN @StartIndex+1 AND @StartIndex + @Length' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByForum]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTopicsGetByForum]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTopicsGetByForum]
	@ForumId int = 2
	,@StartIndex int = 0
	,@Length int = 10
	,@UserGroupId int = null
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
		,T.ReadAccessGroupId
		,T.PostAccessGroupId
	FROM
		TopicsComplete T
		LEFT JOIN [Messages] M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
		LEFT JOIN Users MU ON MU.UserId = M.UserId
	WHERE
		T.ForumId = @ForumId
		AND
		ISNULL(T.ReadAccessGroupId,-1) <= ISNULL(@UserGroupId,-1)
	) T
WHERE
	RowNumber BETWEEN @StartIndex+1 AND @StartIndex + @Length' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsGet]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTopicsGet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTopicsGet]
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
	,T.ReadAccessGroupId
	,T.PostAccessGroupId
FROM 
	TopicsComplete T
WHERE
	T.TopicId = @TopicId' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsDelete]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTopicsDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTopicsDelete]
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

exec dbo.SPForumsUpdateRecount @ForumId;' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsMove]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTopicsMove]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTopicsMove]
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

END CATCH' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsInsert]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTopicsInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTopicsInsert]
(
	@TopicTitle nvarchar(255)
	,@TopicShortName nvarchar(64)
	,@TopicDescription nvarchar(max)
	,@UserId int
	,@TopicTags nvarchar(256)
	,@TopicOrder int
	,@Forum nvarchar(32)
	,@Ip varchar (39)
	,@ReadAccessGroupId smallint
	,@PostAccessGroupId smallint
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
	,ReadAccessGroupId
	,PostAccessGroupId
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
	,@ReadAccessGroupId
	,@PostAccessGroupId
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

END CATCH' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsUpdate]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPTopicsUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPTopicsUpdate]
	@TopicId int
	,@TopicTitle nvarchar(256)
	,@TopicDescription nvarchar(max)
	,@UserId int
	,@TopicTags nvarchar(256)
	,@TopicOrder int
	,@ReadAccessGroupId smallint
	,@PostAccessGroupId smallint
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
		,ReadAccessGroupId = @ReadAccessGroupId
		,PostAccessGroupId = @PostAccessGroupId
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
END CATCH' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesGetByTopicUpTo]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPMessagesGetByTopicUpTo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPMessagesGetByTopicUpTo]
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
	M.MessageId <= @LastMsg' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesGetByTopicLatest]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPMessagesGetByTopicLatest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPMessagesGetByTopicLatest]
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
	TopicId, MessageId DESC' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesGetByTopicFrom]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPMessagesGetByTopicFrom]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPMessagesGetByTopicFrom]
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
	RowNumber <= @Amount' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesGetByTopic]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPMessagesGetByTopic]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPMessagesGetByTopic]
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
	M.TopicId = @TopicId' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesFlagsGetAll]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPMessagesFlagsGetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPMessagesFlagsGetAll]
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
ORDER BY COUNT(FlagId) DESC, F.TopicId' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesFlagsClear]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPMessagesFlagsClear]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPMessagesFlagsClear]
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
	MessageId = @MessageId' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesFlag]    Script Date: 02/22/2012 16:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPMessagesFlag]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPMessagesFlag]
(
	@TopicId int=1
	,@MessageId int=1
	,@Ip varchar (39)=''127.0.0.1''
)
AS
IF NOT EXISTS (SELECT * FROM Flags WHERE TopicId=@TopicId AND IP=@Ip AND (MessageId=@MessageId OR (@MessageId IS NULL AND MessageId IS NULL)))
	BEGIN
	INSERT INTO Flags
	(TopicId, MessageId, Ip, FlagDate)
	VALUES
	(@TopicId, @MessageId, @Ip, GETUTCDATE())
	END' 
END
GO
/****** Object:  ForeignKey [FK_Flags_Messages]    Script Date: 02/22/2012 16:34:39 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Flags_Messages]') AND parent_object_id = OBJECT_ID(N'[dbo].[Flags]'))
ALTER TABLE [dbo].[Flags]  WITH CHECK ADD  CONSTRAINT [FK_Flags_Messages] FOREIGN KEY([TopicId], [MessageId])
REFERENCES [dbo].[Messages] ([TopicId], [MessageId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Flags_Messages]') AND parent_object_id = OBJECT_ID(N'[dbo].[Flags]'))
ALTER TABLE [dbo].[Flags] CHECK CONSTRAINT [FK_Flags_Messages]
GO
/****** Object:  ForeignKey [FK_Forums_ForumsCategories]    Script Date: 02/22/2012 16:34:39 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_ForumsCategories]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums]  WITH CHECK ADD  CONSTRAINT [FK_Forums_ForumsCategories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[ForumsCategories] ([CategoryId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_ForumsCategories]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums] CHECK CONSTRAINT [FK_Forums_ForumsCategories]
GO
/****** Object:  ForeignKey [FK_Forums_Users]    Script Date: 02/22/2012 16:34:39 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums]  WITH CHECK ADD  CONSTRAINT [FK_Forums_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums] CHECK CONSTRAINT [FK_Forums_Users]
GO
/****** Object:  ForeignKey [FK_Forums_Users_LastEdit]    Script Date: 02/22/2012 16:34:39 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_Users_LastEdit]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums]  WITH CHECK ADD  CONSTRAINT [FK_Forums_Users_LastEdit] FOREIGN KEY([ForumLastEditUser])
REFERENCES [dbo].[Users] ([UserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_Users_LastEdit]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums] CHECK CONSTRAINT [FK_Forums_Users_LastEdit]
GO
/****** Object:  ForeignKey [FK_Forums_UsersGroups_Post]    Script Date: 02/22/2012 16:34:39 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_UsersGroups_Post]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums]  WITH CHECK ADD  CONSTRAINT [FK_Forums_UsersGroups_Post] FOREIGN KEY([PostAccessGroupId])
REFERENCES [dbo].[UsersGroups] ([UserGroupId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_UsersGroups_Post]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums] CHECK CONSTRAINT [FK_Forums_UsersGroups_Post]
GO
/****** Object:  ForeignKey [FK_Forums_UsersGroups_Read]    Script Date: 02/22/2012 16:34:39 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_UsersGroups_Read]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums]  WITH CHECK ADD  CONSTRAINT [FK_Forums_UsersGroups_Read] FOREIGN KEY([ReadAccessGroupId])
REFERENCES [dbo].[UsersGroups] ([UserGroupId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_UsersGroups_Read]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums] CHECK CONSTRAINT [FK_Forums_UsersGroups_Read]
GO
/****** Object:  ForeignKey [FK_Messages_Topics]    Script Date: 02/22/2012 16:34:39 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Messages_Topics]') AND parent_object_id = OBJECT_ID(N'[dbo].[Messages]'))
ALTER TABLE [dbo].[Messages]  WITH CHECK ADD  CONSTRAINT [FK_Messages_Topics] FOREIGN KEY([TopicId])
REFERENCES [dbo].[Topics] ([TopicId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Messages_Topics]') AND parent_object_id = OBJECT_ID(N'[dbo].[Messages]'))
ALTER TABLE [dbo].[Messages] CHECK CONSTRAINT [FK_Messages_Topics]
GO
/****** Object:  ForeignKey [FK_Messages_Users]    Script Date: 02/22/2012 16:34:39 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Messages_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Messages]'))
ALTER TABLE [dbo].[Messages]  WITH CHECK ADD  CONSTRAINT [FK_Messages_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Messages_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Messages]'))
ALTER TABLE [dbo].[Messages] CHECK CONSTRAINT [FK_Messages_Users]
GO
/****** Object:  ForeignKey [FK_Tags_Topics]    Script Date: 02/22/2012 16:34:39 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Tags_Topics]') AND parent_object_id = OBJECT_ID(N'[dbo].[Tags]'))
ALTER TABLE [dbo].[Tags]  WITH CHECK ADD  CONSTRAINT [FK_Tags_Topics] FOREIGN KEY([TopicId])
REFERENCES [dbo].[Topics] ([TopicId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Tags_Topics]') AND parent_object_id = OBJECT_ID(N'[dbo].[Tags]'))
ALTER TABLE [dbo].[Tags] CHECK CONSTRAINT [FK_Tags_Topics]
GO
/****** Object:  ForeignKey [FK_Topics_Forums]    Script Date: 02/22/2012 16:34:39 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_Forums]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics]  WITH CHECK ADD  CONSTRAINT [FK_Topics_Forums] FOREIGN KEY([ForumId])
REFERENCES [dbo].[Forums] ([ForumId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_Forums]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics] CHECK CONSTRAINT [FK_Topics_Forums]
GO
/****** Object:  ForeignKey [FK_Topics_Users]    Script Date: 02/22/2012 16:34:39 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics]  WITH CHECK ADD  CONSTRAINT [FK_Topics_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics] CHECK CONSTRAINT [FK_Topics_Users]
GO
/****** Object:  ForeignKey [FK_Topics_Users_LastEdit]    Script Date: 02/22/2012 16:34:39 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_Users_LastEdit]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics]  WITH CHECK ADD  CONSTRAINT [FK_Topics_Users_LastEdit] FOREIGN KEY([TopicLastEditUser])
REFERENCES [dbo].[Users] ([UserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_Users_LastEdit]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics] CHECK CONSTRAINT [FK_Topics_Users_LastEdit]
GO
/****** Object:  ForeignKey [FK_Topics_UsersGroups_Post]    Script Date: 02/22/2012 16:34:39 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_UsersGroups_Post]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics]  WITH CHECK ADD  CONSTRAINT [FK_Topics_UsersGroups_Post] FOREIGN KEY([PostAccessGroupId])
REFERENCES [dbo].[UsersGroups] ([UserGroupId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_UsersGroups_Post]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics] CHECK CONSTRAINT [FK_Topics_UsersGroups_Post]
GO
/****** Object:  ForeignKey [FK_Topics_UsersGroups_Read]    Script Date: 02/22/2012 16:34:39 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_UsersGroups_Read]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics]  WITH CHECK ADD  CONSTRAINT [FK_Topics_UsersGroups_Read] FOREIGN KEY([ReadAccessGroupId])
REFERENCES [dbo].[UsersGroups] ([UserGroupId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_UsersGroups_Read]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics] CHECK CONSTRAINT [FK_Topics_UsersGroups_Read]
GO
/****** Object:  ForeignKey [FK_TopicsSubscriptions_Topics]    Script Date: 02/22/2012 16:34:39 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TopicsSubscriptions_Topics]') AND parent_object_id = OBJECT_ID(N'[dbo].[TopicsSubscriptions]'))
ALTER TABLE [dbo].[TopicsSubscriptions]  WITH CHECK ADD  CONSTRAINT [FK_TopicsSubscriptions_Topics] FOREIGN KEY([TopicId])
REFERENCES [dbo].[Topics] ([TopicId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TopicsSubscriptions_Topics]') AND parent_object_id = OBJECT_ID(N'[dbo].[TopicsSubscriptions]'))
ALTER TABLE [dbo].[TopicsSubscriptions] CHECK CONSTRAINT [FK_TopicsSubscriptions_Topics]
GO
/****** Object:  ForeignKey [FK_TopicsSubscriptions_Users]    Script Date: 02/22/2012 16:34:39 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TopicsSubscriptions_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[TopicsSubscriptions]'))
ALTER TABLE [dbo].[TopicsSubscriptions]  WITH CHECK ADD  CONSTRAINT [FK_TopicsSubscriptions_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TopicsSubscriptions_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[TopicsSubscriptions]'))
ALTER TABLE [dbo].[TopicsSubscriptions] CHECK CONSTRAINT [FK_TopicsSubscriptions_Users]
GO
/****** Object:  ForeignKey [FK_Users_UsersGroups]    Script Date: 02/22/2012 16:34:39 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Users_UsersGroups]') AND parent_object_id = OBJECT_ID(N'[dbo].[Users]'))
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_UsersGroups] FOREIGN KEY([UserGroupId])
REFERENCES [dbo].[UsersGroups] ([UserGroupId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Users_UsersGroups]') AND parent_object_id = OBJECT_ID(N'[dbo].[Users]'))
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_UsersGroups]
GO
