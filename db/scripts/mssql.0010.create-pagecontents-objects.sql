IF EXISTS(SELECT * FROM [dbo].[sysobjects]
	WHERE ID = object_id(N'[dbo].[PageContents]') 
	AND xtype in ('U', 'P', 'IF', 'V'))
	DROP TABLE PageContents;

GO

CREATE TABLE [dbo].[PageContents](
	[PageContentId] [int] IDENTITY(1,1) NOT NULL,
	[PageContentTitle] [varchar](128) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[PageContentBody] [varchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[PageContentShortName] [varchar](128) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[PageContentEditDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PageContents] PRIMARY KEY CLUSTERED 
(
	[PageContentId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO

IF EXISTS(SELECT * FROM [dbo].[sysobjects]
	WHERE ID = object_id(N'[dbo].[SPPageContentsDelete]') 
	AND xtype in ('U', 'P', 'IF', 'V'))
	DROP PROCEDURE SPPageContentsDelete;
GO

CREATE PROCEDURE [dbo].[SPPageContentsDelete]
	@PageContentShortName varchar(128)
AS
DELETE FROM PageContents 
WHERE
	PageContentShortName = @PageContentShortName

GO

IF EXISTS(SELECT * FROM [dbo].[sysobjects]
	WHERE ID = object_id(N'[dbo].[SPPageContentsGet]') 
	AND xtype in ('U', 'P', 'IF', 'V'))
	DROP PROCEDURE SPPageContentsGet;
GO

CREATE PROCEDURE [dbo].[SPPageContentsGet]
	@PageContentShortName varchar(128)='about'
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

IF EXISTS(SELECT * FROM [dbo].[sysobjects]
	WHERE ID = object_id(N'[dbo].[SPPageContentsGetAll]') 
	AND xtype in ('U', 'P', 'IF', 'V'))
	DROP PROCEDURE SPPageContentsGetAll;
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

IF EXISTS(SELECT * FROM [dbo].[sysobjects]
	WHERE ID = object_id(N'[dbo].[SPPageContentsGetUsedShortNames]') 
	AND xtype in ('U', 'P', 'IF', 'V'))
	DROP PROCEDURE SPPageContentsGetUsedShortNames;
GO

CREATE PROCEDURE [dbo].[SPPageContentsGetUsedShortNames]
(
	@PageContentShortName varchar(32), 
	@SearchShortName varchar(32)
)
AS
/*
	Gets used short names for PageContents
	returns:
		IF NOT USED SHORTNAME: empty result set
		IF USED SHORTNAME: resultset with amount of rows used
*/
DECLARE @CurrentValue varchar(32)
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

IF EXISTS(SELECT * FROM [dbo].[sysobjects]
	WHERE ID = object_id(N'[dbo].[SPPageContentsInsert]') 
	AND xtype in ('U', 'P', 'IF', 'V'))
	DROP PROCEDURE SPPageContentsInsert;
GO

CREATE PROCEDURE [dbo].[SPPageContentsInsert]
	@PageContentShortName varchar(128)
	,@PageContentTitle varchar(128)
	,@PageContentBody varchar(max)
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

IF EXISTS(SELECT * FROM [dbo].[sysobjects]
	WHERE ID = object_id(N'[dbo].[SPPageContentsUpdate]') 
	AND xtype in ('U', 'P', 'IF', 'V'))
	DROP PROCEDURE SPPageContentsUpdate;
GO

CREATE PROCEDURE [dbo].[SPPageContentsUpdate]
	@PageContentShortName varchar(128)
	,@PageContentTitle varchar(128)
	,@PageContentBody varchar(max)
AS
UPDATE PageContents 
SET
	PageContentTitle = @PageContentTitle
	,PageContentBody = @PageContentBody
	,PageContentEditDate = GETUTCDATE()
WHERE
	PageContentShortName = @PageContentShortName
