ALTER VIEW [dbo].[TopicsComplete] 
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
		,CASE 
			WHEN ISNULL(T.ReadAccessGroupId, -1) >= ISNULL(F.ReadAccessGroupId, -1) THEN T.ReadAccessGroupId
			ELSE F.ReadAccessGroupId END AS ReadAccessGroupId
		,CASE 
			WHEN T.PostAccessGroupId >= ISNULL(F.ReadAccessGroupId,-1) THEN T.PostAccessGroupId -- Do not inherit post access
			ELSE F.ReadAccessGroupId END AS PostAccessGroupId -- use the parent read access, if greater
	FROM
		Topics T
		INNER JOIN Users U ON U.UserId = T.UserId
		INNER JOIN Forums F ON F.ForumId = T.ForumId
	WHERE
		T.Active = 1
		AND
		F.Active = 1
GO

ALTER PROCEDURE [dbo].[SPTopicsGet]
	@TopicId int=1
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
	,T.ForumId
	,T.ForumName
	,T.ForumShortName
	,T.ReadAccessGroupId
	,T.PostAccessGroupId
FROM 
	TopicsComplete T
WHERE
	T.TopicId = @TopicId
GO

ALTER PROCEDURE [dbo].[SPTopicsGetByForum]
	@ForumId int = 2
	,@StartIndex int = 0
	,@Length int = 10
	,@UserGroupId int = null
AS
SELECT
	*
FROM
	(SELECT
		ROW_NUMBER()
			OVER 
				(ORDER BY TopicOrder desc
				 ,TopicViews desc)
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
		,T.ReadAccessGroupId
		,T.PostAccessGroupId
	FROM
		TopicsComplete T
		LEFT JOIN [Messages] M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
		LEFT JOIN Users MU ON MU.UserId = M.UserId
	WHERE
		T.ForumId = @ForumId
		AND
		ISNULL(T.ReadAccessGroupId,-1) <= ISNULL(@UserGroupId,-1)
	) T
WHERE
	RowNumber BETWEEN @StartIndex+1 AND @StartIndex + @Length
GO

ALTER PROCEDURE [dbo].[SPTopicsGetByForumLatest]
	@ForumId int = 2
	,@StartIndex int = 0
	,@Length int = 10
	,@UserGroupId int = null
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
		,T.ReadAccessGroupId
		,T.PostAccessGroupId
	FROM
		TopicsComplete T
		LEFT JOIN [Messages] M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
		LEFT JOIN Users MU ON MU.UserId = M.UserId
	WHERE
		T.ForumId = @ForumId
		AND
		ISNULL(T.ReadAccessGroupId,-1) <= ISNULL(@UserGroupId,-1)
	) T
WHERE
	RowNumber BETWEEN @StartIndex+1 AND @StartIndex + @Length
GO

ALTER PROCEDURE [dbo].[SPTopicsGetByForumUnanswered]
	@ForumId int = 2
	,@UserGroupId int = null
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
	,T.ReadAccessGroupId
	,T.PostAccessGroupId
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
	AND
	ISNULL(T.ReadAccessGroupId,-1) <= ISNULL(@UserGroupId,-1)
ORDER BY 
	TopicViews DESC, TopicId DESC
GO

ALTER PROCEDURE [dbo].[SPTopicsGetByTag]
	@Tag nvarchar(50)='forum'
	,@ForumId int=2
	,@UserGroupId int = null
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
		,T.ReadAccessGroupId
		,T.PostAccessGroupId
FROM
	Tags
	INNER JOIN TopicsComplete T ON T.TopicId = Tags.TopicId
	LEFT JOIN Messages M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
	LEFT JOIN Users MU ON MU.UserId = M.UserId
WHERE
	Tags.Tag LIKE @Tag + '%'
	AND
	T.ForumId = @ForumId
	AND
	ISNULL(T.ReadAccessGroupId,-1) <= ISNULL(@UserGroupId,-1)
ORDER BY TopicOrder DESC,TopicViews DESC
GO

ALTER PROCEDURE [dbo].[SPTopicsGetByUser]
	@UserId int
	,@UserGroupId int = null
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
	,T.ReadAccessGroupId
	,T.PostAccessGroupId
FROM
	TopicsComplete T
	LEFT JOIN Messages M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
WHERE
	T.UserId = @UserId
	AND
	ISNULL(T.ReadAccessGroupId,-1) <= ISNULL(@UserGroupId,-1)
ORDER BY T.TopicId DESC
GO
