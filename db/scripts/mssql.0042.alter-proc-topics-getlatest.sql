ALTER PROCEDURE [dbo].[SPTopicsGetLatest]
	@UserGroupId int = null
AS
/*
	Gets the latest messages in all forums	
*/
	SELECT
		TOP 20
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
	FROM
		TopicsComplete T
		LEFT JOIN Messages M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
	WHERE
		ISNULL(T.ReadAccessGroupId,-1) <= ISNULL(@UserGroupId,-1)
	ORDER BY T.TopicId desc