GO
IF (SELECT COUNT(*) FROM dbo.UsersGroups) = 0
BEGIN
	INSERT INTO dbo.UsersGroups (UserGroupId, UserGroupName) VALUES (1, 'Level 1')
	INSERT INTO dbo.UsersGroups (UserGroupId, UserGroupName) VALUES (10, 'Admin')
	INSERT INTO dbo.UsersGroups (UserGroupId, UserGroupName) VALUES (2, 'Level2')
	INSERT INTO dbo.UsersGroups (UserGroupId, UserGroupName) VALUES (3, 'Moderator')
END
GO
IF (SELECT COUNT(*) FROM dbo.ForumsCategories) = 0
BEGIN
	INSERT INTO dbo.ForumsCategories (CategoryName, CategoryOrder) VALUES ('General', 1)
END
IF (SELECT COUNT(*) FROM dbo.PageContents) = 0
BEGIN
	INSERT INTO dbo.[PageContents] (PageContentTitle, PageContentShortName, PageContentEditDate, PageContentBody)
		VALUES ('About', 'about', GETUTCDATE(), '
		<p>This forum is powered by <a href="http://www.nearforums.com">Nearforums</a>, an open source forum engine.</p>
		<p>Nearforums is released under <a href="http://nearforums.codeplex.com/license" target="_blank">MIT License</a>, you can get the source at <a href="http://www.nearforums.com/source-code">www.nearforums.com/source-code</a>.</p>')
	INSERT INTO dbo.[PageContents] (PageContentTitle, PageContentShortName, PageContentEditDate, PageContentBody)
		VALUES ('About', 'about', GETUTCDATE(), '
		<p>This forum is powered by <a href="http://www.nearforums.com">Nearforums</a>, an open source forum engine.</p>
		<p>Nearforums is released under <a href="http://nearforums.codeplex.com/license" target="_blank">MIT License</a>, you can get the source at <a href="http://www.nearforums.com/source-code">www.nearforums.com/source-code</a>.</p>')
END
GO
