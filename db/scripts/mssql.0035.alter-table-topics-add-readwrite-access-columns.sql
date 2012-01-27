BEGIN TRY
    ALTER TABLE	dbo.Topics DROP CONSTRAINT FK_Topics_UsersGroups_Read;
    ALTER TABLE	dbo.Topics DROP COLUMN ReadAccessGroupId;
END TRY
BEGIN CATCH
    -- The column and fk does not exist: do nothing
END CATCH;
BEGIN TRY
    ALTER TABLE	dbo.Topics DROP CONSTRAINT FK_Topics_UsersGroups_Post;
    ALTER TABLE	dbo.Topics DROP COLUMN PostAccessGroupId;
END TRY
BEGIN CATCH
    -- The column and fk does not exist: do nothing
END CATCH;
GO
ALTER TABLE	dbo.Topics ADD ReadAccessGroupId SMALLINT NULL
GO
ALTER TABLE	dbo.Topics ADD PostAccessGroupId SMALLINT NULL
GO

ALTER TABLE dbo.Topics  WITH CHECK ADD CONSTRAINT FK_Topics_UsersGroups_Read FOREIGN KEY(ReadAccessGroupId)
	REFERENCES dbo.UsersGroups (UserGroupId)
ALTER TABLE dbo.Topics  WITH CHECK ADD CONSTRAINT FK_Topics_UsersGroups_Post FOREIGN KEY(PostAccessGroupId)
	REFERENCES dbo.UsersGroups (UserGroupId)
GO

UPDATE Topics 
	SET PostAccessGroupId = 1;
GO

ALTER TABLE	dbo.Topics ALTER COLUMN PostAccessGroupId SMALLINT NOT NULL;