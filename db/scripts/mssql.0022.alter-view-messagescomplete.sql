/****** Object:  View [dbo].[MessagesComplete]    Script Date: 09/21/2011 16:45:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[MessagesComplete]
AS
SELECT
	M.TopicId
	,M.MessageId
	,M.MessageBody
	,M.MessageCreationDate
	,M.MessageLastEditDate
	,M.ParentId
	,M.UserId
	,M.Active
	,U.UserName
	,U.UserSignature
	,U.UserGroupId
	,G.UserGroupName
	,U.UserPhoto
	,U.UserRegistrationDate
FROM
	dbo.Messages M
	INNER JOIN dbo.Users U ON U.UserId = M.UserId
	INNER JOIN dbo.UsersGroups G ON G.UserGroupId = U.UserGroupId
	LEFT JOIN dbo.Messages P ON P.TopicId = M.TopicId AND P.MessageId = M.ParentId AND P.Active = 1
GO


