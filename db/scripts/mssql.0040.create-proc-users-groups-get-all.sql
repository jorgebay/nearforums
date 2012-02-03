IF EXISTS(SELECT * FROM [dbo].[sysobjects]
	WHERE ID = object_id(N'[dbo].[SPUsersGroupsGetAll]') 
	AND xtype in ('U', 'P', 'IF', 'V'))
	DROP PROCEDURE [SPUsersGroupsGetAll];
GO

CREATE PROCEDURE [dbo].[SPUsersGroupsGetAll]
	
AS
SELECT 
	UserGroupId
	,UserGroupName
FROM
	UsersGroups
ORDER BY 
	UserGroupId asc