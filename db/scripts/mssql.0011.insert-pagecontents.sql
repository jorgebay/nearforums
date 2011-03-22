DELETE FROM dbo.[PageContents]
INSERT INTO dbo.[PageContents] (PageContentTitle, PageContentShortName, PageContentEditDate, PageContentBody)
	VALUES ('About', 'about', GETUTCDATE(), '
	<p>This forum is powered by <a href="http://www.nearforums.com">Nearforums</a>, an open source forum engine.</p>
	<p>Nearforums is released under <a href="http://nearforums.codeplex.com/license" target="_blank">MIT License</a>, you can get the source at <a href="http://www.nearforums.com/source-code">www.nearforums.com/source-code</a>.</p>')