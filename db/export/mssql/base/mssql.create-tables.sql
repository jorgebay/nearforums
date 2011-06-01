SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageContents]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PageContents](
	[PageContentId] [int] IDENTITY(1,1) NOT NULL,
	[PageContentTitle] [varchar](128) NOT NULL,
	[PageContentBody] [varchar](max) NOT NULL,
	[PageContentShortName] [varchar](128) NOT NULL,
	[PageContentEditDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PageContents] PRIMARY KEY CLUSTERED 
(
	[PageContentId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UsersGroups]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UsersGroups](
	[UserGroupId] [smallint] NOT NULL,
	[UserGroupName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_UsersGroups] PRIMARY KEY CLUSTERED 
(
	[UserGroupId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Templates]') AND type in (N'U'))
BEGIN
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
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ForumsCategories]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ForumsCategories](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [varchar](255) NOT NULL,
	[CategoryOrder] [int] NOT NULL,
 CONSTRAINT [PK_ForumsCategories] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tags]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Tags](
	[Tag] [varchar](50) NOT NULL,
	[TopicId] [int] NOT NULL,
 CONSTRAINT [PK_Tags] PRIMARY KEY CLUSTERED 
(
	[Tag] ASC,
	[TopicId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Messages]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Messages](
	[TopicId] [int] NOT NULL,
	[MessageId] [int] NOT NULL,
	[MessageBody] [varchar](max) NOT NULL,
	[MessageCreationDate] [datetime] NOT NULL,
	[MessageLastEditDate] [datetime] NOT NULL,
	[UserId] [int] NOT NULL,
	[ParentId] [int] NULL,
	[Active] [bit] NOT NULL,
	[EditIp] [varchar](15) NULL,
	[MessageLastEditUser] [int] NOT NULL,
 CONSTRAINT [PK_Messages] PRIMARY KEY CLUSTERED 
(
	[TopicId] ASC,
	[MessageId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TopicsSubscriptions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TopicsSubscriptions](
	[TopicId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
 CONSTRAINT [PK_TopicsSubscriptions] PRIMARY KEY CLUSTERED 
(
	[TopicId] ASC,
	[UserId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Topics]') AND type in (N'U'))
BEGIN
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
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Flags]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Flags](
	[FlagId] [int] IDENTITY(1,1) NOT NULL,
	[TopicId] [int] NOT NULL,
	[MessageId] [int] NULL,
	[Ip] [varchar](15) NOT NULL,
	[FlagDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Flags] PRIMARY KEY CLUSTERED 
(
	[FlagId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Flags]') AND name = N'IX_Flags')
CREATE UNIQUE NONCLUSTERED INDEX [IX_Flags] ON [dbo].[Flags] 
(
	[TopicId] ASC,
	[MessageId] ASC,
	[Ip] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Forums]') AND type in (N'U'))
BEGIN
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
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Forums]') AND name = N'IX_Forums_ForumShortName')
CREATE UNIQUE NONCLUSTERED INDEX [IX_Forums_ForumShortName] ON [dbo].[Forums] 
(
	[ForumShortName] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type in (N'U'))
BEGIN
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
	[PasswordResetGuid] [varchar](100) NULL,
	[PasswordResetGuidExpireDate] [datetime] NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND name = N'IX_Users')
CREATE NONCLUSTERED INDEX [IX_Users] ON [dbo].[Users] 
(
	[UserProvider] ASC,
	[UserProviderId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Tags_Topics]') AND parent_object_id = OBJECT_ID(N'[dbo].[Tags]'))
ALTER TABLE [dbo].[Tags]  WITH CHECK ADD  CONSTRAINT [FK_Tags_Topics] FOREIGN KEY([TopicId])
REFERENCES [dbo].[Topics] ([TopicId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Messages_Topics]') AND parent_object_id = OBJECT_ID(N'[dbo].[Messages]'))
ALTER TABLE [dbo].[Messages]  WITH CHECK ADD  CONSTRAINT [FK_Messages_Topics] FOREIGN KEY([TopicId])
REFERENCES [dbo].[Topics] ([TopicId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Messages_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Messages]'))
ALTER TABLE [dbo].[Messages]  WITH CHECK ADD  CONSTRAINT [FK_Messages_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TopicsSubscriptions_Topics]') AND parent_object_id = OBJECT_ID(N'[dbo].[TopicsSubscriptions]'))
ALTER TABLE [dbo].[TopicsSubscriptions]  WITH CHECK ADD  CONSTRAINT [FK_TopicsSubscriptions_Topics] FOREIGN KEY([TopicId])
REFERENCES [dbo].[Topics] ([TopicId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TopicsSubscriptions_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[TopicsSubscriptions]'))
ALTER TABLE [dbo].[TopicsSubscriptions]  WITH CHECK ADD  CONSTRAINT [FK_TopicsSubscriptions_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_Forums]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics]  WITH CHECK ADD  CONSTRAINT [FK_Topics_Forums] FOREIGN KEY([ForumId])
REFERENCES [dbo].[Forums] ([ForumId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics]  WITH CHECK ADD  CONSTRAINT [FK_Topics_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Topics_Users_LastEdit]') AND parent_object_id = OBJECT_ID(N'[dbo].[Topics]'))
ALTER TABLE [dbo].[Topics]  WITH CHECK ADD  CONSTRAINT [FK_Topics_Users_LastEdit] FOREIGN KEY([TopicLastEditUser])
REFERENCES [dbo].[Users] ([UserId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Flags_Messages]') AND parent_object_id = OBJECT_ID(N'[dbo].[Flags]'))
ALTER TABLE [dbo].[Flags]  WITH CHECK ADD  CONSTRAINT [FK_Flags_Messages] FOREIGN KEY([TopicId], [MessageId])
REFERENCES [dbo].[Messages] ([TopicId], [MessageId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_ForumsCategories]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums]  WITH CHECK ADD  CONSTRAINT [FK_Forums_ForumsCategories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[ForumsCategories] ([CategoryId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums]  WITH CHECK ADD  CONSTRAINT [FK_Forums_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Forums_Users_LastEdit]') AND parent_object_id = OBJECT_ID(N'[dbo].[Forums]'))
ALTER TABLE [dbo].[Forums]  WITH CHECK ADD  CONSTRAINT [FK_Forums_Users_LastEdit] FOREIGN KEY([ForumLastEditUser])
REFERENCES [dbo].[Users] ([UserId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Users_UsersGroups]') AND parent_object_id = OBJECT_ID(N'[dbo].[Users]'))
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_UsersGroups] FOREIGN KEY([UserGroupId])
REFERENCES [dbo].[UsersGroups] ([UserGroupId])
