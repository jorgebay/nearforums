/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  Table [dbo].[Settings]    Script Date: 05/17/2013 14:46:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Settings]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Settings](
	[SettingKey] [varchar](256) NOT NULL,
	[SettingValue] [nvarchar](max) NULL,
	[SettingDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED 
(
	[SettingKey] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF)
)
END
GO
/****** Object:  Table [dbo].[PageContents]    Script Date: 05/17/2013 14:46:08 ******/
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
)WITH (STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF)
)
END
GO
/****** Object:  Table [dbo].[ForumsCategories]    Script Date: 05/17/2013 14:46:08 ******/
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
)WITH (STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF)
)
END
GO
/****** Object:  Table [dbo].[Templates]    Script Date: 05/17/2013 14:46:08 ******/
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
)WITH (STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF)
)
END
GO
/****** Object:  Table [dbo].[UsersGroups]    Script Date: 05/17/2013 14:46:08 ******/
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
)WITH (STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF)
)
END
GO
/****** Object:  Table [dbo].[Users]    Script Date: 05/17/2013 14:46:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	[WarningStart] [datetime] NULL,
	[WarningRead] [bit] NULL,
	[SuspendedStart] [datetime] NULL,
	[SuspendedEnd] [datetime] NULL,
	[BannedStart] [datetime] NULL,
	[ModeratorReasonFull] [nvarchar](max) NULL,
	[ModeratorReason] [int] NULL,
	[ModeratorUserId] [int] NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF)
)
END
GO
/****** Object:  StoredProcedure [dbo].[SPSettingsSet]    Script Date: 05/17/2013 14:46:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPSettingsSet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPSettingsSet]
	@SettingKey varchar(256)
	,@SettingValue nvarchar(max)
AS
IF EXISTS (SELECT * FROM Settings WHERE SettingKey=@SettingKey)
	BEGIN
	UPDATE Settings	
	SET SettingValue = @SettingValue, 
		SettingDate = GETUTCDATE()
	WHERE SettingKey=@SettingKey
	END
ELSE
	BEGIN
	INSERT INTO Settings (SettingKey, SettingValue, SettingDate)
	VALUES (@SettingKey, @SettingValue, GETUTCDATE())
	END' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPSettingsGet]    Script Date: 05/17/2013 14:46:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPSettingsGet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPSettingsGet]
	@SettingKey varchar(256)
AS
SELECT 
	SettingKey, SettingValue, SettingDate
FROM 
	Settings
WHERE
	SettingKey = @SettingKey' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPPageContentsUpdate]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPPageContentsInsert]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPPageContentsGetUsedShortNames]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPPageContentsGetAll]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPPageContentsGet]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPPageContentsDelete]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPForumsCategoriesGetAll]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPForumsCategoriesGet]    Script Date: 05/17/2013 14:46:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPForumsCategoriesGet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPForumsCategoriesGet] 
	@CategoryId int
AS
BEGIN
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM ForumsCategories WHERE CategoryId = @CategoryId
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPForumsCategoriesDelete]    Script Date: 05/17/2013 14:46:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPForumsCategoriesDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPForumsCategoriesDelete]
	@categoryId int
AS
BEGIN
	DELETE FROM ForumsCategories WHERE CategoryId = @categoryId
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPForumsCategoriesUpdate]    Script Date: 05/17/2013 14:46:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPForumsCategoriesUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPForumsCategoriesUpdate] 
	@CategoryId int,
	@CategoryName nvarchar(255),
	@CategoryOrder int
AS
BEGIN
	UPDATE ForumsCategories
	SET
	CategoryName = @CategoryName,
	CategoryOrder = @CategoryOrder
	WHERE
	CategoryId = @CategoryId
END

SET ANSI_NULLS ON' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPForumsCategoriesInsert]    Script Date: 05/17/2013 14:46:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPForumsCategoriesInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPForumsCategoriesInsert] 
	-- Add the parameters for the stored procedure here
	@categoryName nvarchar(255),
	@categoryOrder int
AS
BEGIN
	INSERT INTO ForumsCategories
	(
		CategoryName,
		CategoryOrder
	)
	VALUES
	(
		@categoryName,
		@categoryOrder
	)
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTemplatesUpdateCurrent]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTemplatesInsert]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTemplatesGetCurrent]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTemplatesGetAll]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTemplatesGet]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTemplatesDelete]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPUsersGroupsGetAll]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPUsersGroupsGet]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPUsersGetTestUser]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPUsersGetByProvider]    Script Date: 05/17/2013 14:46:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPUsersGetByProvider]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
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
	UserProviderId = @ProviderId
	AND
	U.Active = 1
' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPUsersGetByPasswordResetGuid]    Script Date: 05/17/2013 14:46:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPUsersGetByPasswordResetGuid]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
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
' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPUsersGetByName]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPUsersGetAll]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPUsersGet]    Script Date: 05/17/2013 14:46:09 ******/
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
	U.UserId = @UserId;' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPUsersDemote]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPUsersDelete]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPUsersBan]    Script Date: 05/17/2013 14:46:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPUsersBan]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPUsersBan]
(
	@UserId int
	, @ModeratorUserId int
	, @ModeratorReason int
	, @ModeratorReasonFull nvarchar(max)
)
AS

UPDATE Users
SET
	BannedStart = GETUTCDATE()
	, ModeratorReason = @ModeratorReason
	, ModeratorReasonFull = @ModeratorReasonFull
	, ModeratorUserId = @ModeratorUserId
WHERE 
	UserId = @UserId' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPUsersWarnDismiss]    Script Date: 05/17/2013 14:46:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPUsersWarnDismiss]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[SPUsersWarnDismiss]
(
	@UserId int
)
AS

UPDATE Users
SET
	WarningRead = 1
WHERE 
	UserId = @UserId' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPUsersWarn]    Script Date: 05/17/2013 14:46:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPUsersWarn]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPUsersWarn]
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
	UserId = @UserId' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPUsersUpdatePasswordResetGuid]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPUsersUpdateEmail]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPUsersUpdate]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPUsersSuspend]    Script Date: 05/17/2013 14:46:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPUsersSuspend]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[SPUsersSuspend]
(
	@UserId int
	, @ModeratorUserId int
	, @ModeratorReason int
	, @ModeratorReasonFull nvarchar(max)
	, @SuspendedEnd datetime
)
AS

UPDATE Users
SET
	SuspendedStart = GETUTCDATE()
	, SuspendedEnd = @SuspendedEnd
	, ModeratorReason = @ModeratorReason
	, ModeratorReasonFull = @ModeratorReasonFull
	, ModeratorUserId = @ModeratorUserId
