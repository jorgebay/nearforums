ALTER TABLE	dbo.[Messages] DROP COLUMN MessageLastEditUser
GO
ALTER TABLE	dbo.[Messages] ADD MessageLastEditUser int null
GO
UPDATE dbo.[Messages] SET MessageLastEditUser = 1
GO
ALTER TABLE	dbo.[Messages] ALTER COLUMN MessageLastEditUser int not null