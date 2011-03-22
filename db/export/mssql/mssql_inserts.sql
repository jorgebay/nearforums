/*030*/ IF (SELECT COUNT(*) FROM dbo.UsersGroups) = 0
/*040*/ BEGIN
/*050*/ INSERT INTO dbo.UsersGroups (UserGroupId, UserGroupName) VALUES (1, 'Level 1')
/*050*/ INSERT INTO dbo.UsersGroups (UserGroupId, UserGroupName) VALUES (10, 'Admin')
/*050*/ INSERT INTO dbo.UsersGroups (UserGroupId, UserGroupName) VALUES (2, 'Level2')
/*050*/ INSERT INTO dbo.UsersGroups (UserGroupId, UserGroupName) VALUES (3, 'Moderator')
/*055*/ END
/*060*/ GO
/*070*/ IF (SELECT COUNT(*) FROM dbo.ForumsCategories) = 0
/*080*/ BEGIN
/*090*/ INSERT INTO dbo.ForumsCategories (CategoryName, CategoryOrder) VALUES ('General', 1)
/*100*/ END