GO
IF EXISTS(SELECT * FROM [dbo].[sysobjects]
	WHERE ID = object_id(N'[dbo].[SPForumsCategoriesDelete]') 
	AND xtype in ('P'))
	DROP PROCEDURE SPForumsCategoriesDelete;
GO
CREATE PROCEDURE [dbo].[SPForumsCategoriesDelete]
	@categoryId int
AS
BEGIN
	DELETE FROM ForumsCategories WHERE CategoryId = @categoryId
END

GO
/****** Object:  StoredProcedure [dbo].[SPForumsCategoriesGet]    Script Date: 4/7/2013 9:41:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS(SELECT * FROM [dbo].[sysobjects]
	WHERE ID = object_id(N'[dbo].[SPForumsCategoriesGet]') 
	AND xtype in ('P'))
	DROP PROCEDURE SPForumsCategoriesGet;
GO
CREATE PROCEDURE [dbo].[SPForumsCategoriesGet] 
	@CategoryId int
AS
BEGIN
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM ForumsCategories WHERE CategoryId = @CategoryId
END

GO
/****** Object:  StoredProcedure [dbo].[SPForumsCategoriesGetForumsCountPerCategory]    Script Date: 4/7/2013 9:41:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS(SELECT * FROM [dbo].[sysobjects]
	WHERE ID = object_id(N'[dbo].[SPForumsCategoriesGetForumsCountPerCategory]') 
	AND xtype in ('P'))
	DROP PROCEDURE SPForumsCategoriesGetForumsCountPerCategory;
GO
CREATE PROCEDURE [dbo].[SPForumsCategoriesGetForumsCountPerCategory] 
	@CategoryId int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  count(*) as NoofForums FROM Forums WHERE CategoryId = @CategoryId 
END

GO
/****** Object:  StoredProcedure [dbo].[SPForumsCategoriesInsert]    Script Date: 4/7/2013 9:41:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS(SELECT * FROM [dbo].[sysobjects]
	WHERE ID = object_id(N'[dbo].[SPForumsCategoriesInsert]') 
	AND xtype in ('P'))
	DROP PROCEDURE SPForumsCategoriesInsert;
GO
CREATE PROCEDURE [dbo].[SPForumsCategoriesInsert] 
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
END

GO
/****** Object:  StoredProcedure [dbo].[SPForumsCategoriesUpdate]    Script Date: 4/7/2013 9:41:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS(SELECT * FROM [dbo].[sysobjects]
	WHERE ID = object_id(N'[dbo].[SPForumsCategoriesUpdate]') 
	AND xtype in ('P'))
	DROP PROCEDURE SPForumsCategoriesUpdate;
GO
CREATE PROCEDURE [dbo].[SPForumsCategoriesUpdate] 
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

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
