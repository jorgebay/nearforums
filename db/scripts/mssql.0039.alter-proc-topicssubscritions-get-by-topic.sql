ALTER PROCEDURE [dbo].[SPTopicsSubscriptionsGetByTopic]
	@TopicId int
AS
/*
	Gets the active users subscribed to a topic.
	Checks read access of topic vs user role
*/
SELECT
	U.UserId
	,U.UserName
	,U.UserEmail
	,U.UserEmailPolicy
	,U.UserGuid
FROM
	TopicsSubscriptions S
	INNER JOIN Topics T ON T.TopicId = S.TopicId
	INNER JOIN Users U ON U.UserId = S.UserId
WHERE
	S.TopicId = @TopicId
	AND
	U.Active = 1
	AND
	U.UserGroupId >= ISNULL(T.ReadAccessGroupId, -1)