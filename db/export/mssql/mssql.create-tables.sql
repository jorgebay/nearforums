SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsersGroups](
	[UserGroupId] [smallint] NOT NULL,
	[UserGroupName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_UsersGroups] PRIMARY KEY CLUSTERED 
(
	[UserGroupId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Templates](
	[TemplateId] [int] IDENTITY(1,1) NOT NULL,
	[TemplateKey] [varchar](16) NOT NULL,
	[TemplateDescription] [varchar](256) NULL,
	[TemplateIsCurrent] [bit] NOT NULL,
	[TemplateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Templates] PRIMARY KEY CLUSTERED 
(
	[TemplateId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ForumsCategories](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [varchar](255) NOT NULL,
	[CategoryOrder] [int] NOT NULL,
 CONSTRAINT [PK_ForumsCategories] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Topics](
	[TopicId] [int] IDENTITY(1,1) NOT NULL,
	[TopicTitle] [varchar](256) NOT NULL,
	[TopicShortName] [varchar](64) NOT NULL,
	[TopicDescription] [varchar](max) NOT NULL,
	[TopicCreationDate] [datetime] NOT NULL,
	[TopicLastEditDate] [datetime] NOT NULL,
	[TopicViews] [int] NOT NULL,
	[TopicReplies] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[TopicTags] [varchar](256) NOT NULL,
	[ForumId] [int] NOT NULL,
	[TopicLastEditUser] [int] NOT NULL,
	[TopicLastEditIp] [varchar](15) NOT NULL,
	[Active] [bit] NOT NULL,
	[TopicIsClose] [bit] NOT NULL,
	[TopicOrder] [int] NULL,
	[LastMessageId] [int] NULL,
	[MessagesIdentity] [int] NOT NULL,
 CONSTRAINT [PK_Topics] PRIMARY KEY CLUSTERED 
(
	[TopicId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TopicsSubscriptions](
	[TopicId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
 CONSTRAINT [PK_TopicsSubscriptions] PRIMARY KEY CLUSTERED 
(
	[TopicId] ASC,
	[UserId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Forums](
	[ForumId] [int] IDENTITY(1,1) NOT NULL,
	[ForumName] [varchar](255) NOT NULL,
	[ForumShortName] [varchar](32) NOT NULL,
	[ForumDescription] [varchar](max) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[ForumCreationDate] [datetime] NOT NULL,
	[ForumLastEditDate] [datetime] NOT NULL,
	[ForumLastEditUser] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[ForumTopicCount] [int] NOT NULL,
	[ForumMessageCount] [int] NOT NULL,
	[ForumOrder] [int] NOT NULL,
 CONSTRAINT [PK_Forums] PRIMARY KEY CLUSTERED 
(
	[ForumId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_Forums_ForumShortName] ON [dbo].[Forums] 
(
	[ForumShortName] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Messages](
	[TopicId] [int] NOT NULL,
	[MessageId] [int] NOT NULL,
	[MessageBody] [varchar](max) NOT NULL,
	[MessageCreationDate] [datetime] NOT NULL,
	[MessageLastEditDate] [datetime] NOT NULL,
	[MessageLastEditUser] [datetime] NOT NULL,
	[UserId] [int] NOT NULL,
	[ParentId] [int] NULL,
	[Active] [bit] NOT NULL,
	[EditIp] [varchar](15) NULL,
 CONSTRAINT [PK_Messages] PRIMARY KEY CLUSTERED 
(
	[TopicId] ASC,
	[MessageId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[UserProfile] [varchar](max) NULL,
	[UserSignature] [varchar](max) NULL,
	[UserGroupId] [smallint] NOT NULL,
	[Active] [bit] NOT NULL,
	[UserBirthDate] [datetime] NULL,
	[UserWebsite] [varchar](255) NULL,
	[UserGuid] [char](32) NOT NULL,
	[UserTimezone] [decimal](9, 2) NOT NULL,
	[UserEmail] [varchar](100) NULL,
	[UserEmailPolicy] [int] NULL,
	[UserPhoto] [varchar](1024) NULL,
	[UserRegistrationDate] [datetime] NOT NULL,
	[UserExternalProfileUrl] [varchar](255) NULL,
	[UserProvider] [varchar](32) NOT NULL,
	[UserProviderId] [varchar](64) NOT NULL,
	[UserProviderLastCall] [datetime] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE NONCLUSTERED INDEX [IX_Users] ON [dbo].[Users] 
(
	[UserProvider] ASC,
	[UserProviderId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tags](
	[Tag] [varchar](50) NOT NULL,
	[TopicId] [int] NOT NULL,
 CONSTRAINT [PK_Tags] PRIMARY KEY CLUSTERED 
(
	[Tag] ASC,
	[TopicId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Topics]  WITH CHECK ADD  CONSTRAINT [FK_Topics_Forums] FOREIGN KEY([ForumId])
REFERENCES [dbo].[Forums] ([ForumId])
GO
ALTER TABLE [dbo].[Topics]  WITH CHECK ADD  CONSTRAINT [FK_Topics_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Topics]  WITH CHECK ADD  CONSTRAINT [FK_Topics_Users_LastEdit] FOREIGN KEY([TopicLastEditUser])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[TopicsSubscriptions]  WITH CHECK ADD  CONSTRAINT [FK_TopicsSubscriptions_Topics] FOREIGN KEY([TopicId])
REFERENCES [dbo].[Topics] ([TopicId])
GO
ALTER TABLE [dbo].[TopicsSubscriptions]  WITH CHECK ADD  CONSTRAINT [FK_TopicsSubscriptions_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Forums]  WITH CHECK ADD  CONSTRAINT [FK_Forums_ForumsCategories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[ForumsCategories] ([CategoryId])
GO
ALTER TABLE [dbo].[Forums]  WITH CHECK ADD  CONSTRAINT [FK_Forums_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Forums]  WITH CHECK ADD  CONSTRAINT [FK_Forums_Users_LastEdit] FOREIGN KEY([ForumLastEditUser])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Messages]  WITH CHECK ADD  CONSTRAINT [FK_Messages_Topics] FOREIGN KEY([TopicId])
REFERENCES [dbo].[Topics] ([TopicId])
GO
ALTER TABLE [dbo].[Messages]  WITH CHECK ADD  CONSTRAINT [FK_Messages_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_UsersGroups] FOREIGN KEY([UserGroupId])
REFERENCES [dbo].[UsersGroups] ([UserGroupId])
GO
ALTER TABLE [dbo].[Tags]  WITH CHECK ADD  CONSTRAINT [FK_Tags_Topics] FOREIGN KEY([TopicId])
REFERENCES [dbo].[Topics] ([TopicId])