WHERE 
	UserId = @UserId' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPUsersPromote]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  Table [dbo].[Forums]    Script Date: 05/17/2013 14:46:08 ******/
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
)WITH (STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF)
)
END
GO
/****** Object:  StoredProcedure [dbo].[SPForumsUpdate]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPForumsInsert]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPForumsGetUsedShortNames]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPForumsGetByShortName]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPForumsGetByCategory]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPForumsDelete]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPForumsCategoriesGetForumsCountPerCategory]    Script Date: 05/17/2013 14:46:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPForumsCategoriesGetForumsCountPerCategory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SPForumsCategoriesGetForumsCountPerCategory] 
	@CategoryId int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  count(*) as NoofForums FROM Forums WHERE CategoryId = @CategoryId 
END' 
END
GO
/****** Object:  Table [dbo].[Topics]    Script Date: 05/17/2013 14:46:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
)WITH (STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF)
)
END
GO
/****** Object:  StoredProcedure [dbo].[SPUsersInsertFromProvider]    Script Date: 05/17/2013 14:46:09 ******/
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
EXEC dbo.SPUsersGetByProvider @UserProvider, @UserProviderId;' 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTopicsUpdateLastMessage]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTopicsClose]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTopicsAddVisit]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTopicsOpen]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPForumsUpdateRecount]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPForumsUpdateLastMessage]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  Table [dbo].[Messages]    Script Date: 05/17/2013 14:46:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
)WITH (STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF)
)
END
GO
/****** Object:  Table [dbo].[TopicsSubscriptions]    Script Date: 05/17/2013 14:46:08 ******/
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
)WITH (STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF)
)
END
GO
/****** Object:  View [dbo].[TopicsComplete]    Script Date: 05/17/2013 14:46:08 ******/
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
/****** Object:  Table [dbo].[Tags]    Script Date: 05/17/2013 14:46:08 ******/
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
)WITH (STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF)
)
END
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesDelete]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  View [dbo].[MessagesComplete]    Script Date: 05/17/2013 14:46:08 ******/
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
/****** Object:  Table [dbo].[Flags]    Script Date: 05/17/2013 14:46:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
)WITH (STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF)
)
END
GO
/****** Object:  StoredProcedure [dbo].[SPMessagesInsert]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTagsInsert]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTagsGetMostViewed]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTopicsGetUnanswered]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTopicsGetMessagesByUser]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTopicsGetLatest]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByUser]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByTag]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByRelated]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByForumUnanswered]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByForumLatest]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTopicsGetByForum]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTopicsGet]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTopicsDelete]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTopicsSubscriptionsInsert]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTopicsSubscriptionsGetByUser]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTopicsSubscriptionsGetByTopic]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTopicsSubscriptionsDelete]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTopicsMove]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTopicsUpdate]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPTopicsInsert]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPMessagesGetByTopicUpTo]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPMessagesGetByTopicLatest]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPMessagesGetByTopicFrom]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPMessagesGetByTopic]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPMessagesFlagsGetAll]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPMessagesFlagsClear]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  StoredProcedure [dbo].[SPMessagesFlag]    Script Date: 05/17/2013 14:46:09 ******/
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
/****** Object:  ForeignKey [FK_Flags_Messages]    Script Date: 05/17/2013 14:46:08 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Flags_Messages]') AND parent_object_id = OBJECT_ID(N'[dbo].[Flags]'))
ALTER TABLE [dbo].[Flags]  WITH CHECK ADD  CONSTRAINT [FK_Flags_Messages] FOREIGN KEY([TopicId], [MessageId])
REFERENCES [dbo].[Messages] ([TopicId], [MessageId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Flags_Messages]') AND parent_object_id = OBJECT_ID(N'[dbo].[Flags]'))
ALTER TABLE [dbo].[Flags] CHECK CONSTRAINT [FK_Flags_Messages]
GO
/****** Object:  ForeignKey [FK_Forums_ForumsCategories]    Script Date: 05/17/2013 14:46:08 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_ForumsCategories]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums]  WITH CHECK ADD  CONSTRAINT [FK_Forums_ForumsCategories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[ForumsCategories] ([CategoryId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_ForumsCategories]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums] CHECK CONSTRAINT [FK_Forums_ForumsCategories]
GO
/****** Object:  ForeignKey [FK_Forums_Users]    Script Date: 05/17/2013 14:46:08 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums]  WITH CHECK ADD  CONSTRAINT [FK_Forums_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums] CHECK CONSTRAINT [FK_Forums_Users]
GO
/****** Object:  ForeignKey [FK_Forums_Users_LastEdit]    Script Date: 05/17/2013 14:46:08 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_Users_LastEdit]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums]  WITH CHECK ADD  CONSTRAINT [FK_Forums_Users_LastEdit] FOREIGN KEY([ForumLastEditUser])
REFERENCES [dbo].[Users] ([UserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_Users_LastEdit]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums] CHECK CONSTRAINT [FK_Forums_Users_LastEdit]
GO
/****** Object:  ForeignKey [FK_Forums_UsersGroups_Post]    Script Date: 05/17/2013 14:46:08 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_UsersGroups_Post]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums]  WITH CHECK ADD  CONSTRAINT [FK_Forums_UsersGroups_Post] FOREIGN KEY([PostAccessGroupId])
REFERENCES [dbo].[UsersGroups] ([UserGroupId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_UsersGroups_Post]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums] CHECK CONSTRAINT [FK_Forums_UsersGroups_Post]
GO
/****** Object:  ForeignKey [FK_Forums_UsersGroups_Read]    Script Date: 05/17/2013 14:46:08 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_UsersGroups_Read]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums]  WITH CHECK ADD  CONSTRAINT [FK_Forums_UsersGroups_Read] FOREIGN KEY([ReadAccessGroupId])
REFERENCES [dbo].[UsersGroups] ([UserGroupId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_UsersGroups_Read]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums] CHECK CONSTRAINT [FK_Forums_UsersGroups_Read]
GO
/****** Object:  ForeignKey [FK_Messages_Topics]    Script Date: 05/17/2013 14:46:08 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Messages_Topics]') AND parent_object_id = OBJECT_ID(N'[dbo].[Messages]'))
ALTER TABLE [dbo].[Messages]  WITH CHECK ADD  CONSTRAINT [FK_Messages_Topics] FOREIGN KEY([TopicId])
REFERENCES [dbo].[Topics] ([TopicId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Messages_Topics]') AND parent_object_id = OBJECT_ID(N'[dbo].[Messages]'))
ALTER TABLE [dbo].[Messages] CHECK CONSTRAINT [FK_Messages_Topics]
GO
/****** Object:  ForeignKey [FK_Messages_Users]    Script Date: 05/17/2013 14:46:08 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Messages_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Messages]'))
ALTER TABLE [dbo].[Messages]  WITH CHECK ADD  CONSTRAINT [FK_Messages_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Messages_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Messages]'))
ALTER TABLE [dbo].[Messages] CHECK CONSTRAINT [FK_Messages_Users]
GO
/****** Object:  ForeignKey [FK_Tags_Topics]    Script Date: 05/17/2013 14:46:08 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Tags_Topics]') AND parent_object_id = OBJECT_ID(N'[dbo].[Tags]'))
ALTER TABLE [dbo].[Tags]  WITH CHECK ADD  CONSTRAINT [FK_Tags_Topics] FOREIGN KEY([TopicId])
REFERENCES [dbo].[Topics] ([TopicId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Tags_Topics]') AND parent_object_id = OBJECT_ID(N'[dbo].[Tags]'))
ALTER TABLE [dbo].[Tags] CHECK CONSTRAINT [FK_Tags_Topics]
GO
/****** Object:  ForeignKey [FK_Topics_Forums]    Script Date: 05/17/2013 14:46:08 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_Forums]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics]  WITH CHECK ADD  CONSTRAINT [FK_Topics_Forums] FOREIGN KEY([ForumId])
REFERENCES [dbo].[Forums] ([ForumId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_Forums]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics] CHECK CONSTRAINT [FK_Topics_Forums]
GO
/****** Object:  ForeignKey [FK_Topics_Users]    Script Date: 05/17/2013 14:46:08 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics]  WITH CHECK ADD  CONSTRAINT [FK_Topics_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics] CHECK CONSTRAINT [FK_Topics_Users]
GO
/****** Object:  ForeignKey [FK_Topics_Users_LastEdit]    Script Date: 05/17/2013 14:46:08 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_Users_LastEdit]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics]  WITH CHECK ADD  CONSTRAINT [FK_Topics_Users_LastEdit] FOREIGN KEY([TopicLastEditUser])
REFERENCES [dbo].[Users] ([UserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_Users_LastEdit]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics] CHECK CONSTRAINT [FK_Topics_Users_LastEdit]
GO
/****** Object:  ForeignKey [FK_Topics_UsersGroups_Post]    Script Date: 05/17/2013 14:46:08 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_UsersGroups_Post]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics]  WITH CHECK ADD  CONSTRAINT [FK_Topics_UsersGroups_Post] FOREIGN KEY([PostAccessGroupId])
REFERENCES [dbo].[UsersGroups] ([UserGroupId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_UsersGroups_Post]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics] CHECK CONSTRAINT [FK_Topics_UsersGroups_Post]
GO
/****** Object:  ForeignKey [FK_Topics_UsersGroups_Read]    Script Date: 05/17/2013 14:46:08 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_UsersGroups_Read]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics]  WITH CHECK ADD  CONSTRAINT [FK_Topics_UsersGroups_Read] FOREIGN KEY([ReadAccessGroupId])
REFERENCES [dbo].[UsersGroups] ([UserGroupId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_UsersGroups_Read]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics] CHECK CONSTRAINT [FK_Topics_UsersGroups_Read]
GO
/****** Object:  ForeignKey [FK_TopicsSubscriptions_Topics]    Script Date: 05/17/2013 14:46:08 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TopicsSubscriptions_Topics]') AND parent_object_id = OBJECT_ID(N'[dbo].[TopicsSubscriptions]'))
ALTER TABLE [dbo].[TopicsSubscriptions]  WITH CHECK ADD  CONSTRAINT [FK_TopicsSubscriptions_Topics] FOREIGN KEY([TopicId])
REFERENCES [dbo].[Topics] ([TopicId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TopicsSubscriptions_Topics]') AND parent_object_id = OBJECT_ID(N'[dbo].[TopicsSubscriptions]'))
ALTER TABLE [dbo].[TopicsSubscriptions] CHECK CONSTRAINT [FK_TopicsSubscriptions_Topics]
GO
/****** Object:  ForeignKey [FK_TopicsSubscriptions_Users]    Script Date: 05/17/2013 14:46:08 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TopicsSubscriptions_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[TopicsSubscriptions]'))
ALTER TABLE [dbo].[TopicsSubscriptions]  WITH CHECK ADD  CONSTRAINT [FK_TopicsSubscriptions_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TopicsSubscriptions_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[TopicsSubscriptions]'))
ALTER TABLE [dbo].[TopicsSubscriptions] CHECK CONSTRAINT [FK_TopicsSubscriptions_Users]
GO
/****** Object:  ForeignKey [FK_Users_UsersGroups]    Script Date: 05/17/2013 14:46:08 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Users_UsersGroups]') AND parent_object_id = OBJECT_ID(N'[dbo].[Users]'))
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_UsersGroups] FOREIGN KEY([UserGroupId])
REFERENCES [dbo].[UsersGroups] ([UserGroupId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Users_UsersGroups]') AND parent_object_id = OBJECT_ID(N'[dbo].[Users]'))
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_UsersGroups]
GO

GO

IF (SELECT COUNT(*) FROM dbo.UsersGroups) = 0
BEGIN
	INSERT INTO dbo.UsersGroups (UserGroupId, UserGroupName) VALUES (1, 'Member')
	INSERT INTO dbo.UsersGroups (UserGroupId, UserGroupName) VALUES (10, 'Admin')
	INSERT INTO dbo.UsersGroups (UserGroupId, UserGroupName) VALUES (2, 'Trusted Member')
	INSERT INTO dbo.UsersGroups (UserGroupId, UserGroupName) VALUES (3, 'Moderator')
END
GO
IF (SELECT COUNT(*) FROM dbo.ForumsCategories) = 0
BEGIN
	INSERT INTO dbo.ForumsCategories (CategoryName, CategoryOrder) VALUES ('General', 1)
END
IF (SELECT COUNT(*) FROM dbo.PageContents) = 0
BEGIN
	INSERT INTO dbo.[PageContents] (PageContentTitle, PageContentShortName, PageContentEditDate, PageContentBody)
		VALUES ('About', 'about', GETUTCDATE(), '
		<p>This forum is powered by <a href="http://www.nearforums.com">Nearforums</a>, an open source forum engine.</p>
		<p>Nearforums is released under <a href="http://nearforums.codeplex.com/license" target="_blank">MIT License</a>, you can get the source at <a href="http://www.nearforums.com/source-code">www.nearforums.com/source-code</a>.</p>');
	INSERT INTO dbo.[PageContents] (PageContentTitle, PageContentShortName, PageContentEditDate, PageContentBody) 
		VALUES ('Terms and conditions', 'terms', GETUTCDATE(),
		'<h2>Legal Notices</h2>  <p>We, the Operators of this Website, provide it as a public service to our users.</p>  <p>Please carefully review the following basic rules that govern your use of the Website. Please note that your use of the Website constitutes your unconditional agreement to follow and be bound by these Terms and Conditions of Use. If you (the "User") do not agree to them, do not use the Website, provide any materials to the Website or download any materials from them.</p>  <p>The Operators reserve the right to update or modify these Terms and Conditions at any time without prior notice to User. Your use of the Website following any such change constitutes your unconditional agreement to follow and be bound by these Terms and Conditions as changed. For this reason, we encourage you to review these Terms and Conditions of Use whenever you use the Website.</p>  <p>These Terms and Conditions of Use apply to the use of the Website and do not extend to any linked third party sites. These Terms and Conditions and our <span>Privacy Policy</span>, which are hereby incorporated by reference, contain the entire agreement (the “Agreement”) between you and the Operators with respect to the Website. Any rights not expressly granted herein are reserved.</p>  <h2><span>Permitted and Prohibited Uses</span></h2>  <p>You may use the the Website for the sole purpose of sharing and exchanging ideas with other Users. You may not use the the Website to violate any applicable local, state, national, or international law, including without limitation any applicable laws relating to antitrust or other illegal trade or business practices, federal and state securities laws, regulations promulgated by the U.S. Securities and Exchange Commission, any rules of any national or other securities exchange, and any U.S. laws, rules, and regulations governing the export and re-export of commodities or technical data.</p>  <p>You may not upload or transmit any material that infringes or misappropriates any person''s copyright, patent, trademark, or trade secret, or disclose via the the Website any information the disclosure of which would constitute a violation of any confidentiality obligations you may have.</p>  <p>You may not upload any viruses, worms, Trojan horses, or other forms of harmful computer code, nor subject the Website''s network or servers to unreasonable traffic loads, or otherwise engage in conduct deemed disruptive to the ordinary operation of the Website.</p>  <p>You are strictly prohibited from communicating on or through the Website any unlawful, harmful, offensive, threatening, abusive, libelous, harassing, defamatory, vulgar, obscene, profane, hateful, fraudulent, sexually explicit, racially, ethnically, or otherwise objectionable material of any sort, including, but not limited to, any material that encourages conduct that would constitute a criminal offense, give rise to civil liability, or otherwise violate any applicable local, state, national, or international law.</p>  <p>You are expressly prohibited from compiling and using other Users'' personal information, including addresses, telephone numbers, fax numbers, email addresses or other contact information that may appear on the Website, for the purpose of creating or compiling marketing and/or mailing lists and from sending other Users unsolicited marketing materials, whether by facsimile, email, or other technological means.</p>  <p>You also are expressly prohibited from distributing Users'' personal information to third-party parties for marketing purposes. The Operators shall deem the compiling of marketing and mailing lists using Users'' personal information, the sending of unsolicited marketing materials to Users, or the distribution of Users'' personal information to third parties for marketing purposes as a material breach of these Terms and Conditions of Use, and the Operators reserve the right to terminate or suspend your access to and use of the Website and to suspend or revoke your membership in the consortium without refund of any membership dues paid.</p>  <p>The Operators note that unauthorized use of Users'' personal information in connection with unsolicited marketing correspondence also may constitute violations of various state and federal anti-spam statutes. The Operators reserve the right to report the abuse of Users'' personal information to the appropriate law enforcement and government authorities, and the Operators will fully cooperate with any authorities investigating violations of these laws.</p>  <h2><span>User Submissions</span></h2>  <p>The Operators do not want to receive confidential or proprietary information from you through the Website. Any material, information, or other communication you transmit or post ("Contributions") to the Website will be considered non-confidential.</p>  <p>All contributions to this site are licensed by you under the MIT License to anyone who wishes to use them, including the Operators.</p>  <p>If you work for a company or at a University, it''s likely that you''re not the copyright holder of anything you make, even in your free time. Before making contributions to this site, get written permission from your employer.</p>  <h2><span>User Discussion Lists and Forums</span></h2>  <p>The Operators may, but are not obligated to, monitor or review any areas on the Website where users transmit or post communications or communicate solely with each other, including but not limited to user forums and email lists, and the content of any such communications. The Operators, however, will have no liability related to the content of any such communications, whether or not arising under the laws of copyright, libel, privacy, obscenity, or otherwise. The Operators may edit or remove content on the the Website at their discretion at any time.</p>  <h2><span>Use of Personally Identifiable Information</span></h2>  <p>Information submitted to the Website is governed according to the Operators’s current <span>Privacy Policy</span> and the stated license of this website.</p>  <p>You agree to provide true, accurate, current, and complete information when registering with the Website. It is your responsibility to maintain and promptly update this account information to keep it true, accurate, current, and complete. If you provides any information that is fraudulent, untrue, inaccurate, incomplete, or not current, or we have reasonable grounds to suspect that such information is fraudulent, untrue, inaccurate, incomplete, or not current, we reserve the right to suspend or terminate your account without notice and to refuse any and all current and future use of the Website.</p>  <p>Although sections of the Website may be viewed simply by visiting the Website, in order to access some Content and/or additional features offered at the Website, you may need to sign on as a guest or register as a member. If you create an account on the Website, you may be asked to supply your name, address, a User ID and password. You are responsible for maintaining the confidentiality of the password and account and are fully responsible for all activities that occur in connection with your password or account. You agree to immediately notify us of any unauthorized use of either your password or account or any other breach of security. You further agree that you will not permit others, including those whose accounts have been terminated, to access the Website using your account or User ID. You grant the Operators and all other persons or entities involved in the operation of the Website the right to transmit, monitor, retrieve, store, and use your information in connection with the operation of the Website and in the provision of services to you. The Operators cannot and do not assume any responsibility or liability for any information you submit, or your or third parties’ use or misuse of information transmitted or received using website. To learn more about how we protect the privacy of the personal information in your account, please visit our<span>Privacy Policy</span>.</p>  <h2><span>Indemnification</span></h2>  <p>You agree to defend, indemnify and hold harmless the Operators, agents, vendors or suppliers from and against any and all claims, damages, costs and expenses, including reasonable attorneys'' fees, arising from or related to your use or misuse of the Website, including, without limitation, your violation of these Terms and Conditions, the infringement by you, or any other subscriber or user of your account, of any intellectual property right or other right of any person or entity.</p>  <h2><span>Termination</span></h2>  <p>These Terms and Conditions of Use are effective until terminated by either party. If you no longer agree to be bound by these Terms and Conditions, you must cease use of the Website. If you are dissatisfied with the Website, their content, or any of these terms, conditions, and policies, your sole legal remedy is to discontinue using the Website. The Operators reserve the right to terminate or suspend your access to and use of the Website, or parts of the Website, without notice, if we believe, in our sole discretion, that such use (i) is in violation of any applicable law; (ii) is harmful to our interests or the interests, including intellectual property or other rights, of another person or entity; or (iii) where the Operators have reason to believe that you are in violation of these Terms and Conditions of Use.</p>  <h2><span>WARRANTY DISCLAIMER</span></h2>  <p>THE WEBSITE AND ASSOCIATED MATERIALS ARE PROVIDED ON AN "AS IS" AND "AS AVAILABLE" BASIS. TO THE FULL EXTENT PERMISSIBLE BY APPLICABLE LAW, THE OPERATORS DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENTOF INTELLECTUAL PROPERTY. THE OPERATORS MAKE NO REPRESENTATIONS OR WARRANTY THAT THE WEBSITE WILL MEET YOUR REQUIREMENTS, OR THAT YOUR USE OF THE WEBSITE WILL BE UNINTERRUPTED, TIMELY, SECURE, OR ERROR FREE; NOR DO THE OPERATORS MAKE ANY REPRESENTATION OR WARRANTY AS TO THE RESULTS THAT MAY BE OBTAINED FROM THE USE OF THE WEBSITE. THE OPERATORS MAKE NO REPRESENTATIONS OR WARRANTIES OF ANY KIND, EXPRESS OR IMPLIED, AS TO THE OPERATION OF THE WEBSITE OR THE INFORMATION, CONTENT, MATERIALS, OR PRODUCTS INCLUDED ON THE WEBSITE.</p>  <p>IN NO EVENT SHALL THE OPERATORS OR ANY OF THEIR AGENTS, VENDORS OR SUPPLIERS BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF PROFITS, BUSINESS INTERRUPTION, LOSS OF INFORMATION) ARISING OUT OF THE USE, MISUSE OF OR INABILITY TO USE THE WEBSITE, EVEN IF THE OPERATORS HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. THIS DISCLAIMER CONSTITUTES AN ESSENTIAL PART OF THIS AGREEMENT. BECAUSE SOME JURISDICTIONS PROHIBIT THE EXCLUSION OR LIMITATION OF LIABILITY FOR CONSEQUENTIAL OR INCIDENTAL DAMAGES, THE ABOVE LIMITATION MAY NOT APPLY TO YOU.</p>  <p>YOU UNDERSTAND AND AGREE THAT ANY CONTENT DOWNLOADED OR OTHERWISE OBTAINED THROUGH THE USE OF THE WEBSITE IS AT YOUR OWN DISCRETION AND RISK AND THAT YOU WILL BE SOLELY RESPONSIBLE FOR ANY DAMAGE TO YOUR COMPUTER SYSTEM OR LOSS OF DATA OR BUSINESS INTERRUPTION THAT RESULTS FROM THE DOWNLOAD OF CONTENT. THE OPERATORS SHALL NOT BE RESPONSIBLE FOR ANY LOSS OR DAMAGE CAUSED, OR ALLEGED TO HAVE BEEN CAUSED, DIRECTLY OR INDIRECTLY, BY THE INFORMATION OR IDEAS CONTAINED, SUGGESTED OR REFERENCED IN OR APPEARING ON THE WEBSITE. YOUR PARTICIPATION IN THE WEBSITE IS SOLELY AT YOUR OWN RISK. NO ADVICE OR INFORMATION, WHETHER ORAL OR WRITTEN, OBTAINED BY YOU FROM THE OPERATORS OR THROUGH THE OPERATORS, THEIR EMPLOYEES, OR THIRD PARTIES SHALL CREATE ANY WARRANTY NOT EXPRESSLY MADE HEREIN. YOU ACKNOWLEDGE, BY YOUR USE OF THE THE WEBSITE, THAT YOUR USE OF THE WEBSITE IS AT YOUR SOLE RISK.</p>  <p>LIABILITY LIMITATION. UNDER NO CIRCUMSTANCES AND UNDER NO LEGAL OR EQUITABLE THEORY, WHETHER IN TORT, CONTRACT, NEGLIGENCE, STRICT LIABILITY OR OTHERWISE, SHALL THE OPERATORS OR ANY OF THEIR AGENTS, VENDORS OR SUPPLIERS BE LIABLE TO USER OR TO ANY OTHER PERSON FOR ANY INDIRECT, SPECIAL, INCIDENTAL OR CONSEQUENTIAL LOSSES OR DAMAGES OF ANY NATURE ARISING OUT OF OR IN CONNECTION WITH THE USE OF OR INABILITY TO USE THE THE WEBSITE OR FOR ANY BREACH OF SECURITY ASSOCIATED WITH THE TRANSMISSION OF SENSITIVE INFORMATION THROUGH THE WEBSITE OR FOR ANY INFORMATION OBTAINED THROUGH THE WEBSITE, INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOST PROFITS, LOSS OF GOODWILL, LOSS OR CORRUPTION OF DATA, WORK STOPPAGE, ACCURACY OF RESULTS, OR COMPUTER FAILURE OR MALFUNCTION, EVEN IF AN AUTHORIZED REPRESENTATIVE OF THE OPERATORS HAS BEEN ADVISED OF OR SHOULD HAVE KNOWN OF THE POSSIBILITY OF SUCH DAMAGES.</p>  <p>THE OPERATORS''S TOTAL CUMULATIVE LIABILITY FOR ANY AND ALL CLAIMS IN CONNECTION WITH THE WEBSITE WILL NOT EXCEED FIVE U.S. DOLLARS ($5.00). USER AGREES AND ACKNOWLEDGES THAT THE FOREGOING LIMITATIONS ON LIABILITY ARE AN ESSENTIAL BASIS OF THE BARGAIN AND THAT THE OPERATORS WOULD NOT PROVIDE THE WEBSITE ABSENT SUCH LIMITATION.</p>  <h2>Links to Other Materials.</h2>  <p>The Website may contain links to sites owned or operated by independent third parties. These links are provided for your convenience and reference only. We do not control such sites and, therefore, we are not responsible for any content posted on these sites. The fact that the Operators offer such links should not be construed in any way as an endorsement, authorization, or sponsorship of that site, its content or the companies or products referenced therein, and the Operators reserve the right to note its lack of affiliation, sponsorship, or endorsement on the Website. If you decide to access any of the third party sites linked to by the Website, you do this entirely at your own risk. Because some sites employ automated search results or otherwise link you to sites containing information that may be deemed inappropriate or offensive, the Operators cannot be held responsible for the accuracy, copyright compliance, legality, or decency of material contained in third party sites, and you hereby irrevocably waive any claim against us with respect to such sites.</p>  <h2><span>Notification Of Possible Copyright Infringement</span></h2>  <p>In the event you believe that material or content published on the Website may infringe on your copyright or that of another, please <span>contact</span> us.</p>');
END
GO

/****** Object:  Table [dbo].[aspnet_Applications]    Script Date: 05/17/2013 15:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Applications]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[aspnet_Applications](
	[ApplicationName] [nvarchar](256) NOT NULL,
	[LoweredApplicationName] [nvarchar](256) NOT NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[Description] [nvarchar](256) NULL,
PRIMARY KEY NONCLUSTERED 
(
	[ApplicationId] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF),
UNIQUE NONCLUSTERED 
(
	[LoweredApplicationName] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF),
UNIQUE NONCLUSTERED 
(
	[ApplicationName] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF)
)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Setup_RemoveAllRoleMembers]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Setup_RemoveAllRoleMembers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[aspnet_Setup_RemoveAllRoleMembers]
    @name   sysname
AS
BEGIN
    CREATE TABLE #aspnet_RoleMembers
    (
        Group_name      sysname,
        Group_id        smallint,
        Users_in_group  sysname,
        User_id         smallint
    )

    INSERT INTO #aspnet_RoleMembers
    EXEC sp_helpuser @name

    DECLARE @user_id smallint
    DECLARE @cmd nvarchar(500)
    DECLARE c1 cursor FORWARD_ONLY FOR
        SELECT User_id FROM #aspnet_RoleMembers

    OPEN c1

    FETCH c1 INTO @user_id
    WHILE (@@fetch_status = 0)
    BEGIN
        SET @cmd = ''EXEC sp_droprolemember '' + '''''''' + @name + '''''', '''''' + USER_NAME(@user_id) + ''''''''
        EXEC (@cmd)
        FETCH c1 INTO @user_id
    END

    CLOSE c1
    DEALLOCATE c1
END
' 
END
GO
/****** Object:  Table [dbo].[aspnet_SchemaVersions]    Script Date: 05/17/2013 15:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_SchemaVersions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[aspnet_SchemaVersions](
	[Feature] [nvarchar](128) NOT NULL,
	[CompatibleSchemaVersion] [nvarchar](128) NOT NULL,
	[IsCurrentVersion] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Feature] ASC,
	[CompatibleSchemaVersion] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF)
)
END
GO
INSERT [dbo].[aspnet_SchemaVersions] ([Feature], [CompatibleSchemaVersion], [IsCurrentVersion]) VALUES (N'common', N'1', 1)
INSERT [dbo].[aspnet_SchemaVersions] ([Feature], [CompatibleSchemaVersion], [IsCurrentVersion]) VALUES (N'membership', N'1', 1)
/****** Object:  View [dbo].[vw_aspnet_Applications]    Script Date: 05/17/2013 15:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_aspnet_Applications]'))
EXEC dbo.sp_executesql @statement = N'
  CREATE VIEW [dbo].[vw_aspnet_Applications]
  AS SELECT [ApplicationName], [LoweredApplicationName], [ApplicationId], [Description]
  FROM [dbo].[aspnet_Applications]
  '
GO
/****** Object:  StoredProcedure [dbo].[aspnet_RegisterSchemaVersion]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_RegisterSchemaVersion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[aspnet_RegisterSchemaVersion]
    @Feature                   nvarchar(128),
    @CompatibleSchemaVersion   nvarchar(128),
    @IsCurrentVersion          bit,
    @RemoveIncompatibleSchema  bit
AS
BEGIN
    IF( @RemoveIncompatibleSchema = 1 )
    BEGIN
        DELETE FROM dbo.aspnet_SchemaVersions WHERE Feature = LOWER( @Feature )
    END
    ELSE
    BEGIN
        IF( @IsCurrentVersion = 1 )
        BEGIN
            UPDATE dbo.aspnet_SchemaVersions
            SET IsCurrentVersion = 0
            WHERE Feature = LOWER( @Feature )
        END
    END

    INSERT  dbo.aspnet_SchemaVersions( Feature, CompatibleSchemaVersion, IsCurrentVersion )
    VALUES( LOWER( @Feature ), @CompatibleSchemaVersion, @IsCurrentVersion )
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_CheckSchemaVersion]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_CheckSchemaVersion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[aspnet_CheckSchemaVersion]
    @Feature                   nvarchar(128),
    @CompatibleSchemaVersion   nvarchar(128)
AS
BEGIN
    IF (EXISTS( SELECT  *
                FROM    dbo.aspnet_SchemaVersions
                WHERE   Feature = LOWER( @Feature ) AND
                        CompatibleSchemaVersion = @CompatibleSchemaVersion ))
        RETURN 0

    RETURN 1
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Applications_CreateApplication]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Applications_CreateApplication]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[aspnet_Applications_CreateApplication]
    @ApplicationName      nvarchar(256),
    @ApplicationId        uniqueidentifier OUTPUT
AS
BEGIN
    SELECT  @ApplicationId = ApplicationId FROM dbo.aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName

    IF(@ApplicationId IS NULL)
    BEGIN
        DECLARE @TranStarted   bit
        SET @TranStarted = 0

        IF( @@TRANCOUNT = 0 )
        BEGIN
	        BEGIN TRANSACTION
	        SET @TranStarted = 1
        END
        ELSE
    	    SET @TranStarted = 0

        SELECT  @ApplicationId = ApplicationId
        FROM dbo.aspnet_Applications
        WHERE LOWER(@ApplicationName) = LoweredApplicationName

        IF(@ApplicationId IS NULL)
        BEGIN
            SELECT  @ApplicationId = NEWID()
            INSERT  dbo.aspnet_Applications (ApplicationId, ApplicationName, LoweredApplicationName)
            VALUES  (@ApplicationId, @ApplicationName, LOWER(@ApplicationName))
        END


        IF( @TranStarted = 1 )
        BEGIN
            IF(@@ERROR = 0)
            BEGIN
	        SET @TranStarted = 0
	        COMMIT TRANSACTION
            END
            ELSE
            BEGIN
                SET @TranStarted = 0
                ROLLBACK TRANSACTION
            END
        END
    END
END
' 
END
GO
/****** Object:  Table [dbo].[aspnet_Users]    Script Date: 05/17/2013 15:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Users]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[aspnet_Users](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[LoweredUserName] [nvarchar](256) NOT NULL,
	[MobileAlias] [nvarchar](16) NULL,
	[IsAnonymous] [bit] NOT NULL,
	[LastActivityDate] [datetime] NOT NULL,
PRIMARY KEY NONCLUSTERED 
(
	[UserId] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF)
)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_UnRegisterSchemaVersion]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_UnRegisterSchemaVersion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[aspnet_UnRegisterSchemaVersion]
    @Feature                   nvarchar(128),
    @CompatibleSchemaVersion   nvarchar(128)
AS
BEGIN
    DELETE FROM dbo.aspnet_SchemaVersions
        WHERE   Feature = LOWER(@Feature) AND @CompatibleSchemaVersion = CompatibleSchemaVersion
END
' 
END
GO
/****** Object:  Table [dbo].[aspnet_Membership]    Script Date: 05/17/2013 15:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Membership]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[aspnet_Membership](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Password] [nvarchar](128) NOT NULL,
	[PasswordFormat] [int] NOT NULL,
	[PasswordSalt] [nvarchar](128) NOT NULL,
	[MobilePIN] [nvarchar](16) NULL,
	[Email] [nvarchar](256) NULL,
	[LoweredEmail] [nvarchar](256) NULL,
	[PasswordQuestion] [nvarchar](256) NULL,
	[PasswordAnswer] [nvarchar](128) NULL,
	[IsApproved] [bit] NOT NULL,
	[IsLockedOut] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastLoginDate] [datetime] NOT NULL,
	[LastPasswordChangedDate] [datetime] NOT NULL,
	[LastLockoutDate] [datetime] NOT NULL,
	[FailedPasswordAttemptCount] [int] NOT NULL,
	[FailedPasswordAttemptWindowStart] [datetime] NOT NULL,
	[FailedPasswordAnswerAttemptCount] [int] NOT NULL,
	[FailedPasswordAnswerAttemptWindowStart] [datetime] NOT NULL,
	[Comment] [ntext] NULL,
PRIMARY KEY NONCLUSTERED 
(
	[UserId] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF)
)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Users_CreateUser]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Users_CreateUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[aspnet_Users_CreateUser]
    @ApplicationId    uniqueidentifier,
    @UserName         nvarchar(256),
    @IsUserAnonymous  bit,
    @LastActivityDate DATETIME,
    @UserId           uniqueidentifier OUTPUT
AS
BEGIN
    IF( @UserId IS NULL )
        SELECT @UserId = NEWID()
    ELSE
    BEGIN
        IF( EXISTS( SELECT UserId FROM dbo.aspnet_Users
                    WHERE @UserId = UserId ) )
            RETURN -1
    END

    INSERT dbo.aspnet_Users (ApplicationId, UserId, UserName, LoweredUserName, IsAnonymous, LastActivityDate)
    VALUES (@ApplicationId, @UserId, @UserName, LOWER(@UserName), @IsUserAnonymous, @LastActivityDate)

    RETURN 0
END
' 
END
GO
/****** Object:  View [dbo].[vw_aspnet_Users]    Script Date: 05/17/2013 15:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_aspnet_Users]'))
EXEC dbo.sp_executesql @statement = N'
  CREATE VIEW [dbo].[vw_aspnet_Users]
  AS SELECT [ApplicationId], [UserId], [UserName], [LoweredUserName], [MobileAlias], [IsAnonymous], [LastActivityDate]
  FROM [dbo].[aspnet_Users]
  '
GO
/****** Object:  View [dbo].[vw_aspnet_MembershipUsers]    Script Date: 05/17/2013 15:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_aspnet_MembershipUsers]'))
EXEC dbo.sp_executesql @statement = N'
  CREATE VIEW [dbo].[vw_aspnet_MembershipUsers]
  AS SELECT members.[UserId],
            members.[PasswordFormat],
            members.[MobilePIN],
            members.[Email],
            members.[LoweredEmail],
            members.[PasswordQuestion],
            members.[PasswordAnswer],
            members.[IsApproved],
            members.[IsLockedOut],
            members.[CreateDate],
            members.[LastLoginDate],
            members.[LastPasswordChangedDate],
            members.[LastLockoutDate],
            members.[FailedPasswordAttemptCount],
            members.[FailedPasswordAttemptWindowStart],
            members.[FailedPasswordAnswerAttemptCount],
            members.[FailedPasswordAnswerAttemptWindowStart],
            members.[Comment],
            users.[ApplicationId],
            users.[UserName],
            users.[MobileAlias],
            users.[IsAnonymous],
            users.[LastActivityDate]
  FROM [dbo].[aspnet_Membership] members INNER JOIN [dbo].[aspnet_Users] users
      ON members.[UserId] = users.[UserId]
  '
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Users_DeleteUser]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Users_DeleteUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[aspnet_Users_DeleteUser]
    @ApplicationName  nvarchar(256),
    @UserName         nvarchar(256),
    @TablesToDeleteFrom int,
    @NumTablesDeletedFrom int OUTPUT
AS
BEGIN
    DECLARE @UserId               uniqueidentifier
    SELECT  @UserId               = NULL
    SELECT  @NumTablesDeletedFrom = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
	SET @TranStarted = 0

    DECLARE @ErrorCode   int
    DECLARE @RowCount    int

    SET @ErrorCode = 0
    SET @RowCount  = 0

    SELECT  @UserId = u.UserId
    FROM    dbo.aspnet_Users u, dbo.aspnet_Applications a
    WHERE   u.LoweredUserName       = LOWER(@UserName)
        AND u.ApplicationId         = a.ApplicationId
        AND LOWER(@ApplicationName) = a.LoweredApplicationName

    IF (@UserId IS NULL)
    BEGIN
        GOTO Cleanup
    END

    -- Delete from Membership table if (@TablesToDeleteFrom & 1) is set
    IF ((@TablesToDeleteFrom & 1) <> 0 AND
        (EXISTS (SELECT name FROM sys.objects WHERE (name = N''vw_aspnet_MembershipUsers'') AND (type = ''V''))))
    BEGIN
        DELETE FROM dbo.aspnet_Membership WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
               @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    -- Delete from aspnet_UsersInRoles table if (@TablesToDeleteFrom & 2) is set
    IF ((@TablesToDeleteFrom & 2) <> 0  AND
        (EXISTS (SELECT name FROM sys.objects WHERE (name = N''vw_aspnet_UsersInRoles'') AND (type = ''V''))) )
    BEGIN
        DELETE FROM dbo.aspnet_UsersInRoles WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
                @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    -- Delete from aspnet_Profile table if (@TablesToDeleteFrom & 4) is set
    IF ((@TablesToDeleteFrom & 4) <> 0  AND
        (EXISTS (SELECT name FROM sys.objects WHERE (name = N''vw_aspnet_Profiles'') AND (type = ''V''))) )
    BEGIN
        DELETE FROM dbo.aspnet_Profile WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
                @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    -- Delete from aspnet_PersonalizationPerUser table if (@TablesToDeleteFrom & 8) is set
    IF ((@TablesToDeleteFrom & 8) <> 0  AND
        (EXISTS (SELECT name FROM sys.objects WHERE (name = N''vw_aspnet_WebPartState_User'') AND (type = ''V''))) )
    BEGIN
        DELETE FROM dbo.aspnet_PersonalizationPerUser WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
                @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    -- Delete from aspnet_Users table if (@TablesToDeleteFrom & 1,2,4 & 8) are all set
    IF ((@TablesToDeleteFrom & 1) <> 0 AND
        (@TablesToDeleteFrom & 2) <> 0 AND
        (@TablesToDeleteFrom & 4) <> 0 AND
        (@TablesToDeleteFrom & 8) <> 0 AND
        (EXISTS (SELECT UserId FROM dbo.aspnet_Users WHERE @UserId = UserId)))
    BEGIN
        DELETE FROM dbo.aspnet_Users WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
                @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    IF( @TranStarted = 1 )
    BEGIN
	    SET @TranStarted = 0
	    COMMIT TRANSACTION
    END

    RETURN 0

Cleanup:
    SET @NumTablesDeletedFrom = 0

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
	    ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_UpdateUserInfo]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Membership_UpdateUserInfo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[aspnet_Membership_UpdateUserInfo]
    @ApplicationName                nvarchar(256),
    @UserName                       nvarchar(256),
    @IsPasswordCorrect              bit,
    @UpdateLastLoginActivityDate    bit,
    @MaxInvalidPasswordAttempts     int,
    @PasswordAttemptWindow          int,
    @CurrentTimeUtc                 datetime,
    @LastLoginDate                  datetime,
    @LastActivityDate               datetime
AS
BEGIN
    DECLARE @UserId                                 uniqueidentifier
    DECLARE @IsApproved                             bit
    DECLARE @IsLockedOut                            bit
    DECLARE @LastLockoutDate                        datetime
    DECLARE @FailedPasswordAttemptCount             int
    DECLARE @FailedPasswordAttemptWindowStart       datetime
    DECLARE @FailedPasswordAnswerAttemptCount       int
    DECLARE @FailedPasswordAnswerAttemptWindowStart datetime

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    SELECT  @UserId = u.UserId,
            @IsApproved = m.IsApproved,
            @IsLockedOut = m.IsLockedOut,
            @LastLockoutDate = m.LastLockoutDate,
            @FailedPasswordAttemptCount = m.FailedPasswordAttemptCount,
            @FailedPasswordAttemptWindowStart = m.FailedPasswordAttemptWindowStart,
            @FailedPasswordAnswerAttemptCount = m.FailedPasswordAnswerAttemptCount,
            @FailedPasswordAnswerAttemptWindowStart = m.FailedPasswordAnswerAttemptWindowStart
    FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
    WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.ApplicationId = a.ApplicationId    AND
            u.UserId = m.UserId AND
            LOWER(@UserName) = u.LoweredUserName

    IF ( @@rowcount = 0 )
    BEGIN
        SET @ErrorCode = 1
        GOTO Cleanup
    END

    IF( @IsLockedOut = 1 )
    BEGIN
        GOTO Cleanup
    END

    IF( @IsPasswordCorrect = 0 )
    BEGIN
        IF( @CurrentTimeUtc > DATEADD( minute, @PasswordAttemptWindow, @FailedPasswordAttemptWindowStart ) )
        BEGIN
            SET @FailedPasswordAttemptWindowStart = @CurrentTimeUtc
            SET @FailedPasswordAttemptCount = 1
        END
        ELSE
        BEGIN
            SET @FailedPasswordAttemptWindowStart = @CurrentTimeUtc
            SET @FailedPasswordAttemptCount = @FailedPasswordAttemptCount + 1
        END

        BEGIN
            IF( @FailedPasswordAttemptCount >= @MaxInvalidPasswordAttempts )
            BEGIN
                SET @IsLockedOut = 1
                SET @LastLockoutDate = @CurrentTimeUtc
            END
        END
    END
    ELSE
    BEGIN
        IF( @FailedPasswordAttemptCount > 0 OR @FailedPasswordAnswerAttemptCount > 0 )
        BEGIN
            SET @FailedPasswordAttemptCount = 0
            SET @FailedPasswordAttemptWindowStart = CONVERT( datetime, ''17540101'', 112 )
            SET @FailedPasswordAnswerAttemptCount = 0
            SET @FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, ''17540101'', 112 )
            SET @LastLockoutDate = CONVERT( datetime, ''17540101'', 112 )
        END
    END

    IF( @UpdateLastLoginActivityDate = 1 )
    BEGIN
        UPDATE  dbo.aspnet_Users
        SET     LastActivityDate = @LastActivityDate
        WHERE   @UserId = UserId

        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END

        UPDATE  dbo.aspnet_Membership
        SET     LastLoginDate = @LastLoginDate
        WHERE   UserId = @UserId

        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END
    END


    UPDATE dbo.aspnet_Membership
    SET IsLockedOut = @IsLockedOut, LastLockoutDate = @LastLockoutDate,
        FailedPasswordAttemptCount = @FailedPasswordAttemptCount,
        FailedPasswordAttemptWindowStart = @FailedPasswordAttemptWindowStart,
        FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount,
        FailedPasswordAnswerAttemptWindowStart = @FailedPasswordAnswerAttemptWindowStart
    WHERE @UserId = UserId

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @TranStarted = 1 )
    BEGIN
	SET @TranStarted = 0
	COMMIT TRANSACTION
    END

    RETURN @ErrorCode

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_UpdateUser]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Membership_UpdateUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[aspnet_Membership_UpdateUser]
    @ApplicationName      nvarchar(256),
    @UserName             nvarchar(256),
    @Email                nvarchar(256),
    @Comment              ntext,
    @IsApproved           bit,
    @LastLoginDate        datetime,
    @LastActivityDate     datetime,
    @UniqueEmail          int,
    @CurrentTimeUtc       datetime
AS
BEGIN
    DECLARE @UserId uniqueidentifier
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @UserId = NULL
    SELECT  @UserId = u.UserId, @ApplicationId = a.ApplicationId
    FROM    dbo.aspnet_Users u, dbo.aspnet_Applications a, dbo.aspnet_Membership m
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId

    IF (@UserId IS NULL)
        RETURN(1)

    IF (@UniqueEmail = 1)
    BEGIN
        IF (EXISTS (SELECT *
                    FROM  dbo.aspnet_Membership
                    WHERE ApplicationId = @ApplicationId  AND @UserId <> UserId AND LoweredEmail = LOWER(@Email)))
        BEGIN
            RETURN(7)
        END
    END

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
	SET @TranStarted = 0

    UPDATE dbo.aspnet_Users
    SET
         LastActivityDate = @LastActivityDate
    WHERE
       @UserId = UserId

    IF( @@ERROR <> 0 )
        GOTO Cleanup

    UPDATE dbo.aspnet_Membership
    SET
         Email            = @Email,
         LoweredEmail     = LOWER(@Email),
         Comment          = @Comment,
         IsApproved       = @IsApproved,
         LastLoginDate    = @LastLoginDate
    WHERE
       @UserId = UserId

    IF( @@ERROR <> 0 )
        GOTO Cleanup

    IF( @TranStarted = 1 )
    BEGIN
	SET @TranStarted = 0
	COMMIT TRANSACTION
    END

    RETURN 0

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN -1
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_UnlockUser]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Membership_UnlockUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[aspnet_Membership_UnlockUser]
    @ApplicationName                         nvarchar(256),
    @UserName                                nvarchar(256)
AS
BEGIN
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL
    SELECT  @UserId = u.UserId
    FROM    dbo.aspnet_Users u, dbo.aspnet_Applications a, dbo.aspnet_Membership m
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId

    IF ( @UserId IS NULL )
        RETURN 1

    UPDATE dbo.aspnet_Membership
    SET IsLockedOut = 0,
        FailedPasswordAttemptCount = 0,
        FailedPasswordAttemptWindowStart = CONVERT( datetime, ''17540101'', 112 ),
        FailedPasswordAnswerAttemptCount = 0,
        FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, ''17540101'', 112 ),
        LastLockoutDate = CONVERT( datetime, ''17540101'', 112 )
    WHERE @UserId = UserId

    RETURN 0
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_SetPassword]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Membership_SetPassword]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[aspnet_Membership_SetPassword]
    @ApplicationName  nvarchar(256),
    @UserName         nvarchar(256),
    @NewPassword      nvarchar(128),
    @PasswordSalt     nvarchar(128),
    @CurrentTimeUtc   datetime,
    @PasswordFormat   int = 0
AS
BEGIN
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL
    SELECT  @UserId = u.UserId
    FROM    dbo.aspnet_Users u, dbo.aspnet_Applications a, dbo.aspnet_Membership m
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId

    IF (@UserId IS NULL)
        RETURN(1)

    UPDATE dbo.aspnet_Membership
    SET Password = @NewPassword, PasswordFormat = @PasswordFormat, PasswordSalt = @PasswordSalt,
        LastPasswordChangedDate = @CurrentTimeUtc
    WHERE @UserId = UserId
    RETURN(0)
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_ResetPassword]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Membership_ResetPassword]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[aspnet_Membership_ResetPassword]
    @ApplicationName             nvarchar(256),
    @UserName                    nvarchar(256),
    @NewPassword                 nvarchar(128),
    @MaxInvalidPasswordAttempts  int,
    @PasswordAttemptWindow       int,
    @PasswordSalt                nvarchar(128),
    @CurrentTimeUtc              datetime,
    @PasswordFormat              int = 0,
    @PasswordAnswer              nvarchar(128) = NULL
AS
BEGIN
    DECLARE @IsLockedOut                            bit
    DECLARE @LastLockoutDate                        datetime
    DECLARE @FailedPasswordAttemptCount             int
    DECLARE @FailedPasswordAttemptWindowStart       datetime
    DECLARE @FailedPasswordAnswerAttemptCount       int
    DECLARE @FailedPasswordAnswerAttemptWindowStart datetime

    DECLARE @UserId                                 uniqueidentifier
    SET     @UserId = NULL

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    SELECT  @UserId = u.UserId
    FROM    dbo.aspnet_Users u, dbo.aspnet_Applications a, dbo.aspnet_Membership m
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId

    IF ( @UserId IS NULL )
    BEGIN
        SET @ErrorCode = 1
        GOTO Cleanup
    END

    SELECT @IsLockedOut = IsLockedOut,
           @LastLockoutDate = LastLockoutDate,
           @FailedPasswordAttemptCount = FailedPasswordAttemptCount,
           @FailedPasswordAttemptWindowStart = FailedPasswordAttemptWindowStart,
           @FailedPasswordAnswerAttemptCount = FailedPasswordAnswerAttemptCount,
           @FailedPasswordAnswerAttemptWindowStart = FailedPasswordAnswerAttemptWindowStart
    FROM dbo.aspnet_Membership
    WHERE @UserId = UserId

    IF( @IsLockedOut = 1 )
    BEGIN
        SET @ErrorCode = 99
        GOTO Cleanup
    END

    UPDATE dbo.aspnet_Membership
    SET    Password = @NewPassword,
           LastPasswordChangedDate = @CurrentTimeUtc,
           PasswordFormat = @PasswordFormat,
           PasswordSalt = @PasswordSalt
    WHERE  @UserId = UserId AND
           ( ( @PasswordAnswer IS NULL ) OR ( LOWER( PasswordAnswer ) = LOWER( @PasswordAnswer ) ) )

    IF ( @@ROWCOUNT = 0 )
        BEGIN
            IF( @CurrentTimeUtc > DATEADD( minute, @PasswordAttemptWindow, @FailedPasswordAnswerAttemptWindowStart ) )
            BEGIN
                SET @FailedPasswordAnswerAttemptWindowStart = @CurrentTimeUtc
                SET @FailedPasswordAnswerAttemptCount = 1
            END
            ELSE
            BEGIN
                SET @FailedPasswordAnswerAttemptWindowStart = @CurrentTimeUtc
                SET @FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount + 1
            END

            BEGIN
                IF( @FailedPasswordAnswerAttemptCount >= @MaxInvalidPasswordAttempts )
                BEGIN
                    SET @IsLockedOut = 1
                    SET @LastLockoutDate = @CurrentTimeUtc
                END
            END

            SET @ErrorCode = 3
        END
    ELSE
        BEGIN
            IF( @FailedPasswordAnswerAttemptCount > 0 )
            BEGIN
                SET @FailedPasswordAnswerAttemptCount = 0
                SET @FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, ''17540101'', 112 )
            END
        END

    IF( NOT ( @PasswordAnswer IS NULL ) )
    BEGIN
        UPDATE dbo.aspnet_Membership
        SET IsLockedOut = @IsLockedOut, LastLockoutDate = @LastLockoutDate,
            FailedPasswordAttemptCount = @FailedPasswordAttemptCount,
            FailedPasswordAttemptWindowStart = @FailedPasswordAttemptWindowStart,
            FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount,
            FailedPasswordAnswerAttemptWindowStart = @FailedPasswordAnswerAttemptWindowStart
        WHERE @UserId = UserId

        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END
    END

    IF( @TranStarted = 1 )
    BEGIN
	SET @TranStarted = 0
	COMMIT TRANSACTION
    END

    RETURN @ErrorCode

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetUserByUserId]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Membership_GetUserByUserId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[aspnet_Membership_GetUserByUserId]
    @UserId               uniqueidentifier,
    @CurrentTimeUtc       datetime,
    @UpdateLastActivity   bit = 0
AS
BEGIN
    IF ( @UpdateLastActivity = 1 )
    BEGIN
        UPDATE   dbo.aspnet_Users
        SET      LastActivityDate = @CurrentTimeUtc
        FROM     dbo.aspnet_Users
        WHERE    @UserId = UserId

        IF ( @@ROWCOUNT = 0 ) -- User ID not found
            RETURN -1
    END

    SELECT  m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
            m.CreateDate, m.LastLoginDate, u.LastActivityDate,
            m.LastPasswordChangedDate, u.UserName, m.IsLockedOut,
            m.LastLockoutDate
    FROM    dbo.aspnet_Users u, dbo.aspnet_Membership m
    WHERE   @UserId = u.UserId AND u.UserId = m.UserId

    IF ( @@ROWCOUNT = 0 ) -- User ID not found
       RETURN -1

    RETURN 0
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetUserByName]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Membership_GetUserByName]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[aspnet_Membership_GetUserByName]
    @ApplicationName      nvarchar(256),
    @UserName             nvarchar(256),
    @CurrentTimeUtc       datetime,
    @UpdateLastActivity   bit = 0
AS
BEGIN
    DECLARE @UserId uniqueidentifier

    IF (@UpdateLastActivity = 1)
    BEGIN
        -- select user ID from aspnet_users table
        SELECT TOP 1 @UserId = u.UserId
        FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE    LOWER(@ApplicationName) = a.LoweredApplicationName AND
                u.ApplicationId = a.ApplicationId    AND
                LOWER(@UserName) = u.LoweredUserName AND u.UserId = m.UserId

        IF (@@ROWCOUNT = 0) -- Username not found
            RETURN -1

        UPDATE   dbo.aspnet_Users
        SET      LastActivityDate = @CurrentTimeUtc
        WHERE    @UserId = UserId

        SELECT m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
                m.CreateDate, m.LastLoginDate, u.LastActivityDate, m.LastPasswordChangedDate,
                u.UserId, m.IsLockedOut, m.LastLockoutDate
        FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE  @UserId = u.UserId AND u.UserId = m.UserId 
    END
    ELSE
    BEGIN
        SELECT TOP 1 m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
                m.CreateDate, m.LastLoginDate, u.LastActivityDate, m.LastPasswordChangedDate,
                u.UserId, m.IsLockedOut,m.LastLockoutDate
        FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE    LOWER(@ApplicationName) = a.LoweredApplicationName AND
                u.ApplicationId = a.ApplicationId    AND
                LOWER(@UserName) = u.LoweredUserName AND u.UserId = m.UserId

        IF (@@ROWCOUNT = 0) -- Username not found
            RETURN -1
    END

    RETURN 0
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetUserByEmail]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Membership_GetUserByEmail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[aspnet_Membership_GetUserByEmail]
    @ApplicationName  nvarchar(256),
    @Email            nvarchar(256)
AS
BEGIN
    IF( @Email IS NULL )
        SELECT  u.UserName
        FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
                u.ApplicationId = a.ApplicationId    AND
                u.UserId = m.UserId AND
                m.LoweredEmail IS NULL
    ELSE
        SELECT  u.UserName
        FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
                u.ApplicationId = a.ApplicationId    AND
                u.UserId = m.UserId AND
                LOWER(@Email) = m.LoweredEmail

    IF (@@rowcount = 0)
        RETURN(1)
    RETURN(0)
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetPasswordWithFormat]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Membership_GetPasswordWithFormat]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[aspnet_Membership_GetPasswordWithFormat]
    @ApplicationName                nvarchar(256),
    @UserName                       nvarchar(256),
    @UpdateLastLoginActivityDate    bit,
    @CurrentTimeUtc                 datetime
AS
BEGIN
    DECLARE @IsLockedOut                        bit
    DECLARE @UserId                             uniqueidentifier
    DECLARE @Password                           nvarchar(128)
    DECLARE @PasswordSalt                       nvarchar(128)
    DECLARE @PasswordFormat                     int
    DECLARE @FailedPasswordAttemptCount         int
    DECLARE @FailedPasswordAnswerAttemptCount   int
    DECLARE @IsApproved                         bit
    DECLARE @LastActivityDate                   datetime
    DECLARE @LastLoginDate                      datetime

    SELECT  @UserId          = NULL

    SELECT  @UserId = u.UserId, @IsLockedOut = m.IsLockedOut, @Password=Password, @PasswordFormat=PasswordFormat,
            @PasswordSalt=PasswordSalt, @FailedPasswordAttemptCount=FailedPasswordAttemptCount,
		    @FailedPasswordAnswerAttemptCount=FailedPasswordAnswerAttemptCount, @IsApproved=IsApproved,
            @LastActivityDate = LastActivityDate, @LastLoginDate = LastLoginDate
    FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
    WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.ApplicationId = a.ApplicationId    AND
            u.UserId = m.UserId AND
            LOWER(@UserName) = u.LoweredUserName

    IF (@UserId IS NULL)
        RETURN 1

    IF (@IsLockedOut = 1)
        RETURN 99

    SELECT   @Password, @PasswordFormat, @PasswordSalt, @FailedPasswordAttemptCount,
             @FailedPasswordAnswerAttemptCount, @IsApproved, @LastLoginDate, @LastActivityDate

    IF (@UpdateLastLoginActivityDate = 1 AND @IsApproved = 1)
    BEGIN
        UPDATE  dbo.aspnet_Membership
        SET     LastLoginDate = @CurrentTimeUtc
        WHERE   UserId = @UserId

        UPDATE  dbo.aspnet_Users
        SET     LastActivityDate = @CurrentTimeUtc
        WHERE   @UserId = UserId
    END


    RETURN 0
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetPassword]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Membership_GetPassword]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[aspnet_Membership_GetPassword]
    @ApplicationName                nvarchar(256),
    @UserName                       nvarchar(256),
    @MaxInvalidPasswordAttempts     int,
    @PasswordAttemptWindow          int,
    @CurrentTimeUtc                 datetime,
    @PasswordAnswer                 nvarchar(128) = NULL
AS
BEGIN
    DECLARE @UserId                                 uniqueidentifier
    DECLARE @PasswordFormat                         int
    DECLARE @Password                               nvarchar(128)
    DECLARE @passAns                                nvarchar(128)
    DECLARE @IsLockedOut                            bit
    DECLARE @LastLockoutDate                        datetime
    DECLARE @FailedPasswordAttemptCount             int
    DECLARE @FailedPasswordAttemptWindowStart       datetime
    DECLARE @FailedPasswordAnswerAttemptCount       int
    DECLARE @FailedPasswordAnswerAttemptWindowStart datetime

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    SELECT  @UserId = u.UserId,
            @Password = m.Password,
            @passAns = m.PasswordAnswer,
            @PasswordFormat = m.PasswordFormat,
            @IsLockedOut = m.IsLockedOut,
            @LastLockoutDate = m.LastLockoutDate,
            @FailedPasswordAttemptCount = m.FailedPasswordAttemptCount,
            @FailedPasswordAttemptWindowStart = m.FailedPasswordAttemptWindowStart,
            @FailedPasswordAnswerAttemptCount = m.FailedPasswordAnswerAttemptCount,
            @FailedPasswordAnswerAttemptWindowStart = m.FailedPasswordAnswerAttemptWindowStart
    FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
    WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.ApplicationId = a.ApplicationId    AND
            u.UserId = m.UserId AND
            LOWER(@UserName) = u.LoweredUserName

    IF ( @@rowcount = 0 )
    BEGIN
        SET @ErrorCode = 1
        GOTO Cleanup
    END

    IF( @IsLockedOut = 1 )
    BEGIN
        SET @ErrorCode = 99
        GOTO Cleanup
    END

    IF ( NOT( @PasswordAnswer IS NULL ) )
    BEGIN
        IF( ( @passAns IS NULL ) OR ( LOWER( @passAns ) <> LOWER( @PasswordAnswer ) ) )
        BEGIN
            IF( @CurrentTimeUtc > DATEADD( minute, @PasswordAttemptWindow, @FailedPasswordAnswerAttemptWindowStart ) )
            BEGIN
                SET @FailedPasswordAnswerAttemptWindowStart = @CurrentTimeUtc
                SET @FailedPasswordAnswerAttemptCount = 1
            END
            ELSE
            BEGIN
                SET @FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount + 1
                SET @FailedPasswordAnswerAttemptWindowStart = @CurrentTimeUtc
            END

            BEGIN
                IF( @FailedPasswordAnswerAttemptCount >= @MaxInvalidPasswordAttempts )
                BEGIN
                    SET @IsLockedOut = 1
                    SET @LastLockoutDate = @CurrentTimeUtc
                END
            END

            SET @ErrorCode = 3
        END
        ELSE
        BEGIN
            IF( @FailedPasswordAnswerAttemptCount > 0 )
            BEGIN
                SET @FailedPasswordAnswerAttemptCount = 0
                SET @FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, ''17540101'', 112 )
            END
        END

        UPDATE dbo.aspnet_Membership
        SET IsLockedOut = @IsLockedOut, LastLockoutDate = @LastLockoutDate,
            FailedPasswordAttemptCount = @FailedPasswordAttemptCount,
            FailedPasswordAttemptWindowStart = @FailedPasswordAttemptWindowStart,
            FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount,
            FailedPasswordAnswerAttemptWindowStart = @FailedPasswordAnswerAttemptWindowStart
        WHERE @UserId = UserId

        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END
    END

    IF( @TranStarted = 1 )
    BEGIN
	SET @TranStarted = 0
	COMMIT TRANSACTION
    END

    IF( @ErrorCode = 0 )
        SELECT @Password, @PasswordFormat

    RETURN @ErrorCode

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetNumberOfUsersOnline]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Membership_GetNumberOfUsersOnline]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[aspnet_Membership_GetNumberOfUsersOnline]
    @ApplicationName            nvarchar(256),
    @MinutesSinceLastInActive   int,
    @CurrentTimeUtc             datetime
AS
BEGIN
    DECLARE @DateActive datetime
    SELECT  @DateActive = DATEADD(minute,  -(@MinutesSinceLastInActive), @CurrentTimeUtc)

    DECLARE @NumOnline int
    SELECT  @NumOnline = COUNT(*)
    FROM    dbo.aspnet_Users u,
            dbo.aspnet_Applications a,
            dbo.aspnet_Membership m
    WHERE   u.ApplicationId = a.ApplicationId                  AND
            LastActivityDate > @DateActive                     AND
            a.LoweredApplicationName = LOWER(@ApplicationName) AND
            u.UserId = m.UserId
    RETURN(@NumOnline)
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetAllUsers]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Membership_GetAllUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[aspnet_Membership_GetAllUsers]
    @ApplicationName       nvarchar(256),
    @PageIndex             int,
    @PageSize              int
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM dbo.aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN 0


    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForUsers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        UserId uniqueidentifier
    )

    -- Insert into our temp table
    INSERT INTO #PageIndexForUsers (UserId)
    SELECT u.UserId
    FROM   dbo.aspnet_Membership m, dbo.aspnet_Users u
    WHERE  u.ApplicationId = @ApplicationId AND u.UserId = m.UserId
    ORDER BY u.UserName

    SELECT @TotalRecords = @@ROWCOUNT

    SELECT u.UserName, m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
            m.CreateDate,
            m.LastLoginDate,
            u.LastActivityDate,
            m.LastPasswordChangedDate,
            u.UserId, m.IsLockedOut,
            m.LastLockoutDate
    FROM   dbo.aspnet_Membership m, dbo.aspnet_Users u, #PageIndexForUsers p
    WHERE  u.UserId = p.UserId AND u.UserId = m.UserId AND
           p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
    ORDER BY u.UserName
    RETURN @TotalRecords
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_FindUsersByName]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Membership_FindUsersByName]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[aspnet_Membership_FindUsersByName]
    @ApplicationName       nvarchar(256),
    @UserNameToMatch       nvarchar(256),
    @PageIndex             int,
    @PageSize              int
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM dbo.aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN 0

    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForUsers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        UserId uniqueidentifier
    )

    -- Insert into our temp table
    INSERT INTO #PageIndexForUsers (UserId)
        SELECT u.UserId
        FROM   dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE  u.ApplicationId = @ApplicationId AND m.UserId = u.UserId AND u.LoweredUserName LIKE LOWER(@UserNameToMatch)
        ORDER BY u.UserName


    SELECT  u.UserName, m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
            m.CreateDate,
            m.LastLoginDate,
            u.LastActivityDate,
            m.LastPasswordChangedDate,
            u.UserId, m.IsLockedOut,
            m.LastLockoutDate
    FROM   dbo.aspnet_Membership m, dbo.aspnet_Users u, #PageIndexForUsers p
    WHERE  u.UserId = p.UserId AND u.UserId = m.UserId AND
           p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
    ORDER BY u.UserName

    SELECT  @TotalRecords = COUNT(*)
    FROM    #PageIndexForUsers
    RETURN @TotalRecords
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_FindUsersByEmail]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Membership_FindUsersByEmail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[aspnet_Membership_FindUsersByEmail]
    @ApplicationName       nvarchar(256),
    @EmailToMatch          nvarchar(256),
    @PageIndex             int,
    @PageSize              int
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM dbo.aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN 0

    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForUsers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        UserId uniqueidentifier
    )

    -- Insert into our temp table
    IF( @EmailToMatch IS NULL )
        INSERT INTO #PageIndexForUsers (UserId)
            SELECT u.UserId
            FROM   dbo.aspnet_Users u, dbo.aspnet_Membership m
            WHERE  u.ApplicationId = @ApplicationId AND m.UserId = u.UserId AND m.Email IS NULL
            ORDER BY m.LoweredEmail
    ELSE
        INSERT INTO #PageIndexForUsers (UserId)
            SELECT u.UserId
            FROM   dbo.aspnet_Users u, dbo.aspnet_Membership m
            WHERE  u.ApplicationId = @ApplicationId AND m.UserId = u.UserId AND m.LoweredEmail LIKE LOWER(@EmailToMatch)
            ORDER BY m.LoweredEmail

    SELECT  u.UserName, m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
            m.CreateDate,
            m.LastLoginDate,
            u.LastActivityDate,
            m.LastPasswordChangedDate,
            u.UserId, m.IsLockedOut,
            m.LastLockoutDate
    FROM   dbo.aspnet_Membership m, dbo.aspnet_Users u, #PageIndexForUsers p
    WHERE  u.UserId = p.UserId AND u.UserId = m.UserId AND
           p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
    ORDER BY m.LoweredEmail

    SELECT  @TotalRecords = COUNT(*)
    FROM    #PageIndexForUsers
    RETURN @TotalRecords
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_CreateUser]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Membership_CreateUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[aspnet_Membership_CreateUser]
    @ApplicationName                        nvarchar(256),
    @UserName                               nvarchar(256),
    @Password                               nvarchar(128),
    @PasswordSalt                           nvarchar(128),
    @Email                                  nvarchar(256),
    @PasswordQuestion                       nvarchar(256),
    @PasswordAnswer                         nvarchar(128),
    @IsApproved                             bit,
    @CurrentTimeUtc                         datetime,
    @CreateDate                             datetime = NULL,
    @UniqueEmail                            int      = 0,
    @PasswordFormat                         int      = 0,
    @UserId                                 uniqueidentifier OUTPUT
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL

    DECLARE @NewUserId uniqueidentifier
    SELECT @NewUserId = NULL

    DECLARE @IsLockedOut bit
    SET @IsLockedOut = 0

    DECLARE @LastLockoutDate  datetime
    SET @LastLockoutDate = CONVERT( datetime, ''17540101'', 112 )

    DECLARE @FailedPasswordAttemptCount int
    SET @FailedPasswordAttemptCount = 0

    DECLARE @FailedPasswordAttemptWindowStart  datetime
    SET @FailedPasswordAttemptWindowStart = CONVERT( datetime, ''17540101'', 112 )

    DECLARE @FailedPasswordAnswerAttemptCount int
    SET @FailedPasswordAnswerAttemptCount = 0

    DECLARE @FailedPasswordAnswerAttemptWindowStart  datetime
    SET @FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, ''17540101'', 112 )

    DECLARE @NewUserCreated bit
    DECLARE @ReturnValue   int
    SET @ReturnValue = 0

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    EXEC dbo.aspnet_Applications_CreateApplication @ApplicationName, @ApplicationId OUTPUT

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    SET @CreateDate = @CurrentTimeUtc

    SELECT  @NewUserId = UserId FROM dbo.aspnet_Users WHERE LOWER(@UserName) = LoweredUserName AND @ApplicationId = ApplicationId
    IF ( @NewUserId IS NULL )
    BEGIN
        SET @NewUserId = @UserId
        EXEC @ReturnValue = dbo.aspnet_Users_CreateUser @ApplicationId, @UserName, 0, @CreateDate, @NewUserId OUTPUT
        SET @NewUserCreated = 1
    END
    ELSE
    BEGIN
        SET @NewUserCreated = 0
        IF( @NewUserId <> @UserId AND @UserId IS NOT NULL )
        BEGIN
            SET @ErrorCode = 6
            GOTO Cleanup
        END
    END

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @ReturnValue = -1 )
    BEGIN
        SET @ErrorCode = 10
        GOTO Cleanup
    END

    IF ( EXISTS ( SELECT UserId
                  FROM   dbo.aspnet_Membership
                  WHERE  @NewUserId = UserId ) )
    BEGIN
        SET @ErrorCode = 6
        GOTO Cleanup
    END

    SET @UserId = @NewUserId

    IF (@UniqueEmail = 1)
    BEGIN
        IF (EXISTS (SELECT *
                    FROM  dbo.aspnet_Membership m
                    WHERE ApplicationId = @ApplicationId AND LoweredEmail = LOWER(@Email)))
        BEGIN
            SET @ErrorCode = 7
            GOTO Cleanup
        END
    END

    IF (@NewUserCreated = 0)
    BEGIN
        UPDATE dbo.aspnet_Users
        SET    LastActivityDate = @CreateDate
        WHERE  @UserId = UserId
        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END
    END

    INSERT INTO dbo.aspnet_Membership
                ( ApplicationId,
                  UserId,
                  Password,
                  PasswordSalt,
                  Email,
                  LoweredEmail,
                  PasswordQuestion,
                  PasswordAnswer,
                  PasswordFormat,
                  IsApproved,
                  IsLockedOut,
                  CreateDate,
                  LastLoginDate,
                  LastPasswordChangedDate,
                  LastLockoutDate,
                  FailedPasswordAttemptCount,
                  FailedPasswordAttemptWindowStart,
                  FailedPasswordAnswerAttemptCount,
                  FailedPasswordAnswerAttemptWindowStart )
         VALUES ( @ApplicationId,
                  @UserId,
                  @Password,
                  @PasswordSalt,
                  @Email,
                  LOWER(@Email),
                  @PasswordQuestion,
                  @PasswordAnswer,
                  @PasswordFormat,
                  @IsApproved,
                  @IsLockedOut,
                  @CreateDate,
                  @CreateDate,
                  @CreateDate,
                  @LastLockoutDate,
                  @FailedPasswordAttemptCount,
                  @FailedPasswordAttemptWindowStart,
                  @FailedPasswordAnswerAttemptCount,
                  @FailedPasswordAnswerAttemptWindowStart )

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @TranStarted = 1 )
    BEGIN
	    SET @TranStarted = 0
	    COMMIT TRANSACTION
    END

    RETURN 0

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_ChangePasswordQuestionAndAnswer]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_Membership_ChangePasswordQuestionAndAnswer]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[aspnet_Membership_ChangePasswordQuestionAndAnswer]
    @ApplicationName       nvarchar(256),
    @UserName              nvarchar(256),
    @NewPasswordQuestion   nvarchar(256),
    @NewPasswordAnswer     nvarchar(128)
AS
BEGIN
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL
    SELECT  @UserId = u.UserId
    FROM    dbo.aspnet_Membership m, dbo.aspnet_Users u, dbo.aspnet_Applications a
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId
    IF (@UserId IS NULL)
    BEGIN
        RETURN(1)
    END

    UPDATE dbo.aspnet_Membership
    SET    PasswordQuestion = @NewPasswordQuestion, PasswordAnswer = @NewPasswordAnswer
    WHERE  UserId=@UserId
    RETURN(0)
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_AnyDataInTables]    Script Date: 05/17/2013 15:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aspnet_AnyDataInTables]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[aspnet_AnyDataInTables]
    @TablesToCheck int
AS
BEGIN
    -- Check Membership table if (@TablesToCheck & 1) is set
    IF ((@TablesToCheck & 1) <> 0 AND
        (EXISTS (SELECT name FROM sys.objects WHERE (name = N''vw_aspnet_MembershipUsers'') AND (type = ''V''))))
    BEGIN
        IF (EXISTS(SELECT TOP 1 UserId FROM dbo.aspnet_Membership))
        BEGIN
            SELECT N''aspnet_Membership''
            RETURN
        END
    END

    -- Check aspnet_Roles table if (@TablesToCheck & 2) is set
    IF ((@TablesToCheck & 2) <> 0  AND
        (EXISTS (SELECT name FROM sys.objects WHERE (name = N''vw_aspnet_Roles'') AND (type = ''V''))) )
    BEGIN
        IF (EXISTS(SELECT TOP 1 RoleId FROM dbo.aspnet_Roles))
        BEGIN
            SELECT N''aspnet_Roles''
            RETURN
        END
    END

    -- Check aspnet_Profile table if (@TablesToCheck & 4) is set
    IF ((@TablesToCheck & 4) <> 0  AND
        (EXISTS (SELECT name FROM sys.objects WHERE (name = N''vw_aspnet_Profiles'') AND (type = ''V''))) )
    BEGIN
        IF (EXISTS(SELECT TOP 1 UserId FROM dbo.aspnet_Profile))
        BEGIN
            SELECT N''aspnet_Profile''
            RETURN
        END
    END

    -- Check aspnet_PersonalizationPerUser table if (@TablesToCheck & 8) is set
    IF ((@TablesToCheck & 8) <> 0  AND
        (EXISTS (SELECT name FROM sys.objects WHERE (name = N''vw_aspnet_WebPartState_User'') AND (type = ''V''))) )
    BEGIN
        IF (EXISTS(SELECT TOP 1 UserId FROM dbo.aspnet_PersonalizationPerUser))
        BEGIN
            SELECT N''aspnet_PersonalizationPerUser''
            RETURN
        END
    END

    -- Check aspnet_PersonalizationPerUser table if (@TablesToCheck & 16) is set
    IF ((@TablesToCheck & 16) <> 0  AND
        (EXISTS (SELECT name FROM sys.objects WHERE (name = N''aspnet_WebEvent_LogEvent'') AND (type = ''P''))) )
    BEGIN
        IF (EXISTS(SELECT TOP 1 * FROM dbo.aspnet_WebEvent_Events))
        BEGIN
            SELECT N''aspnet_WebEvent_Events''
            RETURN
        END
    END

    -- Check aspnet_Users table if (@TablesToCheck & 1,2,4 & 8) are all set
    IF ((@TablesToCheck & 1) <> 0 AND
        (@TablesToCheck & 2) <> 0 AND
        (@TablesToCheck & 4) <> 0 AND
        (@TablesToCheck & 8) <> 0 AND
        (@TablesToCheck & 32) <> 0 AND
        (@TablesToCheck & 128) <> 0 AND
        (@TablesToCheck & 256) <> 0 AND
        (@TablesToCheck & 512) <> 0 AND
        (@TablesToCheck & 1024) <> 0)
    BEGIN
        IF (EXISTS(SELECT TOP 1 UserId FROM dbo.aspnet_Users))
        BEGIN
            SELECT N''aspnet_Users''
            RETURN
        END
        IF (EXISTS(SELECT TOP 1 ApplicationId FROM dbo.aspnet_Applications))
        BEGIN
            SELECT N''aspnet_Applications''
            RETURN
        END
    END
END
' 
END
GO
/****** Object:  Default [DF__aspnet_Ap__Appli__07F6335A]    Script Date: 05/17/2013 15:01:50 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__aspnet_Ap__Appli__07F6335A]') AND parent_object_id = OBJECT_ID(N'[dbo].[aspnet_Applications]'))
Begin
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DF__aspnet_Ap__Appli__07F6335A]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[aspnet_Applications] ADD  DEFAULT (newid()) FOR [ApplicationId]
END


End
GO
/****** Object:  Default [DF__aspnet_Me__Passw__22AA2996]    Script Date: 05/17/2013 15:01:50 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__aspnet_Me__Passw__22AA2996]') AND parent_object_id = OBJECT_ID(N'[dbo].[aspnet_Membership]'))
Begin
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DF__aspnet_Me__Passw__22AA2996]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[aspnet_Membership] ADD  DEFAULT ((0)) FOR [PasswordFormat]
END


End
GO
/****** Object:  Default [DF__aspnet_Us__UserI__0DAF0CB0]    Script Date: 05/17/2013 15:01:50 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__aspnet_Us__UserI__0DAF0CB0]') AND parent_object_id = OBJECT_ID(N'[dbo].[aspnet_Users]'))
Begin
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DF__aspnet_Us__UserI__0DAF0CB0]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[aspnet_Users] ADD  DEFAULT (newid()) FOR [UserId]
END


End
GO
/****** Object:  Default [DF__aspnet_Us__Mobil__0EA330E9]    Script Date: 05/17/2013 15:01:50 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__aspnet_Us__Mobil__0EA330E9]') AND parent_object_id = OBJECT_ID(N'[dbo].[aspnet_Users]'))
Begin
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DF__aspnet_Us__Mobil__0EA330E9]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[aspnet_Users] ADD  DEFAULT (NULL) FOR [MobileAlias]
END


End
GO
/****** Object:  Default [DF__aspnet_Us__IsAno__0F975522]    Script Date: 05/17/2013 15:01:50 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__aspnet_Us__IsAno__0F975522]') AND parent_object_id = OBJECT_ID(N'[dbo].[aspnet_Users]'))
Begin
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DF__aspnet_Us__IsAno__0F975522]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[aspnet_Users] ADD  DEFAULT ((0)) FOR [IsAnonymous]
END


End
GO
/****** Object:  ForeignKey [FK__aspnet_Me__Appli__20C1E124]    Script Date: 05/17/2013 15:01:50 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__aspnet_Me__Appli__20C1E124]') AND parent_object_id = OBJECT_ID(N'[dbo].[aspnet_Membership]'))
ALTER TABLE [dbo].[aspnet_Membership]  WITH CHECK ADD FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO
/****** Object:  ForeignKey [FK__aspnet_Me__UserI__21B6055D]    Script Date: 05/17/2013 15:01:50 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__aspnet_Me__UserI__21B6055D]') AND parent_object_id = OBJECT_ID(N'[dbo].[aspnet_Membership]'))
ALTER TABLE [dbo].[aspnet_Membership]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[aspnet_Users] ([UserId])
GO
/****** Object:  ForeignKey [FK__aspnet_Us__Appli__0CBAE877]    Script Date: 05/17/2013 15:01:50 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__aspnet_Us__Appli__0CBAE877]') AND parent_object_id = OBJECT_ID(N'[dbo].[aspnet_Users]'))
ALTER TABLE [dbo].[aspnet_Users]  WITH CHECK ADD FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO
