-- Init options
SET GLOBAL log_bin_trust_function_creators = 1;

-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.1.46-community


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;



--
-- Temporary table structure for view `messagescomplete`
--
DROP TABLE IF EXISTS `messagescomplete`;
DROP VIEW IF EXISTS `messagescomplete`;
CREATE TABLE `messagescomplete` (
  `TopicId` int(11),
  `MessageId` int(11),
  `MessageBody` longtext,
  `MessageCreationDate` datetime,
  `MessageLastEditDate` datetime,
  `ParentId` int(11),
  `UserId` int(11),
  `Active` tinyint(1),
  `UserName` varchar(50),
  `UserSignature` longtext,
  `UserGroupId` smallint(6),
  `UserGroupName` varchar(50)
);

--
-- Temporary table structure for view `topicscomplete`
--
DROP TABLE IF EXISTS `topicscomplete`;
DROP VIEW IF EXISTS `topicscomplete`;
CREATE TABLE `topicscomplete` (
  `TopicId` int(11),
  `TopicTitle` varchar(256),
  `TopicShortName` varchar(64),
  `TopicDescription` longtext,
  `TopicCreationDate` datetime,
  `TopicViews` int(11),
  `TopicReplies` int(11),
  `UserId` int(11),
  `TopicTags` varchar(256),
  `TopicIsClose` tinyint(1),
  `TopicOrder` int(11),
  `LastMessageId` int(11),
  `UserName` varchar(50),
  `ForumId` int(11),
  `ForumName` varchar(255),
  `ForumShortName` varchar(32)
);

--
-- Definition of table `forums`
--

DROP TABLE IF EXISTS `forums`;
CREATE TABLE `forums` (
  `forumid` int(11) NOT NULL AUTO_INCREMENT,
  `forumname` varchar(255) NOT NULL,
  `forumshortname` varchar(32) NOT NULL,
  `forumdescription` longtext NOT NULL,
  `categoryid` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `forumcreationdate` datetime NOT NULL,
  `forumlasteditdate` datetime NOT NULL,
  `forumlastedituser` int(11) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `forumtopiccount` int(11) NOT NULL,
  `forummessagecount` int(11) NOT NULL,
  `forumorder` int(11) NOT NULL,
  PRIMARY KEY (`forumid`),
  UNIQUE KEY `ix_forums_forumshortname` (`forumshortname`),
  KEY `fk_forums_forumscategories` (`categoryid`),
  KEY `fk_forums_users` (`userid`),
  KEY `fk_forums_users_lastedit` (`forumlastedituser`),
  CONSTRAINT `fk_forums_forumscategories` FOREIGN KEY (`categoryid`) REFERENCES `forumscategories` (`categoryid`),
  CONSTRAINT `fk_forums_users` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`),
  CONSTRAINT `fk_forums_users_lastedit` FOREIGN KEY (`forumlastedituser`) REFERENCES `users` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `forums`
--

--
-- Definition of table `forumscategories`
--

DROP TABLE IF EXISTS `forumscategories`;
CREATE TABLE `forumscategories` (
  `categoryid` int(11) NOT NULL AUTO_INCREMENT,
  `categoryname` varchar(255) NOT NULL,
  `categoryorder` int(11) NOT NULL,
  PRIMARY KEY (`categoryid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `forumscategories`
--
INSERT INTO `forumscategories` VALUES   (1,'General',10);

--
-- Definition of table `messages`
--

DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
  `topicid` int(11) NOT NULL,
  `messageid` int(11) NOT NULL,
  `messagebody` longtext NOT NULL,
  `messagecreationdate` datetime NOT NULL,
  `messagelasteditdate` datetime NOT NULL,
  `messagelastedituser` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `parentid` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL,
  `editip` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`topicid`,`messageid`),
  KEY `fk_messages_users` (`userid`),
  CONSTRAINT `fk_messages_topics` FOREIGN KEY (`topicid`) REFERENCES `topics` (`topicid`),
  CONSTRAINT `fk_messages_users` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `messages`
--

--
-- Definition of table `tags`
--

