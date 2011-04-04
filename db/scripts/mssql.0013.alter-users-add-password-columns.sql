BEGIN TRY
    ALTER TABLE	dbo.[Users] DROP COLUMN PasswordResetGuid;
END TRY
BEGIN CATCH
    -- Execute error retrieval routine.
END CATCH;
BEGIN TRY
    ALTER TABLE	dbo.[Users] DROP COLUMN PasswordResetGuidExpireDate;
END TRY
BEGIN CATCH
    -- Execute error retrieval routine.
END CATCH;
GO
ALTER TABLE	dbo.[Users] ADD PasswordResetGuid varchar(100) null
GO
ALTER TABLE	dbo.[Users] ADD PasswordResetGuidExpireDate datetime null
