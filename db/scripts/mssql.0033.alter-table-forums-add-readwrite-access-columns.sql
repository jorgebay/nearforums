BEGIN TRY
    ALTER TABLE	dbo.Forums DROP CONSTRAINT FK_Forums_UsersGroups_Read;
    ALTER TABLE	dbo.Forums DROP COLUMN ReadAccessGroupId;
END TRY
BEGIN CATCH
    -- The column and fk does not exist: do nothing
END CATCH;
BEGIN TRY
    ALTER TABLE	dbo.Forums DROP CONSTRAINT FK_Forums_UsersGroups_Post;
    ALTER TABLE	dbo.Forums DROP COLUMN PostAccessGroupId;
END TRY
BEGIN CATCH
    -- The column and fk does not exist: do nothing
END CATCH;
GO
ALTER TABLE	dbo.Forums ADD ReadAccessGroupId SMALLINT NULL
GO
ALTER TABLE	dbo.Forums ADD PostAccessGroupId SMALLINT NULL
GO

ALTER TABLE dbo.Forums  WITH CHECK ADD  CONSTRAINT FK_Forums_UsersGroups_Read FOREIGN KEY(ReadAccessGroupId)
	REFERENCES dbo.UsersGroups (UserGroupId)
ALTER TABLE dbo.Forums  WITH CHECK ADD  CONSTRAINT FK_Forums_UsersGroups_Post FOREIGN KEY(PostAccessGroupId)
	REFERENCES dbo.UsersGroups (UserGroupId)
GO

UPDATE Forums 
	SET PostAccessGroupId = 1;
GO

ALTER TABLE	dbo.Forums ALTER COLUMN PostAccessGroupId SMALLINT NOT NULL;