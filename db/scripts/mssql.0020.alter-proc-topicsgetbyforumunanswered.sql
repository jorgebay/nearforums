/****** Object:  StoredProcedure [dbo].[SPTopicsGetByForumUnanswered]    Script Date: 09/08/2011 13:11:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SPTopicsGetByForumUnanswered]
	@ForumId int = 2
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
	,T.UserName
	,M.MessageCreationDate
	,M.UserId AS MessageUserId
	,MU.UserName AS MessageUserName
FROM
	TopicsComplete T
	LEFT JOIN Messages M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
	LEFT JOIN Users MU ON MU.UserId = M.UserId
WHERE
	T.ForumId = @ForumId
	AND
	T.TopicReplies = 0 -- Unanswered
	AND
	T.TopicOrder IS NULL -- Not sticky	
ORDER BY 
	TopicViews DESC, TopicId DESC