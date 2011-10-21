IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IX_Topics_ForumId_Active')
    DROP INDEX IX_Topics_ForumId_Active ON Topics ;
GO
CREATE NONCLUSTERED INDEX IX_Topics_ForumId_Active
    ON Topics (Active DESC, ForumId);
GO