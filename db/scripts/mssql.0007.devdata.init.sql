/*Users*/
INSERT [dbo].[Users] ([UserName], [UserProfile], [UserSignature], [UserGroupId], [Active], [UserBirthDate], [UserWebsite], [UserGuid], [UserTimezone], [UserEmail], [UserEmailPolicy], [UserPhoto], [UserRegistrationDate], [UserExternalProfileUrl], [UserProvider], [UserProviderId], [UserProviderLastCall]) VALUES (N'Jorge Bay', NULL, NULL, 10, 1, NULL, NULL, N'5488fd1dda9140fbba2ce6b941b3282b', CAST(1.00 AS Decimal(9, 2)), NULL, NULL, N'http://profile.ak.fbcdn.net/hprofile-ak-snc4/49133_648271297_9464_s.jpg', (GETUTCDATE()-100), N'http://www.facebook.com/profile.php?id=648271297', N'FACEBOOK', N'648271297', GETUTCDATE());

/*Forums*/
INSERT [dbo].[Forums] ([ForumName], [ForumShortName], [ForumDescription], [CategoryId], [UserId], [ForumCreationDate], [ForumLastEditDate], [ForumLastEditUser], [Active], [ForumTopicCount], [ForumMessageCount], [ForumOrder]) VALUES (N'Suggestions', N'suggestions', N'This is a sample forum about suggestions', 1, 1, (GETUTCDATE()-10), (GETUTCDATE()-10), 1, 1, 3, 8, 0);
INSERT [dbo].[Forums] ([ForumName], [ForumShortName], [ForumDescription], [CategoryId], [UserId], [ForumCreationDate], [ForumLastEditDate], [ForumLastEditUser], [Active], [ForumTopicCount], [ForumMessageCount], [ForumOrder]) VALUES (N'Sample forum', N'sample-forum', N'Another sample forum', 1, 1, (GETUTCDATE()-10), (GETUTCDATE()-10), 1, 1, 0, 0, 0);

