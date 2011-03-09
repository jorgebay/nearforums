CREATE PROCEDURE [dbo].[SPMessagesFlagsClear]
(
	@TopicId int=1
	,@MessageId int=1
)
AS
DELETE FROM 
	Flags
WHERE
	TopicId = @TopicId
	AND
	MessageId = @MessageId

GO

CREATE PROCEDURE [dbo].[SPMessagesFlagsGetAll]
AS
/*
	Lists all flagged messages (not topics)
*/
SELECT
	F.TopicId
	,F.MessageId
	,COUNT(FlagId) AS TotalFlags
	,T.TopicTitle
	,T.TopicShortName
	,Forums.ForumId
	,Forums.ForumShortName
	,Forums.ForumName
	,M.MessageBody
	,M.UserName
	,M.UserId
FROM
	Flags F
	INNER JOIN Topics T ON T.TopicId = F.TopicId
	INNER JOIN Forums ON Forums.ForumId = T.ForumId
	INNER JOIN MessagesComplete M ON M.TopicId = T.TopicId AND M.MessageId = F.MessageId
WHERE
	T.Active = 1
	AND	
	M.Active = 1
GROUP BY	
	F.TopicId
	,F.MessageId
	,T.TopicTitle
	,T.TopicShortName
	,Forums.ForumId
	,Forums.ForumShortName
	,Forums.ForumName
	,M.MessageBody
	,M.UserName
	,M.UserId
ORDER BY COUNT(FlagId) DESC, F.TopicId
