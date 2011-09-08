
ALTER PROCEDURE [dbo].[SPTopicsGetByForumLatest]
	@ForumId int = 2
	,@StartIndex int = 0
	,@Length int = 10
AS
SELECT
	*
FROM
	(SELECT
		ROW_NUMBER()
			OVER 
				(ORDER BY T.TopicId desc)
			AS RowNumber
		,T.TopicId
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
	) T
WHERE
	RowNumber BETWEEN @StartIndex+1 AND @StartIndex + @Length