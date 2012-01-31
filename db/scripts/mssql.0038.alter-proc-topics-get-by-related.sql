ALTER PROCEDURE [dbo].[SPTopicsGetByRelated]
	@Tag1 nvarchar(50)='problem'
	,@Tag2 nvarchar(50)='installation'
	,@Tag3 nvarchar(50)='copy'
	,@Tag4 nvarchar(50)=null
	,@Tag5 nvarchar(50)=null
	,@Tag6 nvarchar(50)=null
	,@TopicId int=1
	,@Amount int=5
	,@UserGroupId int = null
AS
	
WITH TagsParams (Tag) AS
(
	SELECT @Tag1
	UNION
	SELECT @Tag2
	UNION
	SELECT @Tag3
	UNION
	SELECT @Tag4
	UNION
	SELECT @Tag5
	UNION
	SELECT @Tag6
)
SELECT
	TOP (@Amount)
	Ta.TagCount
	,Topics.TopicId
	,Topics.TopicTitle
	,Topics.TopicShortName
	,Topics.TopicDescription
	,Topics.TopicCreationDate
	,Topics.TopicViews
	,Topics.TopicReplies
	,Topics.ForumId
	,Topics.ForumName
	,Topics.ForumShortName
	,Topics.TopicIsClose
	,Topics.TopicOrder
	,Topics.ReadAccessGroupId
	,Topics.PostAccessGroupId
FROM
	(
	SELECT 
		T.TopicId
		,COUNT(T.Tag) AS TagCount
	FROM 
		Tags T
		INNER JOIN TagsParams P ON T.Tag=P.Tag
	WHERE
		T.Tag=P.Tag
	GROUP BY
		T.TopicId
	)
	Ta
	INNER JOIN TopicsComplete Topics ON Topics.TopicId = Ta.TopicId
WHERE
	Topics.TopicId <> @TopicId
	AND
	ISNULL(Topics.ReadAccessGroupId,-1) <= ISNULL(@UserGroupId,-1)
ORDER BY
	1 desc, Topics.TopicViews DESC