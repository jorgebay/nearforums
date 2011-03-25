select '/*030*/ IF (SELECT COUNT(*) FROM dbo.UsersGroups) = 0'
UNION
select '/*040*/ BEGIN'
UNION
select '/*050*/ INSERT INTO dbo.UsersGroups (UserGroupId, UserGroupName) VALUES (' + CONVERT(varchar,UserGroupId) + ', ''' + UserGroupName + ''')' from usersgroups
UNION
select '/*055*/ END'
UNION
SELECT '/*060*/ GO'
UNION
select '/*070*/ IF (SELECT COUNT(*) FROM dbo.ForumsCategories) = 0'
UNION
select '/*080*/ BEGIN'
UNION
SELECT '/*090*/ INSERT INTO dbo.ForumsCategories (CategoryName, CategoryOrder) VALUES (''General'', 1)'
UNION
SELECT '/*100*/ END'