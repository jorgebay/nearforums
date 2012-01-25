GO
ALTER PROCEDURE [dbo].[SPForumsGetByCategory]
	@UserGroupId smallint=NULL
AS
SELECT
	F.ForumId
	,F.ForumName
	,F.ForumShortName
	,F.ForumDescription
	,F.UserId
	,F.ForumCreationDate
	,F.ForumTopicCount
	,F.ForumMessageCount
	,C.CategoryId
	,C.CategoryName
FROM
	ForumsCategories C
	INNER JOIN Forums F ON F.CategoryId = C.CategoryId
WHERE
	F.Active = 1
	AND
	ISNULL(F.ReadAccessGroupId,-1) <= ISNULL(@UserGroupId,-1)
ORDER BY
	C.CategoryOrder,
	F.ForumOrder
GO

ALTER PROCEDURE [dbo].[SPForumsGetByShortName]
	@ShortName nvarchar(32)
AS
SELECT
	F.ForumId
	,F.ForumName
	,F.ForumShortName
	,F.ForumDescription
	,F.UserId
	,F.ForumCreationDate
	,F.ForumTopicCount
	,F.ForumMessageCount
	,C.CategoryId
	,C.CategoryName
	,F.ReadAccessGroupId
	,F.PostAccessGroupId
FROM
	Forums F 
	INNER JOIN ForumsCategories C ON F.CategoryId = C.CategoryId
WHERE
	F.ForumShortName = @ShortName
	AND
	F.Active = 1
GO

ALTER PROCEDURE [dbo].[SPForumsInsert]
(
	@ForumName nvarchar(255)
	,@ForumShortName nvarchar(32)
	,@ForumDescription nvarchar(max)
	,@CategoryId int
	,@UserId int
	,@ReadAccessGroupId smallint
	,@PostAccessGroupId smallint
)
AS
INSERT INTO Forums
(
	ForumName
	,ForumShortName
	,ForumDescription
	,CategoryId
	,UserId
	,ForumCreationDate
	,ForumLastEditDate
	,ForumLastEditUser
	,Active
	,ForumTopicCount
	,ForumMessageCount
	,ForumOrder
	,ReadAccessGroupId
	,PostAccessGroupId
)
VALUES
(
	@ForumName
	,@ForumShortName
	,@ForumDescription
	,@CategoryId
	,@UserId
	,GETUTCDATE()
	,GETUTCDATE()
	,@UserId
	,1
	,0
	,0
	,0
	,@ReadAccessGroupId
	,@PostAccessGroupId
)
GO

ALTER PROCEDURE [dbo].[SPForumsUpdate]
(
	@ForumShortName nvarchar(32)
	,@ForumName nvarchar(255)
	,@ForumDescription nvarchar(max)
	,@CategoryId int
	,@UserId int
	,@ReadAccessGroupId smallint
	,@PostAccessGroupId smallint
)
AS
UPDATE Forums
SET
	ForumName = @ForumName
	,ForumDescription = @ForumDescription 
	,CategoryId = @CategoryId
	,ForumLastEditDate = GETUTCDATE()
	,ForumLastEditUser = @UserId
	,ReadAccessGroupId = @ReadAccessGroupId
	,PostAccessGroupId = @PostAccessGroupId
WHERE
	ForumShortName = @ForumShortName
GO