DROP TABLE IF EXISTS `tags`;
CREATE TABLE `tags` (
  `tag` varchar(50) NOT NULL,
  `topicid` int(11) NOT NULL,
  PRIMARY KEY (`tag`,`topicid`),
  KEY `fk_tags_topics` (`topicid`),
  CONSTRAINT `fk_tags_topics` FOREIGN KEY (`topicid`) REFERENCES `topics` (`topicid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tags`
--

--
-- Definition of table `templates`
--

DROP TABLE IF EXISTS `templates`;
CREATE TABLE `templates` (
  `templateid` int(11) NOT NULL AUTO_INCREMENT,
  `templatekey` varchar(16) NOT NULL,
  `templatedescription` varchar(256) DEFAULT NULL,
  `templateiscurrent` tinyint(1) NOT NULL,
  `templatedate` datetime NOT NULL,
  PRIMARY KEY (`templateid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `templates`
--

--
-- Definition of table `topics`
--

DROP TABLE IF EXISTS `topics`;
CREATE TABLE `topics` (
  `topicid` int(11) NOT NULL AUTO_INCREMENT,
  `topictitle` varchar(256) NOT NULL,
  `topicshortname` varchar(64) NOT NULL,
  `topicdescription` longtext NOT NULL,
  `topiccreationdate` datetime NOT NULL,
  `topiclasteditdate` datetime NOT NULL,
  `topicviews` int(11) NOT NULL,
  `topicreplies` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `topictags` varchar(256) NOT NULL,
  `forumid` int(11) NOT NULL,
  `topiclastedituser` int(11) NOT NULL,
  `topiclasteditip` varchar(15) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `topicisclose` tinyint(1) NOT NULL,
  `topicorder` int(11) DEFAULT NULL,
  `lastmessageid` int(11) DEFAULT NULL,
  `messagesidentity` int(11) NOT NULL,
  PRIMARY KEY (`topicid`),
  KEY `fk_topics_forums` (`forumid`),
  KEY `fk_topics_users` (`userid`),
  KEY `fk_topics_users_lastedit` (`topiclastedituser`),
  CONSTRAINT `fk_topics_forums` FOREIGN KEY (`forumid`) REFERENCES `forums` (`forumid`),
  CONSTRAINT `fk_topics_users` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`),
  CONSTRAINT `fk_topics_users_lastedit` FOREIGN KEY (`topiclastedituser`) REFERENCES `users` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `topics`
--

--
-- Definition of table `topicssubscriptions`
--

DROP TABLE IF EXISTS `topicssubscriptions`;
CREATE TABLE `topicssubscriptions` (
  `topicid` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  PRIMARY KEY (`topicid`,`userid`) USING BTREE,
  KEY `fk_topicssubscriptions_users` (`userid`),
  CONSTRAINT `fk_topicssubscriptions_topics` FOREIGN KEY (`topicid`) REFERENCES `topics` (`topicid`),
  CONSTRAINT `fk_topicssubscriptions_users` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `topicssubscriptions`
--

--
-- Definition of table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `userid` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `userprofile` longtext,
  `usersignature` longtext,
  `usergroupid` smallint(6) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `userbirthdate` datetime DEFAULT NULL,
  `userwebsite` varchar(255) DEFAULT NULL,
  `userguid` char(32) NOT NULL,
  `usertimezone` decimal(9,2) NOT NULL,
  `useremail` varchar(100) DEFAULT NULL,
  `useremailpolicy` int(11) DEFAULT NULL,
  `userphoto` varchar(1024) DEFAULT NULL,
  `userregistrationdate` datetime NOT NULL,
  `userexternalprofileurl` varchar(255) DEFAULT NULL,
  `UserProvider` varchar(32) NOT NULL,
  `UserProviderId` varchar(64) NOT NULL,
  `UserProviderLastCall` datetime NOT NULL,
  PRIMARY KEY (`userid`),
  KEY `fk_users_usersgroups` (`usergroupid`),
  CONSTRAINT `fk_users_usersgroups` FOREIGN KEY (`usergroupid`) REFERENCES `usersgroups` (`usergroupid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

--
-- Definition of table `usersgroups`
--

DROP TABLE IF EXISTS `usersgroups`;
CREATE TABLE `usersgroups` (
  `usergroupid` smallint(6) NOT NULL,
  `usergroupname` varchar(50) NOT NULL,
  PRIMARY KEY (`usergroupid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `usersgroups`
--
INSERT INTO `usersgroups` VALUES   (1,'Level 1');
INSERT INTO `usersgroups` VALUES   (2,'Level2');
INSERT INTO `usersgroups` VALUES   (3,'Moderator');
INSERT INTO `usersgroups` VALUES   (10,'Admin');

--
-- Definition of function `FNSplit`
--

DROP FUNCTION IF EXISTS `FNSplit`;

DELIMITER $$

DROP FUNCTION IF EXISTS `FNSplit` $$
CREATE DEFINER=`root`@`localhost` FUNCTION `FNSplit`(
  x VARCHAR(255),
  delim VARCHAR(12),
  pos INT
) RETURNS varchar(255) CHARSET latin1
RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos),
       LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1),
       delim, '') $$

DELIMITER ;
--
-- Definition of procedure `SPCleanDb`
--

DROP PROCEDURE IF EXISTS `SPCleanDb`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPCleanDb`()
BEGIN
  TRUNCATE TABLE Tags;
  TRUNCATE TABLE Messages;
  TRUNCATE TABLE topicssubscriptions;
  TRUNCATE TABLE Topics;
  TRUNCATE TABLE Templates;
  TRUNCATE TABLE Forums;
  TRUNCATE TABLE Users;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPForumsCategoriesGetAll`
--

DROP PROCEDURE IF EXISTS `SPForumsCategoriesGetAll`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPForumsCategoriesGetAll`()
BEGIN
SELECT
	CategoryId
	,CategoryName
	,CategoryOrder
FROM
	ForumsCategories
ORDER BY
	CategoryOrder;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPForumsGetByCategory`
--

DROP PROCEDURE IF EXISTS `SPForumsGetByCategory`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPForumsGetByCategory`()
BEGIN

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
ORDER BY
	C.CategoryOrder,
	F.ForumOrder;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPForumsGetByShortName`
--

DROP PROCEDURE IF EXISTS `SPForumsGetByShortName`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPForumsGetByShortName`(param_ShortName varchar(32))
BEGIN
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
	Forums F
	INNER JOIN ForumsCategories C ON F.CategoryId = C.CategoryId
WHERE
	F.ForumShortName = param_ShortName
	AND
	F.Active = 1;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPForumsGetUsedShortNames`
--

DROP PROCEDURE IF EXISTS `SPForumsGetUsedShortNames`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPForumsGetUsedShortNames`(
  param_ForumShortName varchar(32), param_SearchShortName varchar(32)
)
BEGIN

DECLARE CurrentValue varchar(32);
SELECT
	ForumShortName INTO CurrentValue
FROM
	Forums
WHERE
	ForumShortName = param_ForumShortName;


IF CurrentValue IS NULL THEN
	SELECT NULL As ForumShortName;
ELSE
	SELECT
		ForumShortName
	FROM
		Forums
	WHERE
		ForumShortName LIKE CONCAT(param_SearchShortName, '%');
END IF;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPForumsInsert`
--

DROP PROCEDURE IF EXISTS `SPForumsInsert`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPForumsInsert`(
	param_ForumName varchar(255)
	,param_ForumShortName varchar(32)
	,param_ForumDescription longtext
	,param_CategoryId int
	,param_UserId int
)
BEGIN

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
)
VALUES
(
	param_ForumName
	,param_ForumShortName
	,param_ForumDescription
	,param_CategoryId
	,param_UserId
	,UTC_TIMESTAMP()
	,UTC_TIMESTAMP()
	,param_UserId
	,1
	,0
	,0
	,0
);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPForumsUpdate`
--

DROP PROCEDURE IF EXISTS `SPForumsUpdate`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPForumsUpdate`(
	param_ForumShortName varchar(32)
	,param_ForumName varchar(255)
	,param_ForumDescription longtext
	,param_CategoryId int
	,param_UserId int
)
BEGIN


UPDATE Forums
SET
	ForumName = param_ForumName
	,ForumDescription = param_ForumDescription
	,CategoryId = param_CategoryId
	,ForumLastEditDate = UTC_TIMESTAMP()
	,ForumLastEditUser = param_UserId
WHERE
	ForumShortName = param_ForumShortName;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPForumsUpdateLastMessage`
--

DROP PROCEDURE IF EXISTS `SPForumsUpdateLastMessage`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPForumsUpdateLastMessage`(
	param_TopicId int
	,param_MessageId int
)
BEGIN

UPDATE Forums F, Topics T
SET
	F.ForumMessageCount = F.ForumMessageCount + 1
WHERE
  F.ForumId = T.ForumId
  AND
	T.TopicId = param_TopicId;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPForumsUpdateLastTopic`
--

DROP PROCEDURE IF EXISTS `SPForumsUpdateLastTopic`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPForumsUpdateLastTopic`(param_ForumId int)
BEGIN


UPDATE Forums F
SET
	F.ForumTopicCount = F.ForumTopicCount + 1
WHERE
	F.ForumId = param_ForumId;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPForumsUpdateRecount`
--

DROP PROCEDURE IF EXISTS `SPForumsUpdateRecount`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPForumsUpdateRecount`(param_ForumId int)
BEGIN

/*
	RECOUNTS THE CHILDREN MESSAGES AND TOPICS
*/
DECLARE var_ForumTopicCount int;
DECLARE var_ForumMessageCount int;

SELECT
  COUNT(TopicId)
	,SUM(TopicReplies)
INTO
  var_ForumTopicCount
  ,var_ForumMessageCount
FROM
	Topics
WHERE
	ForumId = param_ForumId
  AND
	Active = 1;

UPDATE Forums
SET
	ForumTopicCount = IFNULL(var_ForumTopicCount, 0)
	,ForumMessageCount = IFNULL(var_ForumMessageCount, 0)
WHERE
	ForumId = param_ForumId;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPMessagesDelete`
--

DROP PROCEDURE IF EXISTS `SPMessagesDelete`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPMessagesDelete`(
	param_TopicId int
	,param_MessageId int
	,param_UserId int
)
BEGIN

UPDATE Messages
SET
	Active = 0
	,MessageLastEditDate = UTC_TIMESTAMP()
	,MessageLastEditUser = param_UserId
WHERE
	TopicId = param_TopicId
	AND
	MessageId = param_MessageId;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPMessagesGetByTopic`
--

DROP PROCEDURE IF EXISTS `SPMessagesGetByTopic`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPMessagesGetByTopic`(param_TopicId int)
BEGIN

SELECT
  M.MessageId AS RowNumber
	,M.TopicId
	,M.MessageId
	,M.MessageBody
	,M.MessageCreationDate
	,M.MessageLastEditDate
	,M.ParentId
	,UserId
	,UserName
	,UserSignature
	,UserGroupId
	,UserGroupName
	,M.Active
FROM
	MessagesComplete M
WHERE
	M.TopicId = param_TopicId
ORDER BY M.TopicId, M.MessageId;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPMessagesGetByTopicFrom`
--

DROP PROCEDURE IF EXISTS `SPMessagesGetByTopicFrom`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPMessagesGetByTopicFrom`(
	param_TopicId int
	,param_FirstMsg int
	,param_Amount int
)
BEGIN

prepare stmt from "
SELECT
		M.MessageId AS RowNumber
		,M.TopicId
		,M.MessageId
		,M.MessageBody
		,M.MessageCreationDate
		,M.MessageLastEditDate
		,M.ParentId
		,UserId
		,UserName
		,UserSignature
		,UserGroupId
		,UserGroupName
		,M.Active
	FROM
		MessagesComplete M
	WHERE
		M.TopicId = ?
		AND
		M.MessageId > ?
  ORDER BY M.TopicId, M.MessageId
  LIMIT ?";

SET @param_TopicId = param_TopicId;
SET @param_FirstMsg = param_FirstMsg;
SET @param_Amount = param_Amount;

execute stmt using @param_TopicId, @param_FirstMsg, @param_Amount;

deallocate prepare stmt;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPMessagesGetByTopicLatest`
--

DROP PROCEDURE IF EXISTS `SPMessagesGetByTopicLatest`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPMessagesGetByTopicLatest`(param_TopicId int)
BEGIN

SELECT
	M.TopicId
	,M.MessageId
	,M.MessageBody
	,M.MessageCreationDate
	,M.MessageLastEditDate
	,M.ParentId
	,UserId
	,UserName
	,UserSignature
	,UserGroupId
	,UserGroupName
	,M.Active
FROM
	MessagesComplete M
WHERE
	M.TopicId = param_TopicId
ORDER BY
	TopicId, MessageId DESC
LIMIT 20;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPMessagesGetByTopicUpTo`
--

DROP PROCEDURE IF EXISTS `SPMessagesGetByTopicUpTo`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPMessagesGetByTopicUpTo`(
  param_TopicId int,
	param_FirstMsg int,
	param_LastMsg int
)
BEGIN

SELECT
	M.MessageId AS RowNumber
	,M.TopicId
	,M.MessageId
	,M.MessageBody
	,M.MessageCreationDate
	,M.MessageLastEditDate
	,M.ParentId
	,UserId
	,UserName
	,UserSignature
	,UserGroupId
	,UserGroupName
	,M.Active
FROM
	MessagesComplete M
WHERE
	M.TopicId = param_TopicId
	AND
	M.MessageId > param_FirstMsg
	AND
	M.MessageId <= param_LastMsg
ORDER BY M.TopicId, M.MessageId;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPMessagesInsert`
--

DROP PROCEDURE IF EXISTS `SPMessagesInsert`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPMessagesInsert`(
	param_TopicId int
	,param_MessageBody longtext
	,param_UserId int
	,OUT param_MessageId int
	,param_Ip varchar(15)
	,param_ParentId int
)
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
  ROLLBACK;
END;
START TRANSACTION;

  SELECT T.MessagesIdentity+1 INTO param_MessageId FROM Topics T WHERE T.TopicId = param_TopicId;

  UPDATE Topics T
  SET
	  T.MessagesIdentity = param_MessageId
  WHERE
	  TopicId = param_TopicId;

	INSERT INTO Messages
	(
	TopicId
	,MessageId
	,MessageBody
	,MessageCreationDate
	,MessageLastEditDate
	,MessageLastEditUser
	,UserId
	,Active
	,EditIp
	,ParentId
	)
	VALUES
	(
	param_TopicId
	,param_MessageId
	,param_MessageBody
	,UTC_TIMESTAMP()
	,UTC_TIMESTAMP()
	,param_UserId
	,param_UserId
	,1 -- Active
	,param_Ip
	,param_ParentId
	);


	SET @TopicId=param_TopicId;
  SET @MessageId=param_MessageId;
	-- Update topic
	CALL SPTopicsUpdateLastMessage (@TopicId, @MessageId);
	-- Update forums
	CALL SPForumsUpdateLastMessage (@TopicId, @MessageId);
COMMIT;


END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTagsGetMostViewed`
--

DROP PROCEDURE IF EXISTS `SPTagsGetMostViewed`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTagsGetMostViewed`(
  param_ForumId int
	,param_Top bigint
)
BEGIN


DECLARE var_TotalViews bigint;

SELECT
		SUM(T.TopicViews) INTO var_TotalViews
	FROM
		Topics T
	WHERE
		T.ForumId = param_ForumId;

                  
prepare stmt from "
SELECT
	Tag,
	TagViews,
	(TagViews*100.00)/? AS Weight
FROM
	(
  SELECT
		Tags.Tag
		,SUM(T.TopicViews) As TagViews
		,COUNT(T.TopicId) As TopicCount
	FROM
		Tags
		INNER JOIN Topics T ON Tags.TopicId = T.TopicId
	WHERE
		T.ForumId = ?
		AND
		T.Active = 1
	GROUP BY
		Tags.Tag
	ORDER BY SUM(T.TopicViews) desc
  LIMIT ?
	) T
ORDER BY Tag";

SET @var_TotalViews = var_TotalViews;
SET @param_ForumId = param_ForumId;
SET @param_Top = param_Top;
execute stmt using @var_TotalViews, @param_ForumId, @param_Top;

deallocate prepare stmt;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTagsInsert`
--

DROP PROCEDURE IF EXISTS `SPTagsInsert`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTagsInsert`(
	param_Tags varchar(256)
	,param_TopicId int
	,param_PreviousTags varchar(256)
)
BEGIN

DECLARE var_parts int;
DECLARE var_currentPart int;
/*define amount of tag parts*/
SELECT LENGTH(param_Tags) - LENGTH(REPLACE(param_Tags, ' ', '')) + 1 INTO var_parts;
SET var_currentPart = 1;


IF NOT param_PreviousTags IS NULL THEN
	DELETE FROM Tags
	WHERE
		TopicId = param_TopicId;
END IF;

WHILE (var_currentPart <= var_parts) DO
  IF FNSplit(param_Tags, ' ', var_currentPart) <> '' THEN
    INSERT INTO Tags
    (Tag,TopicId)
    SELECT FNSplit(param_Tags, ' ', var_currentPart), param_TopicId;
  END IF;

  SET var_currentPart = var_currentPart + 1;
END WHILE;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTemplatesDelete`
--

DROP PROCEDURE IF EXISTS `SPTemplatesDelete`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTemplatesDelete`(param_TemplateId int)
BEGIN

DELETE FROM Templates WHERE TemplateId = param_TemplateId;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTemplatesGet`
--

DROP PROCEDURE IF EXISTS `SPTemplatesGet`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTemplatesGet`(param_TemplateId int)
BEGIN


SELECT
	TemplateId
	,TemplateKey
	,TemplateDescription
	,TemplateIsCurrent
FROM
	Templates
WHERE
	TemplateId = param_TemplateId;


END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTemplatesGetAll`
--

DROP PROCEDURE IF EXISTS `SPTemplatesGetAll`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTemplatesGetAll`()
BEGIN

SELECT
	TemplateId
	,TemplateKey
	,TemplateDescription
	,TemplateIsCurrent
FROM
	Templates;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTemplatesGetCurrent`
--

DROP PROCEDURE IF EXISTS `SPTemplatesGetCurrent`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTemplatesGetCurrent`()
BEGIN
SELECT
	TemplateId
	,TemplateKey
	,TemplateDescription
FROM
	Templates
WHERE
	TemplateIsCurrent = 1;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTemplatesInsert`
--

DROP PROCEDURE IF EXISTS `SPTemplatesInsert`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTemplatesInsert`(
	param_TemplateKey varchar(16)
	,param_TemplateDescription varchar(256)
	,OUT param_TemplateId int
)
BEGIN
INSERT INTO Templates
(
	TemplateKey
	,TemplateDescription
	,TemplateDate
	,TemplateIsCurrent
)
VALUES
(
	param_TemplateKey
	,param_TemplateDescription
	,UTC_TIMESTAMP()
	,0
);

SELECT @TemplateId = LAST_INSERT_ID();
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTemplatesUpdateCurrent`
--

DROP PROCEDURE IF EXISTS `SPTemplatesUpdateCurrent`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTemplatesUpdateCurrent`(param_TemplateId int)
BEGIN


UPDATE Templates
SET
	TemplateIsCurrent = (CASE WHEN TemplateId = param_TemplateId THEN 1 ELSE 0 END);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTopicsAddVisit`
--

DROP PROCEDURE IF EXISTS `SPTopicsAddVisit`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTopicsAddVisit`(param_TopicId int)
BEGIN

UPDATE Topics
SET
	TopicViews = TopicViews+1
WHERE
	TopicId = param_TopicId;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTopicsClose`
--

DROP PROCEDURE IF EXISTS `SPTopicsClose`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTopicsClose`(
	param_TopicId int
	,param_UserId int
	,param_Ip varchar(15)
)
BEGIN

UPDATE Topics
	SET
		TopicIsClose = 1
		,TopicLastEditDate = UTC_TIMESTAMP()
		,TopicLastEditUser = param_UserId
		,TopicLastEditIp = param_Ip
	WHERE
		TopicId = param_TopicId;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTopicsDelete`
--

DROP PROCEDURE IF EXISTS `SPTopicsDelete`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTopicsDelete`(
	param_TopicId int
	,param_UserId int
	,param_Ip varchar(15)
)
BEGIN
/*
- SETS THE TOPIC ACTIVE=0
- UPDATES RECOUNT ON FORUM
*/

DECLARE var_ForumId int;
SELECT ForumId INTO var_ForumId FROM Topics WHERE TopicId = param_TopicId;


	UPDATE Topics
	SET
		Active = 0
		,TopicLastEditDate = UTC_TIMESTAMP()
		,TopicLastEditUser = param_UserId
		,TopicLastEditIp = param_Ip
	WHERE
		TopicId = param_TopicId;

  CALL SPForumsUpdateRecount (var_ForumId);
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTopicsGet`
--

DROP PROCEDURE IF EXISTS `SPTopicsGet`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTopicsGet`(param_TopicId int)
BEGIN

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
FROM
	TopicsComplete T
WHERE
	T.TopicId = param_TopicId;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTopicsGetByForum`
--

DROP PROCEDURE IF EXISTS `SPTopicsGetByForum`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTopicsGetByForum`(
	param_ForumId int
	,param_StartIndex int
	,param_Length int
)
BEGIN

prepare stmt from "
SELECT
		0	AS RowNumber
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
	FROM
		TopicsComplete T
		LEFT JOIN Messages M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
	WHERE
		T.ForumId = ?
  ORDER BY TopicOrder desc,TopicViews desc
  LIMIT ?, ?";

SET @param_ForumId = param_ForumId;
SET @param_StartIndex = param_StartIndex;
SET @param_Length = param_Length;

execute stmt using @param_ForumId, @param_StartIndex, @param_Length;

deallocate prepare stmt;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTopicsGetByForumLatest`
--

DROP PROCEDURE IF EXISTS `SPTopicsGetByForumLatest`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTopicsGetByForumLatest`(
	param_ForumId int
	,param_StartIndex int
	,param_Length int
)
BEGIN
prepare stmt from "
SELECT
		0	AS RowNumber
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
	FROM
		TopicsComplete T
		LEFT JOIN Messages M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
	WHERE
		T.ForumId = ?
  ORDER BY T.TopicId desc
  LIMIT ?, ?";

SET @param_ForumId = param_ForumId;
SET @param_StartIndex = param_StartIndex;
SET @param_Length = param_Length;

execute stmt using @param_ForumId, @param_StartIndex, @param_Length;

deallocate prepare stmt;


END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTopicsGetByForumUnanswered`
--

DROP PROCEDURE IF EXISTS `SPTopicsGetByForumUnanswered`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTopicsGetByForumUnanswered`(param_ForumId int)
BEGIN

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
FROM
	TopicsComplete T
	LEFT JOIN Messages M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
WHERE
	T.ForumId = param_ForumId
	AND
	T.TopicReplies = 0 -- Unanswered
	AND
	T.TopicOrder IS NULL -- Not sticky
ORDER BY
	TopicViews DESC, TopicId DESC;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTopicsGetByRelated`
--

DROP PROCEDURE IF EXISTS `SPTopicsGetByRelated`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTopicsGetByRelated`(
  param_Tag1 varchar(50)
	,param_Tag2 varchar(50)
	,param_Tag3 varchar(50)
	,param_Tag4 varchar(50)
	,param_Tag5 varchar(50)
	,param_Tag6 varchar(50)
	,param_TopicId int
	,param_Amount int
)
BEGIN

CREATE TEMPORARY TABLE Temp_TagsParams (Tag varchar(50) NULL);

INSERT INTO
  Temp_TagsParams (Tag)
SELECT
  param_Tag1
UNION
SELECT param_Tag2
UNION
SELECT param_Tag3
UNION
SELECT param_Tag4
UNION
SELECT param_Tag5
UNION
SELECT param_Tag6;

SELECT
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
FROM
	(
	SELECT
		T.TopicId
		,COUNT(T.Tag) AS TagCount
	FROM
		Tags T
		INNER JOIN Temp_TagsParams P ON T.Tag<=>P.Tag
	GROUP BY
		T.TopicId
	)
	Ta
	INNER JOIN TopicsComplete Topics ON Topics.TopicId = Ta.TopicId
WHERE
	Topics.TopicId <> param_TopicId
ORDER BY
	Ta.TagCount desc, Topics.TopicViews desc;

DROP TABLE Temp_TagsParams;


END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTopicsGetByTag`
--

DROP PROCEDURE IF EXISTS `SPTopicsGetByTag`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTopicsGetByTag`(
  param_Tag varchar(50),
	param_ForumId int
)
BEGIN

SET param_Tag = SUBSTRING(param_Tag, 1, CHAR_LENGTH(param_Tag)-1);
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
FROM
	Tags
	INNER JOIN TopicsComplete T ON T.TopicId = Tags.TopicId
WHERE
	Tags.Tag LIKE CONCAT(param_Tag, '%')
	AND
	T.ForumId = param_ForumId
ORDER BY TopicOrder DESC,TopicViews DESC;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTopicsGetByUser`
--

DROP PROCEDURE IF EXISTS `SPTopicsGetByUser`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTopicsGetByUser`(
	param_UserId int
)
BEGIN

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
FROM
	TopicsComplete T
	LEFT JOIN Messages M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
WHERE
	T.UserId = param_UserId
ORDER BY T.TopicId desc;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTopicsGetLatest`
--

DROP PROCEDURE IF EXISTS `SPTopicsGetLatest`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTopicsGetLatest`()
BEGIN

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
	FROM
		TopicsComplete T
		LEFT JOIN Messages M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1

	ORDER BY T.TopicId desc
  LIMIT 20;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTopicsGetMessagesByUser`
--

DROP PROCEDURE IF EXISTS `SPTopicsGetMessagesByUser`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTopicsGetMessagesByUser`(
	param_UserId int
)
BEGIN
/*
Gets the messages posted by the user grouped by topic
*/
SELECT
	T.TopicId
	,M.MessageId
	,M.MessageCreationDate
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
FROM
	TopicsComplete T
	INNER JOIN Messages M ON M.TopicId = T.TopicId
WHERE
	M.UserId = param_UserId
ORDER BY T.TopicId desc, M.MessageId desc;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTopicsGetUnanswered`
--

DROP PROCEDURE IF EXISTS `SPTopicsGetUnanswered`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTopicsGetUnanswered`()
BEGIN
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
	,T.ForumId
	,T.ForumName
	,T.ForumShortName
FROM
	TopicsComplete T
	LEFT JOIN Messages M ON M.TopicId = T.TopicId AND M.MessageId = T.LastMessageId AND M.Active = 1
WHERE
	T.TopicReplies = 0 -- Unanswered
	AND
	T.TopicOrder IS NULL -- Not sticky
ORDER BY
	TopicId DESC;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTopicsInsert`
--

DROP PROCEDURE IF EXISTS `SPTopicsInsert`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTopicsInsert`(
	param_TopicTitle varchar(255)
	,param_TopicShortName varchar(64)
	,param_TopicDescription longtext
	,param_UserId int
	,param_TopicTags varchar(256)
	,param_TopicOrder int
	,param_Forum varchar(32)
	,param_Ip varchar(15)
	,OUT param_TopicId int
)
BEGIN

DECLARE var_ForumId int;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
  ROLLBACK;
END;

SELECT ForumId INTO var_ForumId FROM Forums WHERE ForumShortName = param_Forum;
SET param_TopicTags = LOWER(param_TopicTags);

IF param_TopicOrder IS NOT NULL THEN
	SELECT param_TopicOrder = MAX(TopicOrder)+1 FROM Topics;
	SELECT param_TopicOrder = IFNULL(param_TopicOrder, 1);
END IF;

START TRANSACTION;

	INSERT INTO Topics
	(
	TopicTitle
	,TopicShortName
	,TopicDescription
	,TopicCreationDate
	,TopicLastEditDate
	,TopicViews
	,TopicReplies
	,UserId
	,TopicTags
	,ForumId
	,TopicLastEditUser
	,TopicLastEditIp
	,Active
	,TopicIsClose
	,TopicOrder
	,MessagesIdentity
	)
	VALUES
	(
	param_TopicTitle
	,param_TopicShortName
	,param_TopicDescription
	,UTC_TIMESTAMP()
	,UTC_TIMESTAMP()
	,0 -- TopicViews
	,0 -- TopicReplies
	,param_UserId
	,param_TopicTags
	,var_ForumId
	,param_UserId
	,param_Ip
	,1 -- Active
	,0 -- TopicIsClose
	,param_TopicOrder
	,0 -- MessageIdentity
	);

	SET param_TopicId = LAST_INSERT_ID();

	-- Add tags
  SET @Tags=param_TopicTags;
  SET @TopicId=param_TopicId;
  SET @ForumId=var_ForumId;
	CALL SPTagsInsert (@Tags, @TopicId, null);

	-- Update forums
	CALL SPForumsUpdateRecount (@ForumId);
COMMIT;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTopicsMove`
--

DROP PROCEDURE IF EXISTS `SPTopicsMove`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTopicsMove`(
	param_TopicId int
	,param_ForumId int
	,param_UserId int
	,param_Ip varchar(15)
)
BEGIN

DECLARE var_PreviousForumId int;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
  ROLLBACK;
  -- RESIGNAL;
END;
START TRANSACTION;
  SELECT ForumId INTO var_PreviousForumId FROM Topics WHERE TopicId = param_TopicId;
	UPDATE Topics
	SET
		ForumId = param_ForumId
		,TopicLastEditDate = UTC_TIMESTAMP()
		,TopicLastEditUser = param_UserId
		,TopicLastEditIp = param_Ip
	WHERE
		TopicId = param_TopicId;

  SET @ForumId = param_ForumId;
  SET @PreviousForumId = var_PreviousForumId;
	CALL SPForumsUpdateRecount (@ForumId);
	CALL SPForumsUpdateRecount (@PreviousForumId);

COMMIT;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTopicsOpen`
--

DROP PROCEDURE IF EXISTS `SPTopicsOpen`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTopicsOpen`(
	param_TopicId int
	,param_UserId int
	,param_Ip varchar(15)
)
BEGIN
	UPDATE Topics
	SET
		TopicIsClose = 0
		,TopicLastEditDate = UTC_TIMESTAMP()
		,TopicLastEditUser = param_UserId
		,TopicLastEditIp = param_Ip
	WHERE
		TopicId = param_TopicId;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTopicsSubscriptionsDelete`
--

DROP PROCEDURE IF EXISTS `SPTopicsSubscriptionsDelete`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTopicsSubscriptionsDelete`(
	param_TopicId int
	,param_UserId int
	,param_Userguid char(32)
)
BEGIN

DELETE S
FROM
	TopicsSubscriptions S
	INNER JOIN Users U
WHERE
  U.UserId = S.UserId
  AND
	S.TopicId = param_TopicId
	AND
	S.UserId = param_UserId
	AND
	U.UserGuid = param_UserGuid;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTopicsSubscriptionsGetByTopic`
--

DROP PROCEDURE IF EXISTS `SPTopicsSubscriptionsGetByTopic`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTopicsSubscriptionsGetByTopic`(
	param_TopicId int
)
BEGIN
SELECT
	U.UserId
	,U.UserName
	,U.UserEmail
	,U.UserEmailPolicy
	,U.UserGuid
FROM
	TopicsSubscriptions S
	INNER JOIN Users U ON U.UserId = S.UserId
WHERE
	TopicId = param_TopicId
	AND
	U.Active = 1;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTopicsSubscriptionsGetByUser`
--

DROP PROCEDURE IF EXISTS `SPTopicsSubscriptionsGetByUser`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTopicsSubscriptionsGetByUser`(
  param_UserId int
)
BEGIN

SELECT
	T.TopicId
	,T.TopicTitle
	,T.TopicShortName
	,T.ForumId
	,T.ForumName
	,T.ForumShortName
FROM
	TopicsSubscriptions S
	INNER JOIN TopicsComplete T ON T.TopicId = S.TopicId
WHERE
	S.UserId = param_UserId
ORDER BY
	S.TopicId DESC;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTopicsSubscriptionsInsert`
--

DROP PROCEDURE IF EXISTS `SPTopicsSubscriptionsInsert`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTopicsSubscriptionsInsert`(
	param_TopicId int
	,param_UserId int
)
BEGIN
IF NOT EXISTS (SELECT TopicId FROM TopicsSubscriptions WHERE TopicId = param_TopicId AND UserID = param_UserId) THEN
	INSERT INTO TopicsSubscriptions
	(TopicId, UserId)
	VALUES
	(param_TopicId, param_UserId);
END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTopicsUpdate`
--

DROP PROCEDURE IF EXISTS `SPTopicsUpdate`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTopicsUpdate`(
	param_TopicId int
	,param_TopicTitle varchar(256)
	,param_TopicDescription longtext
	,param_UserId int
	,param_TopicTags varchar(256)
	,param_TopicOrder int
	,param_Ip varchar(15)
)
BEGIN

DECLARE var_PreviousTags varchar(256);

START TRANSACTION;

  SELECT TopicTags INTO var_PreviousTags FROM Topics WHERE TopicId=param_TopicId;

  IF param_TopicOrder IS NOT NULL THEN
	  SELECT MAX(TopicOrder)+1 INTO param_TopicOrder FROM Topics;
  	SET param_TopicOrder = IFNULL(param_TopicOrder, 1);
  END IF;


	UPDATE Topics T
	SET
		TopicTitle = param_TopicTitle
		,TopicDescription = param_TopicDescription
		,TopicLastEditDate = UTC_TIMESTAMP()
		,TopicTags = param_TopicTags
		,TopicLastEditUser = param_UserId
		,TopicLastEditIp = param_Ip
		,TopicOrder = param_TopicOrder
	WHERE
		TopicId = param_TopicId;

	-- Edit tags
  SET @Tags=param_TopicTags;
  SET @TopicId=param_TopicId;
  SET @PreviousTags=var_PreviousTags;
	CALL SPTagsInsert (@Tags, @TopicId, @PreviousTags);

COMMIT;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPTopicsUpdateLastMessage`
--

DROP PROCEDURE IF EXISTS `SPTopicsUpdateLastMessage`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPTopicsUpdateLastMessage`(
	param_TopicId int
	,param_MessageId int
)
BEGIN

UPDATE Topics
SET
	TopicReplies = TopicReplies + 1
	,LastMessageId = param_MessageId
WHERE
	TopicId = param_TopicId;


END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPUsersDelete`
--

DROP PROCEDURE IF EXISTS `SPUsersDelete`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPUsersDelete`(param_UserId int)
BEGIN
UPDATE Users
SET
	Active = 0
WHERE
	UserId = param_UserId;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPUsersDemote`
--

DROP PROCEDURE IF EXISTS `SPUsersDemote`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPUsersDemote`(param_UserId int)
BEGIN
DECLARE var_UserGroupId int;
SELECT UserGroupId INTO var_UserGroupId FROM Users WHERE UserId = param_UserId;
SELECT MAX(UserGroupId) INTO var_UserGroupId FROM UsersGroups WHERE UserGroupId < var_UserGroupId;

IF var_UserGroupId IS NOT NULL THEN
	UPDATE Users
	SET
		UserGroupId = var_UserGroupId
	WHERE
		UserId = param_UserId;
END IF;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPUsersGet`
--

DROP PROCEDURE IF EXISTS `SPUsersGet`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPUsersGet`(param_UserId int)
BEGIN

SELECT
	U.UserId
	,U.UserName
	,U.UserProfile
	,U.UserSignature
	,U.UserGroupId
	,U.UserBirthDate
	,U.UserWebsite
	,U.UserTimezone
	,U.UserPhoto
	,U.UserRegistrationDate
	,U.UserExternalProfileUrl
	,U.UserEmail
	,U.UserEmailPolicy
	,UG.UserGroupId
	,UG.UserGroupName
FROM
	Users U
	INNER JOIN UsersGroups UG ON UG.UserGroupId = U.UserGroupId
WHERE
	U.UserId = param_UserId;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPUsersGetAll`
--

DROP PROCEDURE IF EXISTS `SPUsersGetAll`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPUsersGetAll`()
BEGIN
SELECT
	U.UserId
	,U.UserName
	,U.UserProfile
	,U.UserSignature
	,U.UserGroupId
	,U.UserBirthDate
	,U.UserWebsite
	,U.UserTimezone
	,U.UserPhoto
	,U.UserRegistrationDate
	,UG.UserGroupId
	,UG.UserGroupName
FROM
	Users U
	INNER JOIN UsersGroups UG ON UG.UserGroupId = U.UserGroupId
WHERE
	U.Active = 1
ORDER BY
	U.UserName;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPUsersGetByName`
--

DROP PROCEDURE IF EXISTS `SPUsersGetByName`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPUsersGetByName`(
  param_UserName varchar(50)
)
BEGIN

SELECT
	U.UserId
	,U.UserName
	,U.UserProfile
	,U.UserSignature
	,U.UserGroupId
	,U.UserBirthDate
	,U.UserWebsite
	,U.UserTimezone
	,U.UserPhoto
	,U.UserRegistrationDate
	,UG.UserGroupId
	,UG.UserGroupName
FROM
	Users U
	INNER JOIN UsersGroups UG ON UG.UserGroupId = U.UserGroupId
WHERE
	U.UserName LIKE CONCAT('%', param_UserName, '%')
	AND
	U.Active = 1
ORDER BY
	U.UserName;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPUsersGetByProvider`
--

DROP PROCEDURE IF EXISTS `SPUsersGetByProvider`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPUsersGetByProvider`(
	param_Provider varchar(32)
	,param_ProviderId varchar(64)
)
BEGIN
SELECT
	U.UserId
	,U.UserName
	,U.UserGroupId
	,U.UserGuid
	,U.UserTimeZone
	,U.UserExternalProfileUrl
	,U.UserProviderLastCall
	,U.UserEmail
FROM
	Users U
WHERE
	UserProvider = param_Provider
	AND
	UserProviderId = param_ProviderId
	AND
	U.Active = 1;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPUsersGetTestUser`
--

DROP PROCEDURE IF EXISTS `SPUsersGetTestUser`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPUsersGetTestUser`()
BEGIN
SELECT
	U.UserId
	,U.UserName
	,U.UserGroupId
	,U.UserGuid
	,U.UserTimeZone
	,U.UserExternalProfileUrl
	,U.UserProviderLastCall
	,U.UserEmail
FROM
	Users U
WHERE
	U.Active = 1
ORDER BY
	U.UserGroupId DESC
LIMIT 1;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPUsersGroupsGet`
--

DROP PROCEDURE IF EXISTS `SPUsersGroupsGet`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPUsersGroupsGet`(param_UserGroupId smallint)
BEGIN

SELECT
	UserGroupId
	,UserGroupName
FROM
	UsersGroups
WHERE
	UserGroupId = param_UserGroupId;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPUsersInsertFromProvider`
--

DROP PROCEDURE IF EXISTS `SPUsersInsertFromProvider`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPUsersInsertFromProvider`(
  param_UserName varchar(50)
	,param_UserProfile longtext
	,param_UserSignature longtext
	,param_UserGroupId smallint
	,param_UserBirthDate datetime
	,param_UserWebsite varchar(255)
	,param_UserGuid char(32)
	,param_UserTimezone decimal(9,2)
	,param_UserEmail varchar(100)
	,param_UserEmailPolicy int
	,param_UserPhoto varchar(1024)
	,param_UserExternalProfileUrl varchar(255)
	,param_UserProvider varchar(32)
	,param_UserProviderId varchar(64)
 )
BEGIN

-- If it is the first active user -> make it an admin
DECLARE var_UserCount int;
DECLARE var_UserId int;
SELECT COUNT(UserId) INTO var_UserCount FROM Users WHERE Active = 1;
IF IFNULL(var_UserCount, 0) > 0 THEN
 SET param_UserGroupId = 1;
ELSE
  SELECT MAX(UserGroupId) INTO param_UserGroupId FROM UsersGroups;
END IF;

INSERT INTO Users
   (UserName
   ,UserProfile
   ,UserSignature
   ,UserGroupId
   ,Active
   ,UserBirthDate
   ,UserWebsite
   ,UserGuid
   ,UserTimezone
   ,UserEmail
   ,UserEmailPolicy
   ,UserPhoto
   ,UserRegistrationDate
   ,UserExternalProfileUrl
   ,UserProvider
   ,UserProviderId
   ,UserProviderLastCall)
VALUES
	(param_UserName
   ,param_UserProfile
   ,param_UserSignature
   ,param_UserGroupId
   ,1 -- Active
   ,param_UserBirthDate
   ,param_UserWebsite
   ,param_UserGuid
   ,param_UserTimezone
   ,param_UserEmail
   ,param_UserEmailPolicy
   ,param_UserPhoto
   ,UTC_TIMESTAMP() -- RegitrationDate
   ,param_UserExternalProfileUrl
   ,param_UserProvider
   ,param_UserProviderId
   ,UTC_TIMESTAMP() -- UserProviderLastCall
	);

select LAST_INSERT_ID() INTO var_UserId;
SELECT
	U.UserId
	,U.UserName
	,U.UserGroupId
	,U.UserGuid
	,U.UserTimeZone
	,U.UserExternalProfileUrl
	,U.UserProviderLastCall
	,U.UserEmail
FROM
	Users U
WHERE
	U.UserId = var_UserId;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPUsersPromote`
--

DROP PROCEDURE IF EXISTS `SPUsersPromote`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPUsersPromote`(param_UserId int)
BEGIN
DECLARE var_UserGroupId int;
SELECT UserGroupId INTO var_UserGroupId FROM Users WHERE UserId = param_UserId;
SELECT MIN(UserGroupId) INTO var_UserGroupId FROM UsersGroups WHERE UserGroupId > var_UserGroupId;

IF var_UserGroupId IS NOT NULL THEN
	UPDATE Users
	SET
		UserGroupId = var_UserGroupId
	WHERE
		UserId = param_UserId;
END IF;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPUsersUpdate`
--

DROP PROCEDURE IF EXISTS `SPUsersUpdate`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPUsersUpdate`(
	param_UserId int
	,param_UserName varchar(50)
	,param_UserProfile longtext
	,param_UserSignature longtext
	,param_UserBirthDate datetime
	,param_UserWebsite varchar(255)
	,param_UserTimezone decimal(9,2)
	,param_UserEmail varchar(100)
	,param_UserEmailPolicy int
	,param_UserPhoto varchar(1024)
	,param_UserExternalProfileUrl varchar(255)
)
BEGIN

UPDATE Users
SET
UserName = param_UserName
,UserProfile = param_UserProfile
,UserSignature = param_UserSignature
,UserBirthDate = param_UserBirthDate
,UserWebsite = param_UserWebsite
,UserTimezone = param_UserTimezone
,UserEmail = param_UserEmail
,UserEmailPolicy = param_UserEmailPolicy
,UserPhoto = param_UserPhoto
,UserExternalProfileUrl = param_UserExternalProfileUrl
WHERE 
	UserId = param_UserId;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPUsersUpdateEmail`
--

DROP PROCEDURE IF EXISTS `SPUsersUpdateEmail`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPUsersUpdateEmail`(
	param_UserId int
	,param_UserEmail varchar(100)
	,param_UserEmailPolicy int
)
BEGIN
UPDATE Users
SET
	UserEmail = param_UserEmail
	,UserEmailPolicy = param_UserEmailPolicy
WHERE
	UserId = param_UserId;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of view `messagescomplete`
--

DROP TABLE IF EXISTS `messagescomplete`;
DROP VIEW IF EXISTS `messagescomplete`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `messagescomplete` AS select `m`.`topicid` AS `TopicId`,`m`.`messageid` AS `MessageId`,`m`.`messagebody` AS `MessageBody`,`m`.`messagecreationdate` AS `MessageCreationDate`,`m`.`messagelasteditdate` AS `MessageLastEditDate`,`m`.`parentid` AS `ParentId`,`m`.`userid` AS `UserId`,`m`.`active` AS `Active`,`u`.`username` AS `UserName`,`u`.`usersignature` AS `UserSignature`,`u`.`usergroupid` AS `UserGroupId`,`g`.`usergroupname` AS `UserGroupName` from (((`messages` `m` join `users` `u` on((`u`.`userid` = `m`.`userid`))) join `usersgroups` `g` on((`g`.`usergroupid` = `u`.`usergroupid`))) left join `messages` `p` on(((`p`.`topicid` = `m`.`topicid`) and (`p`.`messageid` = `m`.`parentid`) and (`p`.`active` = 1))));

--
-- Definition of view `topicscomplete`
--

DROP TABLE IF EXISTS `topicscomplete`;
DROP VIEW IF EXISTS `topicscomplete`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `topicscomplete` AS select `t`.`topicid` AS `TopicId`,`t`.`topictitle` AS `TopicTitle`,`t`.`topicshortname` AS `TopicShortName`,`t`.`topicdescription` AS `TopicDescription`,`t`.`topiccreationdate` AS `TopicCreationDate`,`t`.`topicviews` AS `TopicViews`,`t`.`topicreplies` AS `TopicReplies`,`t`.`userid` AS `UserId`,`t`.`topictags` AS `TopicTags`,`t`.`topicisclose` AS `TopicIsClose`,`t`.`topicorder` AS `TopicOrder`,`t`.`lastmessageid` AS `LastMessageId`,`u`.`username` AS `UserName`,`f`.`forumid` AS `ForumId`,`f`.`forumname` AS `ForumName`,`f`.`forumshortname` AS `ForumShortName` from ((`topics` `t` join `users` `u` on((`u`.`userid` = `t`.`userid`))) join `forums` `f` on((`f`.`forumid` = `t`.`forumid`))) where (`t`.`active` = 1);



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;