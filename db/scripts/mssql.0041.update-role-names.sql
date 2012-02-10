UPDATE dbo.UsersGroups
SET
	UserGroupName = 'Member'
WHERE
	UserGroupId = 1;

UPDATE dbo.UsersGroups
SET
	UserGroupName = 'Trusted member'
WHERE
	UserGroupId = 2;
