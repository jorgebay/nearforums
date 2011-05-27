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
-- Definition of table `flags`
--

DROP TABLE IF EXISTS `flags`;
CREATE TABLE `flags` (
  `flagId` int(11) NOT NULL AUTO_INCREMENT,
  `topicId` int(11) NOT NULL,
  `messageId` int(11) NOT NULL,
  `ip` varchar(15) CHARACTER SET latin1 NOT NULL,
  `flagdate` datetime NOT NULL,
  PRIMARY KEY (`flagId`,`topicId`) USING BTREE,
  UNIQUE KEY `ix_topicid_messageid_ip` (`topicId`,`messageId`,`ip`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `flags`
--

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `messages`
--

--
-- Definition of table `pagecontents`
--

DROP TABLE IF EXISTS `pagecontents`;
CREATE TABLE `pagecontents` (
  `pagecontentid` int(11) NOT NULL AUTO_INCREMENT,
  `pagecontenttitle` varchar(128) NOT NULL,
  `pagecontentbody` longtext NOT NULL,
  `pagecontentshortname` varchar(128) NOT NULL,
  `pagecontenteditdate` datetime NOT NULL,
  PRIMARY KEY (`pagecontentid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pagecontents`
--
INSERT INTO `pagecontents` VALUES   (1,'About','\r\n	<p>This forum is powered by <a href=\"http://www.nearforums.com\">Nearforums</a>, an open source forum engine.</p>\r\n	<p>Nearforums is released under <a href=\"http://nearforums.codeplex.com/license\" target=\"_blank\">MIT License</a>, you can get the source at <a href=\"http://www.nearforums.com/source-code\">www.nearforums.com/source-code</a>.</p>','about','2011-05-27 09:14:13');
INSERT INTO `pagecontents` VALUES   (2,'Terms and conditions','<h2>Legal Notices</h2>  <p>We, the Operators of this Website, provide it as a public service to our users.</p>  <p>Please carefully review the following basic rules that govern your use of the Website. Please note that your use of the Website constitutes your unconditional agreement to follow and be bound by these Terms and Conditions of Use. If you (the \"User\") do not agree to them, do not use the Website, provide any materials to the Website or download any materials from them.</p>  <p>The Operators reserve the right to update or modify these Terms and Conditions at any time without prior notice to User. Your use of the Website following any such change constitutes your unconditional agreement to follow and be bound by these Terms and Conditions as changed. For this reason, we encourage you to review these Terms and Conditions of Use whenever you use the Website.</p>  <p>These Terms and Conditions of Use apply to the use of the Website and do not extend to any linked third party sites. These Terms and Conditions and our <span>Privacy Policy</span>, which are hereby incorporated by reference, contain the entire agreement (the “Agreement”) between you and the Operators with respect to the Website. Any rights not expressly granted herein are reserved.</p>  <h2><span>Permitted and Prohibited Uses</span></h2>  <p>You may use the the Website for the sole purpose of sharing and exchanging ideas with other Users. You may not use the the Website to violate any applicable local, state, national, or international law, including without limitation any applicable laws relating to antitrust or other illegal trade or business practices, federal and state securities laws, regulations promulgated by the U.S. Securities and Exchange Commission, any rules of any national or other securities exchange, and any U.S. laws, rules, and regulations governing the export and re-export of commodities or technical data.</p>  <p>You may not upload or transmit any material that infringes or misappropriates any person\'s copyright, patent, trademark, or trade secret, or disclose via the the Website any information the disclosure of which would constitute a violation of any confidentiality obligations you may have.</p>  <p>You may not upload any viruses, worms, Trojan horses, or other forms of harmful computer code, nor subject the Website\'s network or servers to unreasonable traffic loads, or otherwise engage in conduct deemed disruptive to the ordinary operation of the Website.</p>  <p>You are strictly prohibited from communicating on or through the Website any unlawful, harmful, offensive, threatening, abusive, libelous, harassing, defamatory, vulgar, obscene, profane, hateful, fraudulent, sexually explicit, racially, ethnically, or otherwise objectionable material of any sort, including, but not limited to, any material that encourages conduct that would constitute a criminal offense, give rise to civil liability, or otherwise violate any applicable local, state, national, or international law.</p>  <p>You are expressly prohibited from compiling and using other Users\' personal information, including addresses, telephone numbers, fax numbers, email addresses or other contact information that may appear on the Website, for the purpose of creating or compiling marketing and/or mailing lists and from sending other Users unsolicited marketing materials, whether by facsimile, email, or other technological means.</p>  <p>You also are expressly prohibited from distributing Users\' personal information to third-party parties for marketing purposes. The Operators shall deem the compiling of marketing and mailing lists using Users\' personal information, the sending of unsolicited marketing materials to Users, or the distribution of Users\' personal information to third parties for marketing purposes as a material breach of these Terms and Conditions of Use, and the Operators reserve the right to terminate or suspend your access to and use of the Website and to suspend or revoke your membership in the consortium without refund of any membership dues paid.</p>  <p>The Operators note that unauthorized use of Users\' personal information in connection with unsolicited marketing correspondence also may constitute violations of various state and federal anti-spam statutes. The Operators reserve the right to report the abuse of Users\' personal information to the appropriate law enforcement and government authorities, and the Operators will fully cooperate with any authorities investigating violations of these laws.</p>  <h2><span>User Submissions</span></h2>  <p>The Operators do not want to receive confidential or proprietary information from you through the Website. Any material, information, or other communication you transmit or post (\"Contributions\") to the Website will be considered non-confidential.</p>  <p>All contributions to this site are licensed by you under the MIT License to anyone who wishes to use them, including the Operators.</p>  <p>If you work for a company or at a University, it\'s likely that you\'re not the copyright holder of anything you make, even in your free time. Before making contributions to this site, get written permission from your employer.</p>  <h2><span>User Discussion Lists and Forums</span></h2>  <p>The Operators may, but are not obligated to, monitor or review any areas on the Website where users transmit or post communications or communicate solely with each other, including but not limited to user forums and email lists, and the content of any such communications. The Operators, however, will have no liability related to the content of any such communications, whether or not arising under the laws of copyright, libel, privacy, obscenity, or otherwise. The Operators may edit or remove content on the the Website at their discretion at any time.</p>  <h2><span>Use of Personally Identifiable Information</span></h2>  <p>Information submitted to the Website is governed according to the Operators’s current <span>Privacy Policy</span> and the stated license of this website.</p>  <p>You agree to provide true, accurate, current, and complete information when registering with the Website. It is your responsibility to maintain and promptly update this account information to keep it true, accurate, current, and complete. If you provides any information that is fraudulent, untrue, inaccurate, incomplete, or not current, or we have reasonable grounds to suspect that such information is fraudulent, untrue, inaccurate, incomplete, or not current, we reserve the right to suspend or terminate your account without notice and to refuse any and all current and future use of the Website.</p>  <p>Although sections of the Website may be viewed simply by visiting the Website, in order to access some Content and/or additional features offered at the Website, you may need to sign on as a guest or register as a member. If you create an account on the Website, you may be asked to supply your name, address, a User ID and password. You are responsible for maintaining the confidentiality of the password and account and are fully responsible for all activities that occur in connection with your password or account. You agree to immediately notify us of any unauthorized use of either your password or account or any other breach of security. You further agree that you will not permit others, including those whose accounts have been terminated, to access the Website using your account or User ID. You grant the Operators and all other persons or entities involved in the operation of the Website the right to transmit, monitor, retrieve, store, and use your information in connection with the operation of the Website and in the provision of services to you. The Operators cannot and do not assume any responsibility or liability for any information you submit, or your or third parties’ use or misuse of information transmitted or received using website. To learn more about how we protect the privacy of the personal information in your account, please visit our<span>Privacy Policy</span>.</p>  <h2><span>Indemnification</span></h2>  <p>You agree to defend, indemnify and hold harmless the Operators, agents, vendors or suppliers from and against any and all claims, damages, costs and expenses, including reasonable attorneys\' fees, arising from or related to your use or misuse of the Website, including, without limitation, your violation of these Terms and Conditions, the infringement by you, or any other subscriber or user of your account, of any intellectual property right or other right of any person or entity.</p>  <h2><span>Termination</span></h2>  <p>These Terms and Conditions of Use are effective until terminated by either party. If you no longer agree to be bound by these Terms and Conditions, you must cease use of the Website. If you are dissatisfied with the Website, their content, or any of these terms, conditions, and policies, your sole legal remedy is to discontinue using the Website. The Operators reserve the right to terminate or suspend your access to and use of the Website, or parts of the Website, without notice, if we believe, in our sole discretion, that such use (i) is in violation of any applicable law; (ii) is harmful to our interests or the interests, including intellectual property or other rights, of another person or entity; or (iii) where the Operators have reason to believe that you are in violation of these Terms and Conditions of Use.</p>  <h2><span>WARRANTY DISCLAIMER</span></h2>  <p>THE WEBSITE AND ASSOCIATED MATERIALS ARE PROVIDED ON AN \"AS IS\" AND \"AS AVAILABLE\" BASIS. TO THE FULL EXTENT PERMISSIBLE BY APPLICABLE LAW, THE OPERATORS DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENTOF INTELLECTUAL PROPERTY. THE OPERATORS MAKE NO REPRESENTATIONS OR WARRANTY THAT THE WEBSITE WILL MEET YOUR REQUIREMENTS, OR THAT YOUR USE OF THE WEBSITE WILL BE UNINTERRUPTED, TIMELY, SECURE, OR ERROR FREE; NOR DO THE OPERATORS MAKE ANY REPRESENTATION OR WARRANTY AS TO THE RESULTS THAT MAY BE OBTAINED FROM THE USE OF THE WEBSITE. THE OPERATORS MAKE NO REPRESENTATIONS OR WARRANTIES OF ANY KIND, EXPRESS OR IMPLIED, AS TO THE OPERATION OF THE WEBSITE OR THE INFORMATION, CONTENT, MATERIALS, OR PRODUCTS INCLUDED ON THE WEBSITE.</p>  <p>IN NO EVENT SHALL THE OPERATORS OR ANY OF THEIR AGENTS, VENDORS OR SUPPLIERS BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF PROFITS, BUSINESS INTERRUPTION, LOSS OF INFORMATION) ARISING OUT OF THE USE, MISUSE OF OR INABILITY TO USE THE WEBSITE, EVEN IF THE OPERATORS HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. THIS DISCLAIMER CONSTITUTES AN ESSENTIAL PART OF THIS AGREEMENT. BECAUSE SOME JURISDICTIONS PROHIBIT THE EXCLUSION OR LIMITATION OF LIABILITY FOR CONSEQUENTIAL OR INCIDENTAL DAMAGES, THE ABOVE LIMITATION MAY NOT APPLY TO YOU.</p>  <p>YOU UNDERSTAND AND AGREE THAT ANY CONTENT DOWNLOADED OR OTHERWISE OBTAINED THROUGH THE USE OF THE WEBSITE IS AT YOUR OWN DISCRETION AND RISK AND THAT YOU WILL BE SOLELY RESPONSIBLE FOR ANY DAMAGE TO YOUR COMPUTER SYSTEM OR LOSS OF DATA OR BUSINESS INTERRUPTION THAT RESULTS FROM THE DOWNLOAD OF CONTENT. THE OPERATORS SHALL NOT BE RESPONSIBLE FOR ANY LOSS OR DAMAGE CAUSED, OR ALLEGED TO HAVE BEEN CAUSED, DIRECTLY OR INDIRECTLY, BY THE INFORMATION OR IDEAS CONTAINED, SUGGESTED OR REFERENCED IN OR APPEARING ON THE WEBSITE. YOUR PARTICIPATION IN THE WEBSITE IS SOLELY AT YOUR OWN RISK. NO ADVICE OR INFORMATION, WHETHER ORAL OR WRITTEN, OBTAINED BY YOU FROM THE OPERATORS OR THROUGH THE OPERATORS, THEIR EMPLOYEES, OR THIRD PARTIES SHALL CREATE ANY WARRANTY NOT EXPRESSLY MADE HEREIN. YOU ACKNOWLEDGE, BY YOUR USE OF THE THE WEBSITE, THAT YOUR USE OF THE WEBSITE IS AT YOUR SOLE RISK.</p>  <p>LIABILITY LIMITATION. UNDER NO CIRCUMSTANCES AND UNDER NO LEGAL OR EQUITABLE THEORY, WHETHER IN TORT, CONTRACT, NEGLIGENCE, STRICT LIABILITY OR OTHERWISE, SHALL THE OPERATORS OR ANY OF THEIR AGENTS, VENDORS OR SUPPLIERS BE LIABLE TO USER OR TO ANY OTHER PERSON FOR ANY INDIRECT, SPECIAL, INCIDENTAL OR CONSEQUENTIAL LOSSES OR DAMAGES OF ANY NATURE ARISING OUT OF OR IN CONNECTION WITH THE USE OF OR INABILITY TO USE THE THE WEBSITE OR FOR ANY BREACH OF SECURITY ASSOCIATED WITH THE TRANSMISSION OF SENSITIVE INFORMATION THROUGH THE WEBSITE OR FOR ANY INFORMATION OBTAINED THROUGH THE WEBSITE, INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOST PROFITS, LOSS OF GOODWILL, LOSS OR CORRUPTION OF DATA, WORK STOPPAGE, ACCURACY OF RESULTS, OR COMPUTER FAILURE OR MALFUNCTION, EVEN IF AN AUTHORIZED REPRESENTATIVE OF THE OPERATORS HAS BEEN ADVISED OF OR SHOULD HAVE KNOWN OF THE POSSIBILITY OF SUCH DAMAGES.</p>  <p>THE OPERATORS\'S TOTAL CUMULATIVE LIABILITY FOR ANY AND ALL CLAIMS IN CONNECTION WITH THE WEBSITE WILL NOT EXCEED FIVE U.S. DOLLARS ($5.00). USER AGREES AND ACKNOWLEDGES THAT THE FOREGOING LIMITATIONS ON LIABILITY ARE AN ESSENTIAL BASIS OF THE BARGAIN AND THAT THE OPERATORS WOULD NOT PROVIDE THE WEBSITE ABSENT SUCH LIMITATION.</p>  <h2>Links to Other Materials.</h2>  <p>The Website may contain links to sites owned or operated by independent third parties. These links are provided for your convenience and reference only. We do not control such sites and, therefore, we are not responsible for any content posted on these sites. The fact that the Operators offer such links should not be construed in any way as an endorsement, authorization, or sponsorship of that site, its content or the companies or products referenced therein, and the Operators reserve the right to note its lack of affiliation, sponsorship, or endorsement on the Website. If you decide to access any of the third party sites linked to by the Website, you do this entirely at your own risk. Because some sites employ automated search results or otherwise link you to sites containing information that may be deemed inappropriate or offensive, the Operators cannot be held responsible for the accuracy, copyright compliance, legality, or decency of material contained in third party sites, and you hereby irrevocably waive any claim against us with respect to such sites.</p>  <h2><span>Notification Of Possible Copyright Infringement</span></h2>  <p>In the event you believe that material or content published on the Website may infringe on your copyright or that of another, please <span>contact</span> us.</p>','terms','2011-05-27 09:14:13');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
  `PasswordResetGuid` varchar(100) DEFAULT NULL,
  `PasswordResetGuidExpireDate` datetime DEFAULT NULL,
  PRIMARY KEY (`userid`),
  KEY `fk_users_usersgroups` (`usergroupid`),
  CONSTRAINT `fk_users_usersgroups` FOREIGN KEY (`usergroupid`) REFERENCES `usersgroups` (`usergroupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `usersgroups`
--
INSERT INTO `usersgroups` VALUES   (1,'Level 1');
INSERT INTO `usersgroups` VALUES   (2,'Level2');
INSERT INTO `usersgroups` VALUES   (3,'Moderator');
INSERT INTO `usersgroups` VALUES   (10,'Admin');

--
-- Definition of function `FNCastToInt`
--

DROP FUNCTION IF EXISTS `FNCastToInt`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `FNCastToInt`(number bigint) RETURNS int(11)
BEGIN
  return number;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `FNSplit`
--

DROP FUNCTION IF EXISTS `FNSplit`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `FNSplit`(
  x VARCHAR(255),
  delim VARCHAR(12),
  pos INT
) RETURNS varchar(255) CHARSET latin1
RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos),
       LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1),
       delim, '') $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

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
  TRUNCATE TABLE PageContents;
  TRUNCATE TABLE Flags;
/*
DEFAULT VALUES
*/
INSERT INTO PageContents (PageContentTitle, PageContentShortName, PageContentEditDate, PageContentBody)
	VALUES ('About', 'about', UTC_TIMESTAMP(), '
	<p>This forum is powered by <a href="http://www.nearforums.com">Nearforums</a>, an open source forum engine.</p>
	<p>Nearforums is released under <a href="http://nearforums.codeplex.com/license" target="_blank">MIT License</a>, you can get the source at <a href="http://www.nearforums.com/source-code">www.nearforums.com/source-code</a>.</p>');
INSERT INTO PageContents (PageContentTitle, PageContentShortName, PageContentEditDate, PageContentBody)
	VALUES ('Terms and conditions', 'terms', UTC_TIMESTAMP(),
	'<h2>Legal Notices</h2>  <p>We, the Operators of this Website, provide it as a public service to our users.</p>  <p>Please carefully review the following basic rules that govern your use of the Website. Please note that your use of the Website constitutes your unconditional agreement to follow and be bound by these Terms and Conditions of Use. If you (the "User") do not agree to them, do not use the Website, provide any materials to the Website or download any materials from them.</p>  <p>The Operators reserve the right to update or modify these Terms and Conditions at any time without prior notice to User. Your use of the Website following any such change constitutes your unconditional agreement to follow and be bound by these Terms and Conditions as changed. For this reason, we encourage you to review these Terms and Conditions of Use whenever you use the Website.</p>  <p>These Terms and Conditions of Use apply to the use of the Website and do not extend to any linked third party sites. These Terms and Conditions and our <span>Privacy Policy</span>, which are hereby incorporated by reference, contain the entire agreement (the “Agreement”) between you and the Operators with respect to the Website. Any rights not expressly granted herein are reserved.</p>  <h2><span>Permitted and Prohibited Uses</span></h2>  <p>You may use the the Website for the sole purpose of sharing and exchanging ideas with other Users. You may not use the the Website to violate any applicable local, state, national, or international law, including without limitation any applicable laws relating to antitrust or other illegal trade or business practices, federal and state securities laws, regulations promulgated by the U.S. Securities and Exchange Commission, any rules of any national or other securities exchange, and any U.S. laws, rules, and regulations governing the export and re-export of commodities or technical data.</p>  <p>You may not upload or transmit any material that infringes or misappropriates any person''s copyright, patent, trademark, or trade secret, or disclose via the the Website any information the disclosure of which would constitute a violation of any confidentiality obligations you may have.</p>  <p>You may not upload any viruses, worms, Trojan horses, or other forms of harmful computer code, nor subject the Website''s network or servers to unreasonable traffic loads, or otherwise engage in conduct deemed disruptive to the ordinary operation of the Website.</p>  <p>You are strictly prohibited from communicating on or through the Website any unlawful, harmful, offensive, threatening, abusive, libelous, harassing, defamatory, vulgar, obscene, profane, hateful, fraudulent, sexually explicit, racially, ethnically, or otherwise objectionable material of any sort, including, but not limited to, any material that encourages conduct that would constitute a criminal offense, give rise to civil liability, or otherwise violate any applicable local, state, national, or international law.</p>  <p>You are expressly prohibited from compiling and using other Users'' personal information, including addresses, telephone numbers, fax numbers, email addresses or other contact information that may appear on the Website, for the purpose of creating or compiling marketing and/or mailing lists and from sending other Users unsolicited marketing materials, whether by facsimile, email, or other technological means.</p>  <p>You also are expressly prohibited from distributing Users'' personal information to third-party parties for marketing purposes. The Operators shall deem the compiling of marketing and mailing lists using Users'' personal information, the sending of unsolicited marketing materials to Users, or the distribution of Users'' personal information to third parties for marketing purposes as a material breach of these Terms and Conditions of Use, and the Operators reserve the right to terminate or suspend your access to and use of the Website and to suspend or revoke your membership in the consortium without refund of any membership dues paid.</p>  <p>The Operators note that unauthorized use of Users'' personal information in connection with unsolicited marketing correspondence also may constitute violations of various state and federal anti-spam statutes. The Operators reserve the right to report the abuse of Users'' personal information to the appropriate law enforcement and government authorities, and the Operators will fully cooperate with any authorities investigating violations of these laws.</p>  <h2><span>User Submissions</span></h2>  <p>The Operators do not want to receive confidential or proprietary information from you through the Website. Any material, information, or other communication you transmit or post ("Contributions") to the Website will be considered non-confidential.</p>  <p>All contributions to this site are licensed by you under the MIT License to anyone who wishes to use them, including the Operators.</p>  <p>If you work for a company or at a University, it''s likely that you''re not the copyright holder of anything you make, even in your free time. Before making contributions to this site, get written permission from your employer.</p>  <h2><span>User Discussion Lists and Forums</span></h2>  <p>The Operators may, but are not obligated to, monitor or review any areas on the Website where users transmit or post communications or communicate solely with each other, including but not limited to user forums and email lists, and the content of any such communications. The Operators, however, will have no liability related to the content of any such communications, whether or not arising under the laws of copyright, libel, privacy, obscenity, or otherwise. The Operators may edit or remove content on the the Website at their discretion at any time.</p>  <h2><span>Use of Personally Identifiable Information</span></h2>  <p>Information submitted to the Website is governed according to the Operators’s current <span>Privacy Policy</span> and the stated license of this website.</p>  <p>You agree to provide true, accurate, current, and complete information when registering with the Website. It is your responsibility to maintain and promptly update this account information to keep it true, accurate, current, and complete. If you provides any information that is fraudulent, untrue, inaccurate, incomplete, or not current, or we have reasonable grounds to suspect that such information is fraudulent, untrue, inaccurate, incomplete, or not current, we reserve the right to suspend or terminate your account without notice and to refuse any and all current and future use of the Website.</p>  <p>Although sections of the Website may be viewed simply by visiting the Website, in order to access some Content and/or additional features offered at the Website, you may need to sign on as a guest or register as a member. If you create an account on the Website, you may be asked to supply your name, address, a User ID and password. You are responsible for maintaining the confidentiality of the password and account and are fully responsible for all activities that occur in connection with your password or account. You agree to immediately notify us of any unauthorized use of either your password or account or any other breach of security. You further agree that you will not permit others, including those whose accounts have been terminated, to access the Website using your account or User ID. You grant the Operators and all other persons or entities involved in the operation of the Website the right to transmit, monitor, retrieve, store, and use your information in connection with the operation of the Website and in the provision of services to you. The Operators cannot and do not assume any responsibility or liability for any information you submit, or your or third parties’ use or misuse of information transmitted or received using website. To learn more about how we protect the privacy of the personal information in your account, please visit our<span>Privacy Policy</span>.</p>  <h2><span>Indemnification</span></h2>  <p>You agree to defend, indemnify and hold harmless the Operators, agents, vendors or suppliers from and against any and all claims, damages, costs and expenses, including reasonable attorneys'' fees, arising from or related to your use or misuse of the Website, including, without limitation, your violation of these Terms and Conditions, the infringement by you, or any other subscriber or user of your account, of any intellectual property right or other right of any person or entity.</p>  <h2><span>Termination</span></h2>  <p>These Terms and Conditions of Use are effective until terminated by either party. If you no longer agree to be bound by these Terms and Conditions, you must cease use of the Website. If you are dissatisfied with the Website, their content, or any of these terms, conditions, and policies, your sole legal remedy is to discontinue using the Website. The Operators reserve the right to terminate or suspend your access to and use of the Website, or parts of the Website, without notice, if we believe, in our sole discretion, that such use (i) is in violation of any applicable law; (ii) is harmful to our interests or the interests, including intellectual property or other rights, of another person or entity; or (iii) where the Operators have reason to believe that you are in violation of these Terms and Conditions of Use.</p>  <h2><span>WARRANTY DISCLAIMER</span></h2>  <p>THE WEBSITE AND ASSOCIATED MATERIALS ARE PROVIDED ON AN "AS IS" AND "AS AVAILABLE" BASIS. TO THE FULL EXTENT PERMISSIBLE BY APPLICABLE LAW, THE OPERATORS DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENTOF INTELLECTUAL PROPERTY. THE OPERATORS MAKE NO REPRESENTATIONS OR WARRANTY THAT THE WEBSITE WILL MEET YOUR REQUIREMENTS, OR THAT YOUR USE OF THE WEBSITE WILL BE UNINTERRUPTED, TIMELY, SECURE, OR ERROR FREE; NOR DO THE OPERATORS MAKE ANY REPRESENTATION OR WARRANTY AS TO THE RESULTS THAT MAY BE OBTAINED FROM THE USE OF THE WEBSITE. THE OPERATORS MAKE NO REPRESENTATIONS OR WARRANTIES OF ANY KIND, EXPRESS OR IMPLIED, AS TO THE OPERATION OF THE WEBSITE OR THE INFORMATION, CONTENT, MATERIALS, OR PRODUCTS INCLUDED ON THE WEBSITE.</p>  <p>IN NO EVENT SHALL THE OPERATORS OR ANY OF THEIR AGENTS, VENDORS OR SUPPLIERS BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF PROFITS, BUSINESS INTERRUPTION, LOSS OF INFORMATION) ARISING OUT OF THE USE, MISUSE OF OR INABILITY TO USE THE WEBSITE, EVEN IF THE OPERATORS HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. THIS DISCLAIMER CONSTITUTES AN ESSENTIAL PART OF THIS AGREEMENT. BECAUSE SOME JURISDICTIONS PROHIBIT THE EXCLUSION OR LIMITATION OF LIABILITY FOR CONSEQUENTIAL OR INCIDENTAL DAMAGES, THE ABOVE LIMITATION MAY NOT APPLY TO YOU.</p>  <p>YOU UNDERSTAND AND AGREE THAT ANY CONTENT DOWNLOADED OR OTHERWISE OBTAINED THROUGH THE USE OF THE WEBSITE IS AT YOUR OWN DISCRETION AND RISK AND THAT YOU WILL BE SOLELY RESPONSIBLE FOR ANY DAMAGE TO YOUR COMPUTER SYSTEM OR LOSS OF DATA OR BUSINESS INTERRUPTION THAT RESULTS FROM THE DOWNLOAD OF CONTENT. THE OPERATORS SHALL NOT BE RESPONSIBLE FOR ANY LOSS OR DAMAGE CAUSED, OR ALLEGED TO HAVE BEEN CAUSED, DIRECTLY OR INDIRECTLY, BY THE INFORMATION OR IDEAS CONTAINED, SUGGESTED OR REFERENCED IN OR APPEARING ON THE WEBSITE. YOUR PARTICIPATION IN THE WEBSITE IS SOLELY AT YOUR OWN RISK. NO ADVICE OR INFORMATION, WHETHER ORAL OR WRITTEN, OBTAINED BY YOU FROM THE OPERATORS OR THROUGH THE OPERATORS, THEIR EMPLOYEES, OR THIRD PARTIES SHALL CREATE ANY WARRANTY NOT EXPRESSLY MADE HEREIN. YOU ACKNOWLEDGE, BY YOUR USE OF THE THE WEBSITE, THAT YOUR USE OF THE WEBSITE IS AT YOUR SOLE RISK.</p>  <p>LIABILITY LIMITATION. UNDER NO CIRCUMSTANCES AND UNDER NO LEGAL OR EQUITABLE THEORY, WHETHER IN TORT, CONTRACT, NEGLIGENCE, STRICT LIABILITY OR OTHERWISE, SHALL THE OPERATORS OR ANY OF THEIR AGENTS, VENDORS OR SUPPLIERS BE LIABLE TO USER OR TO ANY OTHER PERSON FOR ANY INDIRECT, SPECIAL, INCIDENTAL OR CONSEQUENTIAL LOSSES OR DAMAGES OF ANY NATURE ARISING OUT OF OR IN CONNECTION WITH THE USE OF OR INABILITY TO USE THE THE WEBSITE OR FOR ANY BREACH OF SECURITY ASSOCIATED WITH THE TRANSMISSION OF SENSITIVE INFORMATION THROUGH THE WEBSITE OR FOR ANY INFORMATION OBTAINED THROUGH THE WEBSITE, INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOST PROFITS, LOSS OF GOODWILL, LOSS OR CORRUPTION OF DATA, WORK STOPPAGE, ACCURACY OF RESULTS, OR COMPUTER FAILURE OR MALFUNCTION, EVEN IF AN AUTHORIZED REPRESENTATIVE OF THE OPERATORS HAS BEEN ADVISED OF OR SHOULD HAVE KNOWN OF THE POSSIBILITY OF SUCH DAMAGES.</p>  <p>THE OPERATORS''S TOTAL CUMULATIVE LIABILITY FOR ANY AND ALL CLAIMS IN CONNECTION WITH THE WEBSITE WILL NOT EXCEED FIVE U.S. DOLLARS ($5.00). USER AGREES AND ACKNOWLEDGES THAT THE FOREGOING LIMITATIONS ON LIABILITY ARE AN ESSENTIAL BASIS OF THE BARGAIN AND THAT THE OPERATORS WOULD NOT PROVIDE THE WEBSITE ABSENT SUCH LIMITATION.</p>  <h2>Links to Other Materials.</h2>  <p>The Website may contain links to sites owned or operated by independent third parties. These links are provided for your convenience and reference only. We do not control such sites and, therefore, we are not responsible for any content posted on these sites. The fact that the Operators offer such links should not be construed in any way as an endorsement, authorization, or sponsorship of that site, its content or the companies or products referenced therein, and the Operators reserve the right to note its lack of affiliation, sponsorship, or endorsement on the Website. If you decide to access any of the third party sites linked to by the Website, you do this entirely at your own risk. Because some sites employ automated search results or otherwise link you to sites containing information that may be deemed inappropriate or offensive, the Operators cannot be held responsible for the accuracy, copyright compliance, legality, or decency of material contained in third party sites, and you hereby irrevocably waive any claim against us with respect to such sites.</p>  <h2><span>Notification Of Possible Copyright Infringement</span></h2>  <p>In the event you believe that material or content published on the Website may infringe on your copyright or that of another, please <span>contact</span> us.</p>');


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
/*
	Gets used short names for forums
	returns:
		IF NOT USED SHORTNAME: empty result set
		IF USED SHORTNAME: resultset with amount of rows used
*/

DECLARE CurrentValue varchar(32);
SELECT
	ForumShortName INTO CurrentValue
FROM
	Forums
WHERE
	ForumShortName = param_ForumShortName;


IF CurrentValue IS NULL THEN
	SELECT NULL As ForumShortName FROM Forums WHERE 1=0;
ELSE
	SELECT
		ForumShortName
	FROM
		Forums
	WHERE
		ForumShortName LIKE CONCAT(param_SearchShortName, '%')
    OR
		ForumShortName = param_ForumShortName;

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
-- Definition of procedure `SPMessagesFlag`
--

DROP PROCEDURE IF EXISTS `SPMessagesFlag`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPMessagesFlag`(
	param_TopicId int
	,param_MessageId int
	,param_Ip varchar(15)
)
BEGIN
	INSERT IGNORE INTO Flags
	(TopicId, MessageId, Ip, FlagDate)
	VALUES
	(param_TopicId, param_MessageId, param_Ip, UTC_TIMESTAMP());
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPMessagesFlagsClear`
--

DROP PROCEDURE IF EXISTS `SPMessagesFlagsClear`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPMessagesFlagsClear`(
	param_TopicId int
	,param_MessageId int
)
BEGIN
DELETE FROM
	Flags
WHERE
	TopicId = param_TopicId
	AND
	MessageId = param_MessageId;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPMessagesFlagsGetAll`
--

DROP PROCEDURE IF EXISTS `SPMessagesFlagsGetAll`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPMessagesFlagsGetAll`()
BEGIN
/*
	Lists all flagged messages (not topics)
*/
SELECT
	F.TopicId
	,F.MessageId
	,FNCastToInt(COUNT(FlagId)) AS TotalFlags
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
ORDER BY COUNT(FlagId) DESC, F.TopicId;

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
-- Definition of procedure `SPPageContentsDelete`
--

DROP PROCEDURE IF EXISTS `SPPageContentsDelete`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPPageContentsDelete`(
  param_PageContentShortName varchar(128)
)
BEGIN
DELETE FROM PageContents
WHERE
	PageContentShortName = param_PageContentShortName;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPPageContentsGet`
--

DROP PROCEDURE IF EXISTS `SPPageContentsGet`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPPageContentsGet`(
  param_PageContentShortName varchar(128)
)
BEGIN
SELECT
	PageContentId
	,PageContentTitle
	,PageContentBody
	,PageContentShortName
FROM
	PageContents
WHERE
	PageContentShortName = param_PageContentShortName;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPPageContentsGetAll`
--

DROP PROCEDURE IF EXISTS `SPPageContentsGetAll`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPPageContentsGetAll`()
BEGIN
SELECT
	PageContentId
	,PageContentTitle
	,PageContentBody
	,PageContentShortName
FROM
	PageContents
ORDER BY
	PageContentTitle;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPPageContentsGetUsedShortNames`
--

DROP PROCEDURE IF EXISTS `SPPageContentsGetUsedShortNames`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPPageContentsGetUsedShortNames`(
	param_PageContentShortName varchar(32),
	param_SearchShortName varchar(32)
)
BEGIN
/*
	Gets used short names for PageContents
	returns:
		IF NOT USED SHORTNAME: empty result set
		IF USED SHORTNAME: resultset with amount of rows used
*/
DECLARE var_CurrentValue varchar(32);
SELECT
	PageContentShortName INTO var_CurrentValue
FROM
	PageContents
WHERE
	PageContentShortName = param_PageContentShortName;


IF var_CurrentValue IS NULL THEN
	SELECT NULL As ForumShortName FROM pagecontents WHERE 1=0;
ELSE
	SELECT
		PageContentShortName
	FROM
		PageContents
	WHERE
		PageContentShortName LIKE CONCAT(param_SearchShortName, '%')
		OR
		PageContentShortName = param_PageContentShortName;
END IF;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPPageContentsInsert`
--

DROP PROCEDURE IF EXISTS `SPPageContentsInsert`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPPageContentsInsert`(
	param_PageContentShortName varchar(128)
	,param_PageContentTitle varchar(128)
	,param_PageContentBody longtext
)
BEGIN
INSERT INTO PageContents
(
PageContentTitle
,PageContentBody
,PageContentShortName
,PageContentEditDate
)
VALUES
(
param_PageContentTitle
,param_PageContentBody
,param_PageContentShortName
,UTC_TIMESTAMP()
);


END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `SPPageContentsUpdate`
--

DROP PROCEDURE IF EXISTS `SPPageContentsUpdate`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPPageContentsUpdate`(
	param_PageContentShortName varchar(128)
	,param_PageContentTitle varchar(128)
	,param_PageContentBody longtext
 )
BEGIN
UPDATE PageContents
SET
	PageContentTitle = param_PageContentTitle
	,PageContentBody = param_PageContentBody
	,PageContentEditDate = UTC_TIMESTAMP()
WHERE
	PageContentShortName = param_PageContentShortName;
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

IF var_TotalViews IS NULL OR var_TotalViews < 1 THEN
	SET var_TotalViews = 1;
END IF;

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
-- Definition of procedure `SPUsersGetByPasswordResetGuid`
--

DROP PROCEDURE IF EXISTS `SPUsersGetByPasswordResetGuid`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPUsersGetByPasswordResetGuid`(
	param_Provider varchar(32)
	,param_PasswordResetGuid varchar(64)
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
	,U.UserProviderId
	,U.PasswordResetGuid
	,U.PasswordResetGuidExpireDate
FROM
	Users U
WHERE
	UserProvider = param_Provider
	AND
	PasswordResetGuid = param_PasswordResetGuid;
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
-- Definition of procedure `SPUsersUpdatePasswordResetGuid`
--

DROP PROCEDURE IF EXISTS `SPUsersUpdatePasswordResetGuid`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SPUsersUpdatePasswordResetGuid`(
	param_UserId int
	,param_PasswordResetGuid varchar(100)
	,param_PasswordResetGuidExpireDate datetime
)
BEGIN
UPDATE Users
SET
	PasswordResetGuid = param_PasswordResetGuid
	,PasswordResetGuidExpireDate = param_PasswordResetGuidExpireDate
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
