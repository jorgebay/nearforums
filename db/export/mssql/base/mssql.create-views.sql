SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[TopicsComplete]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[TopicsComplete] 
AS
SELECT
		T.TopicId
		,T.TopicTitle
		,T.TopicShortName
		,T.TopicDescription
		,T.TopicCreationDate
		,T.TopicViews
		,T.TopicReplies
		,T.UserId
		,T.TopicTags
		,T.TopicIsClose
		,T.TopicOrder
		,T.LastMessageId
		,U.UserName
		,F.ForumId
		,F.ForumName
		,F.ForumShortName
	FROM
		Topics T
		INNER JOIN Users U ON U.UserId = T.UserId
		INNER JOIN Forums F ON F.ForumId = T.ForumId
	WHERE
		T.Active = 1
		AND
		F.Active = 1' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[MessagesComplete]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[MessagesComplete]
AS
SELECT
	
	M.TopicId
	,M.MessageId
	,M.MessageBody
	,M.MessageCreationDate
	,M.MessageLastEditDate
	,M.ParentId
	,M.UserId
	,M.Active
	,U.UserName
	,U.UserSignature
	,U.UserGroupId
	,G.UserGroupName
FROM
	dbo.Messages M
	INNER JOIN dbo.Users U ON U.UserId = M.UserId
	INNER JOIN dbo.UsersGroups G ON G.UserGroupId = U.UserGroupId
	LEFT JOIN dbo.Messages P ON P.TopicId = M.TopicId AND P.MessageId = M.ParentId AND P.Active = 1' 
