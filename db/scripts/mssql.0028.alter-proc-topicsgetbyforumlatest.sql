/****** Object:  StoredProcedure [dbo].[SPTopicsGetByForumLatest]    Script Date: 10/21/2011 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
				(ORDER BY TopicOrder desc
				 ,
				 (CASE 
					WHEN M.MessageCreationDate > T.TopicCreationDate THEN M.MessageCreationDate
					ELSE T.TopicCreationDate
				END) desc)
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