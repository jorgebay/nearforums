select '/*1*/INSERT INTO dbo.UsersGroups (UserGroupId, UserGroupName) VALUES (' + CONVERT(varchar,UserGroupId) + ', ''' + UserGroupName + ''')' from usersgroups
UNION
SELECT '/*2*/GO'
UNION
SELECT '/*3*/INSERT INTO dbo.ForumsCategories (CategoryName, CategoryOrder) VALUES (''General'', 1)'