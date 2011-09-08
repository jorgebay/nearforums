/****** Object:  StoredProcedure [dbo].[SPTopicsGetByTag]    Script Date: 09/08/2011 13:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SPTopicsGetByTag]
	@Tag varchar(50)='forum',
	@ForumId int=2
AS

--Remove the last char
SET @Tag = SUBSTRING(@Tag, 1, LEN(@Tag)-1)
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
	Tags
	INNER JOIN TopicsComplete T ON T.TopicId = Tags.TopicId
	LEFT JOIN Messages M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
	LEFT JOIN Users MU ON MU.UserId = M.UserId
WHERE
	Tags.Tag LIKE @Tag + '%'
	AND
	T.ForumId = @ForumId
ORDER BY TopicOrder DESC,TopicViews DESC