/*Topics*/
INSERT [dbo].[Topics] ([TopicTitle], [TopicShortName], [TopicDescription], [TopicCreationDate], [TopicLastEditDate], [TopicViews], [TopicReplies], [UserId], [TopicTags], [ForumId], [TopicLastEditUser], [TopicLastEditIp], [Active], [TopicIsClose], [TopicOrder], [LastMessageId], [MessagesIdentity]) VALUES (N'Something like a thread', N'something-like-a-thread', N'<p>This is a sample <strong>thread</strong> containing.</p>
<ul>
<li>List item</li>
</ul>', (GETUTCDATE()-1), (GETUTCDATE()-1), 1, 1, 1, N'sample thread', 1, 1, N'127.0.0.1', 1, 0, NULL, 1, 1);
INSERT [dbo].[Topics] ([TopicTitle], [TopicShortName], [TopicDescription], [TopicCreationDate], [TopicLastEditDate], [TopicViews], [TopicReplies], [UserId], [TopicTags], [ForumId], [TopicLastEditUser], [TopicLastEditIp], [Active], [TopicIsClose], [TopicOrder], [LastMessageId], [MessagesIdentity]) VALUES (N'This is a stick thread', N'this-is-a-stick-thread', N'<p>Hey I''m stuck!!!</p>', (GETUTCDATE()-1), (GETUTCDATE()-1), 1, 7, 1, N'sample sticky', 1, 1, N'127.0.0.1', 1, 0, NULL, 7, 7);
INSERT [dbo].[Topics] ([TopicTitle], [TopicShortName], [TopicDescription], [TopicCreationDate], [TopicLastEditDate], [TopicViews], [TopicReplies], [UserId], [TopicTags], [ForumId], [TopicLastEditUser], [TopicLastEditIp], [Active], [TopicIsClose], [TopicOrder], [LastMessageId], [MessagesIdentity]) VALUES (N'Dummy Suggestions', N'dummy-suggestions', N'<p>Dummy thread!!</p>', (GETUTCDATE()-1), (GETUTCDATE()-1), 1, 0, 1, N'sample text', 1, 1, N'127.0.0.1', 1, 0, NULL, NULL, 0);

/*Tags*/
INSERT [dbo].[Tags] ([Tag], [TopicId]) VALUES (N'sample', 1);
INSERT [dbo].[Tags] ([Tag], [TopicId]) VALUES (N'sample', 2);
INSERT [dbo].[Tags] ([Tag], [TopicId]) VALUES (N'sample', 3);
INSERT [dbo].[Tags] ([Tag], [TopicId]) VALUES (N'sticky', 2);
INSERT [dbo].[Tags] ([Tag], [TopicId]) VALUES (N'text', 3);
INSERT [dbo].[Tags] ([Tag], [TopicId]) VALUES (N'thread', 1);

/*Messages */
INSERT [dbo].[Messages] ([TopicId], [MessageId], [MessageBody], [MessageCreationDate], [MessageLastEditDate], [MessageLastEditUser], [UserId], [ParentId], [Active], [EditIp]) VALUES (1, 1, N'<p>Replying to the thread owner!</p>
<p>First message!</p>', GETUTCDATE()-1, GETUTCDATE()-1, CAST(0x0000000100000000 AS DateTime), 1, NULL, 1, N'127.0.0.1');
INSERT [dbo].[Messages] ([TopicId], [MessageId], [MessageBody], [MessageCreationDate], [MessageLastEditDate], [MessageLastEditUser], [UserId], [ParentId], [Active], [EditIp]) VALUES (2, 1, N'<p>More test messages!!</p>', GETUTCDATE()-1, GETUTCDATE()-1, CAST(0x0000000100000000 AS DateTime), 1, NULL, 1, N'127.0.0.1');
INSERT [dbo].[Messages] ([TopicId], [MessageId], [MessageBody], [MessageCreationDate], [MessageLastEditDate], [MessageLastEditUser], [UserId], [ParentId], [Active], [EditIp]) VALUES (2, 2, N'<p>Another message</p>
<p><a href="#msg1" class="fastQuote">[#1]</a>: Sure?</p>', GETUTCDATE()-1, GETUTCDATE()-1, CAST(0x0000000100000000 AS DateTime), 1, NULL, 1, N'127.0.0.1');
INSERT [dbo].[Messages] ([TopicId], [MessageId], [MessageBody], [MessageCreationDate], [MessageLastEditDate], [MessageLastEditUser], [UserId], [ParentId], [Active], [EditIp]) VALUES (2, 3, N'<p>More more, more, more!!!</p>
<p>Show me more!!</p>', GETUTCDATE()-1, GETUTCDATE()-1, CAST(0x0000000100000000 AS DateTime), 1, NULL, 1, N'127.0.0.1');
INSERT [dbo].[Messages] ([TopicId], [MessageId], [MessageBody], [MessageCreationDate], [MessageLastEditDate], [MessageLastEditUser], [UserId], [ParentId], [Active], [EditIp]) VALUES (2, 4, N'<p>Heyyyyyyyyyyyyyyyyyyyyyyy!</p>', GETUTCDATE()-1, GETUTCDATE()-1, CAST(0x0000000100000000 AS DateTime), 1, NULL, 1, N'127.0.0.1');
INSERT [dbo].[Messages] ([TopicId], [MessageId], [MessageBody], [MessageCreationDate], [MessageLastEditDate], [MessageLastEditUser], [UserId], [ParentId], [Active], [EditIp]) VALUES (2, 5, N'<p>Heyyyyyyyyyyyyyyyyyyyyyyy!</p>', GETUTCDATE()-1, GETUTCDATE()-1, CAST(0x0000000100000000 AS DateTime), 1, NULL, 0, N'127.0.0.1');
INSERT [dbo].[Messages] ([TopicId], [MessageId], [MessageBody], [MessageCreationDate], [MessageLastEditDate], [MessageLastEditUser], [UserId], [ParentId], [Active], [EditIp]) VALUES (2, 6, N'<p>Yidiup!</p>', GETUTCDATE()-1, GETUTCDATE()-1, CAST(0x0000000100000000 AS DateTime), 1, NULL, 1, N'127.0.0.1');
INSERT [dbo].[Messages] ([TopicId], [MessageId], [MessageBody], [MessageCreationDate], [MessageLastEditDate], [MessageLastEditUser], [UserId], [ParentId], [Active], [EditIp]) VALUES (2, 7, N'<p>Yidiup! Not!</p>', GETUTCDATE()-1, GETUTCDATE()-1, CAST(0x0000000100000000 AS DateTime), 1, NULL, 1, N'127.0.0.1');

/*Flags*/
INSERT [dbo].[Flags] ([TopicId], [MessageId], [Ip], [FlagDate]) VALUES (2, 2, N'127.0.0.1', GETUTCDATE()-1)
INSERT [dbo].[Flags] ([TopicId], [MessageId], [Ip], [FlagDate]) VALUES (2, 6, N'127.0.0.1', GETUTCDATE()-1)
