-- mysql dump 10.13  distrib 5.5.15, for win32 (x86)
--
-- host: localhost    database: forums_working
-- ------------------------------------------------------
-- server version	5.5.17

/*!40101 set @old_character_set_client=@@character_set_client */;
/*!40101 set @old_character_set_results=@@character_set_results */;
/*!40101 set @old_collation_connection=@@collation_connection */;
/*!40101 set names utf8 */;
/*!40014 set @old_unique_checks=@@unique_checks, unique_checks=0 */;
/*!40014 set @old_foreign_key_checks=@@foreign_key_checks, foreign_key_checks=0 */;
/*!40101 set @old_sql_mode=@@sql_mode, sql_mode='no_auto_value_on_zero' */;
/*!40111 set @old_sql_notes=@@sql_notes, sql_notes=0 */;

--
-- table structure for table `flags`
--

drop table if exists flags;
/*!40101 set @saved_cs_client     = @@character_set_client */;
/*!40101 set character_set_client = utf8 */;
create table flags (
  flagid int(11) not null auto_increment,
  topicid int(11) not null,
  messageid int(11) not null,
  ip varchar(39) not null,
  flagdate datetime not null,
  primary key (flagid,topicid),
  unique key ix_topicid_messageid_ip (topicid,messageid,ip)
) engine=innodb default charset=utf8;
/*!40101 set character_set_client = @saved_cs_client */;

--
-- dumping data for table `flags`
--

/*!40000 alter table flags disable keys */;
/*!40000 alter table flags enable keys */;

--
-- table structure for table `forums`
--

drop table if exists forums;
/*!40101 set @saved_cs_client     = @@character_set_client */;
/*!40101 set character_set_client = utf8 */;
create table forums (
  forumid int(11) not null auto_increment,
  forumname varchar(255) not null,
  forumshortname varchar(32) not null,
  forumdescription longtext not null,
  categoryid int(11) not null,
  userid int(11) not null,
  forumcreationdate datetime not null,
  forumlasteditdate datetime not null,
  forumlastedituser int(11) not null,
  active tinyint(1) not null,
  forumtopiccount int(11) not null,
  forummessagecount int(11) not null,
  forumorder int(11) not null,
  readaccessgroupid smallint(6) default null,
  postaccessgroupid smallint(6) not null,
  primary key (forumid),
  unique key ix_forums_forumshortname (forumshortname),
  key fk_forums_forumscategories (categoryid),
  key fk_forums_users (userid),
  key fk_forums_users_lastedit (forumlastedituser),
  key fk_forums_usersgroups_read (readaccessgroupid),
  key fk_forums_usersgroups_post (postaccessgroupid),
  constraint fk_forums_forumscategories foreign key (categoryid) references forumscategories (categoryid),
  constraint fk_forums_users foreign key (userid) references `users` (userid),
  constraint fk_forums_usersgroups_post foreign key (postaccessgroupid) references usersgroups (usergroupid) on delete no action on update no action,
  constraint fk_forums_usersgroups_read foreign key (readaccessgroupid) references usersgroups (usergroupid) on delete no action on update no action,
  constraint fk_forums_users_lastedit foreign key (forumlastedituser) references `users` (userid)
) engine=innodb default charset=utf8;
/*!40101 set character_set_client = @saved_cs_client */;

--
-- dumping data for table `forums`
--

/*!40000 alter table forums disable keys */;
/*!40000 alter table forums enable keys */;

--
-- table structure for table `forumscategories`
--

drop table if exists forumscategories;
/*!40101 set @saved_cs_client     = @@character_set_client */;
/*!40101 set character_set_client = utf8 */;
create table forumscategories (
  categoryid int(11) not null auto_increment,
  categoryname varchar(255) not null,
  categoryorder int(11) not null,
  primary key (categoryid)
) engine=innodb auto_increment=2 default charset=utf8;
/*!40101 set character_set_client = @saved_cs_client */;

--
-- dumping data for table `forumscategories`
--

/*!40000 alter table forumscategories disable keys */;
insert into forumscategories values (1,'general',10);
/*!40000 alter table forumscategories enable keys */;

--
-- table structure for table `messages`
--

drop table if exists messages;
/*!40101 set @saved_cs_client     = @@character_set_client */;
/*!40101 set character_set_client = utf8 */;
create table messages (
  topicid int(11) not null,
  messageid int(11) not null,
  messagebody longtext not null,
  messagecreationdate datetime not null,
  messagelasteditdate datetime not null,
  messagelastedituser int(11) not null,
  userid int(11) not null,
  parentid int(11) default null,
  active tinyint(1) not null,
  editip varchar(39) default null,
  primary key (topicid,messageid),
  key fk_messages_users (userid),
  constraint fk_messages_topics foreign key (topicid) references topics (topicid),
  constraint fk_messages_users foreign key (userid) references `users` (userid)
) engine=innodb default charset=utf8;
/*!40101 set character_set_client = @saved_cs_client */;

--
-- dumping data for table `messages`
--

/*!40000 alter table messages disable keys */;
/*!40000 alter table messages enable keys */;

--
-- temporary table structure for view `messagescomplete`
--

drop table if exists messagescomplete;
/*!50001 drop view if exists messagescomplete*/;
set @saved_cs_client     = @@character_set_client;
set character_set_client = utf8;
/*!50001 create table `messagescomplete` (
  topicid int(11),
  messageid int(11),
  messagebody longtext,
  messagecreationdate datetime,
  messagelasteditdate datetime,
  parentid int(11),
  userid int(11),
  active tinyint(1),
  username varchar(50),
  usersignature longtext,
  usergroupid smallint(6),
  usergroupname varchar(50),
  userphoto varchar(1024),
  userregistrationdate datetime
) engine=myisam */;
set character_set_client = @saved_cs_client;

--
-- table structure for table `pagecontents`
--

drop table if exists pagecontents;
/*!40101 set @saved_cs_client     = @@character_set_client */;
/*!40101 set character_set_client = utf8 */;
create table pagecontents (
  pagecontentid int(11) not null auto_increment,
  pagecontenttitle varchar(128) not null,
  pagecontentbody longtext not null,
  pagecontentshortname varchar(128) not null,
  pagecontenteditdate datetime not null,
  primary key (pagecontentid)
) engine=innodb auto_increment=3 default charset=utf8;
/*!40101 set character_set_client = @saved_cs_client */;

--
-- dumping data for table `pagecontents`
--

/*!40000 alter table pagecontents disable keys */;
insert into pagecontents values (1,'about','\n	<p>this forum is powered by <a href=\"http://www.nearforums.com\">nearforums</a>, an open source forum engine.</p>\n	<p>nearforums is released under <a href=\"http://nearforums.codeplex.com/license\" target=\"_blank\">mit license</a>, you can get the source at <a href=\"http://www.nearforums.com/source-code\">www.nearforums.com/source-code</a>.</p>','about','2012-02-21 11:21:51'),(2,'terms and conditions','<h2>legal notices</h2>  <p>we, the operators of this website, provide it as a public service to our users.</p>  <p>please carefully review the following basic rules that govern your use of the website. please note that your use of the website constitutes your unconditional agreement to follow and be bound by these terms and conditions of use. if you (the \"user\") do not agree to them, do not use the website, provide any materials to the website or download any materials from them.</p>  <p>the operators reserve the right to update or modify these terms and conditions at any time without prior notice to user. your use of the website following any such change constitutes your unconditional agreement to follow and be bound by these terms and conditions as changed. for this reason, we encourage you to review these terms and conditions of use whenever you use the website.</p>  <p>these terms and conditions of use apply to the use of the website and do not extend to any linked third party sites. these terms and conditions and our <span>privacy policy</span>, which are hereby incorporated by reference, contain the entire agreement (the “agreement”) between you and the operators with respect to the website. any rights not expressly granted herein are reserved.</p>  <h2><span>permitted and prohibited uses</span></h2>  <p>you may use the the website for the sole purpose of sharing and exchanging ideas with other users. you may not use the the website to violate any applicable local, state, national, or international law, including without limitation any applicable laws relating to antitrust or other illegal trade or business practices, federal and state securities laws, regulations promulgated by the u.s. securities and exchange commission, any rules of any national or other securities exchange, and any u.s. laws, rules, and regulations governing the export and re-export of commodities or technical data.</p>  <p>you may not upload or transmit any material that infringes or misappropriates any person\'s copyright, patent, trademark, or trade secret, or disclose via the the website any information the disclosure of which would constitute a violation of any confidentiality obligations you may have.</p>  <p>you may not upload any viruses, worms, trojan horses, or other forms of harmful computer code, nor subject the website\'s network or servers to unreasonable traffic loads, or otherwise engage in conduct deemed disruptive to the ordinary operation of the website.</p>  <p>you are strictly prohibited from communicating on or through the website any unlawful, harmful, offensive, threatening, abusive, libelous, harassing, defamatory, vulgar, obscene, profane, hateful, fraudulent, sexually explicit, racially, ethnically, or otherwise objectionable material of any sort, including, but not limited to, any material that encourages conduct that would constitute a criminal offense, give rise to civil liability, or otherwise violate any applicable local, state, national, or international law.</p>  <p>you are expressly prohibited from compiling and using other users\' personal information, including addresses, telephone numbers, fax numbers, email addresses or other contact information that may appear on the website, for the purpose of creating or compiling marketing and/or mailing lists and from sending other users unsolicited marketing materials, whether by facsimile, email, or other technological means.</p>  <p>you also are expressly prohibited from distributing users\' personal information to third-party parties for marketing purposes. the operators shall deem the compiling of marketing and mailing lists using users\' personal information, the sending of unsolicited marketing materials to users, or the distribution of users\' personal information to third parties for marketing purposes as a material breach of these terms and conditions of use, and the operators reserve the right to terminate or suspend your access to and use of the website and to suspend or revoke your membership in the consortium without refund of any membership dues paid.</p>  <p>the operators note that unauthorized use of users\' personal information in connection with unsolicited marketing correspondence also may constitute violations of various state and federal anti-spam statutes. the operators reserve the right to report the abuse of users\' personal information to the appropriate law enforcement and government authorities, and the operators will fully cooperate with any authorities investigating violations of these laws.</p>  <h2><span>user submissions</span></h2>  <p>the operators do not want to receive confidential or proprietary information from you through the website. any material, information, or other communication you transmit or post (\"contributions\") to the website will be considered non-confidential.</p>  <p>all contributions to this site are licensed by you under the mit license to anyone who wishes to use them, including the operators.</p>  <p>if you work for a company or at a university, it\'s likely that you\'re not the copyright holder of anything you make, even in your free time. before making contributions to this site, get written permission from your employer.</p>  <h2><span>user discussion lists and forums</span></h2>  <p>the operators may, but are not obligated to, monitor or review any areas on the website where users transmit or post communications or communicate solely with each other, including but not limited to user forums and email lists, and the content of any such communications. the operators, however, will have no liability related to the content of any such communications, whether or not arising under the laws of copyright, libel, privacy, obscenity, or otherwise. the operators may edit or remove content on the the website at their discretion at any time.</p>  <h2><span>use of personally identifiable information</span></h2>  <p>information submitted to the website is governed according to the operators’s current <span>privacy policy</span> and the stated license of this website.</p>  <p>you agree to provide true, accurate, current, and complete information when registering with the website. it is your responsibility to maintain and promptly update this account information to keep it true, accurate, current, and complete. if you provides any information that is fraudulent, untrue, inaccurate, incomplete, or not current, or we have reasonable grounds to suspect that such information is fraudulent, untrue, inaccurate, incomplete, or not current, we reserve the right to suspend or terminate your account without notice and to refuse any and all current and future use of the website.</p>  <p>although sections of the website may be viewed simply by visiting the website, in order to access some content and/or additional features offered at the website, you may need to sign on as a guest or register as a member. if you create an account on the website, you may be asked to supply your name, address, a user id and password. you are responsible for maintaining the confidentiality of the password and account and are fully responsible for all activities that occur in connection with your password or account. you agree to immediately notify us of any unauthorized use of either your password or account or any other breach of security. you further agree that you will not permit others, including those whose accounts have been terminated, to access the website using your account or user id. you grant the operators and all other persons or entities involved in the operation of the website the right to transmit, monitor, retrieve, store, and use your information in connection with the operation of the website and in the provision of services to you. the operators cannot and do not assume any responsibility or liability for any information you submit, or your or third parties’ use or misuse of information transmitted or received using website. to learn more about how we protect the privacy of the personal information in your account, please visit our<span>privacy policy</span>.</p>  <h2><span>indemnification</span></h2>  <p>you agree to defend, indemnify and hold harmless the operators, agents, vendors or suppliers from and against any and all claims, damages, costs and expenses, including reasonable attorneys\' fees, arising from or related to your use or misuse of the website, including, without limitation, your violation of these terms and conditions, the infringement by you, or any other subscriber or user of your account, of any intellectual property right or other right of any person or entity.</p>  <h2><span>termination</span></h2>  <p>these terms and conditions of use are effective until terminated by either party. if you no longer agree to be bound by these terms and conditions, you must cease use of the website. if you are dissatisfied with the website, their content, or any of these terms, conditions, and policies, your sole legal remedy is to discontinue using the website. the operators reserve the right to terminate or suspend your access to and use of the website, or parts of the website, without notice, if we believe, in our sole discretion, that such use (i) is in violation of any applicable law; (ii) is harmful to our interests or the interests, including intellectual property or other rights, of another person or entity; or (iii) where the operators have reason to believe that you are in violation of these terms and conditions of use.</p>  <h2><span>warranty disclaimer</span></h2>  <p>the website and associated materials are provided on an \"as is\" and \"as available\" basis. to the full extent permissible by applicable law, the operators disclaim all warranties, express or implied, including, but not limited to, implied warranties of merchantability and fitness for a particular purpose, or non-infringementof intellectual property. the operators make no representations or warranty that the website will meet your requirements, or that your use of the website will be uninterrupted, timely, secure, or error free; nor do the operators make any representation or warranty as to the results that may be obtained from the use of the website. the operators make no representations or warranties of any kind, express or implied, as to the operation of the website or the information, content, materials, or products included on the website.</p>  <p>in no event shall the operators or any of their agents, vendors or suppliers be liable for any damages whatsoever (including, without limitation, damages for loss of profits, business interruption, loss of information) arising out of the use, misuse of or inability to use the website, even if the operators have been advised of the possibility of such damages. this disclaimer constitutes an essential part of this agreement. because some jurisdictions prohibit the exclusion or limitation of liability for consequential or incidental damages, the above limitation may not apply to you.</p>  <p>you understand and agree that any content downloaded or otherwise obtained through the use of the website is at your own discretion and risk and that you will be solely responsible for any damage to your computer system or loss of data or business interruption that results from the download of content. the operators shall not be responsible for any loss or damage caused, or alleged to have been caused, directly or indirectly, by the information or ideas contained, suggested or referenced in or appearing on the website. your participation in the website is solely at your own risk. no advice or information, whether oral or written, obtained by you from the operators or through the operators, their employees, or third parties shall create any warranty not expressly made herein. you acknowledge, by your use of the the website, that your use of the website is at your sole risk.</p>  <p>liability limitation. under no circumstances and under no legal or equitable theory, whether in tort, contract, negligence, strict liability or otherwise, shall the operators or any of their agents, vendors or suppliers be liable to user or to any other person for any indirect, special, incidental or consequential losses or damages of any nature arising out of or in connection with the use of or inability to use the the website or for any breach of security associated with the transmission of sensitive information through the website or for any information obtained through the website, including, without limitation, damages for lost profits, loss of goodwill, loss or corruption of data, work stoppage, accuracy of results, or computer failure or malfunction, even if an authorized representative of the operators has been advised of or should have known of the possibility of such damages.</p>  <p>the operators\'s total cumulative liability for any and all claims in connection with the website will not exceed five u.s. dollars ($5.00). user agrees and acknowledges that the foregoing limitations on liability are an essential basis of the bargain and that the operators would not provide the website absent such limitation.</p>  <h2>links to other materials.</h2>  <p>the website may contain links to sites owned or operated by independent third parties. these links are provided for your convenience and reference only. we do not control such sites and, therefore, we are not responsible for any content posted on these sites. the fact that the operators offer such links should not be construed in any way as an endorsement, authorization, or sponsorship of that site, its content or the companies or products referenced therein, and the operators reserve the right to note its lack of affiliation, sponsorship, or endorsement on the website. if you decide to access any of the third party sites linked to by the website, you do this entirely at your own risk. because some sites employ automated search results or otherwise link you to sites containing information that may be deemed inappropriate or offensive, the operators cannot be held responsible for the accuracy, copyright compliance, legality, or decency of material contained in third party sites, and you hereby irrevocably waive any claim against us with respect to such sites.</p>  <h2><span>notification of possible copyright infringement</span></h2>  <p>in the event you believe that material or content published on the website may infringe on your copyright or that of another, please <span>contact</span> us.</p>','terms','2012-02-21 11:21:51');
/*!40000 alter table pagecontents enable keys */;

--
-- table structure for table `tags`
--

drop table if exists tags;
/*!40101 set @saved_cs_client     = @@character_set_client */;
/*!40101 set character_set_client = utf8 */;
create table tags (
  tag varchar(50) not null,
  topicid int(11) not null,
  primary key (tag,topicid),
  key fk_tags_topics (topicid),
  constraint fk_tags_topics foreign key (topicid) references topics (topicid)
) engine=innodb default charset=utf8;
/*!40101 set character_set_client = @saved_cs_client */;

--
-- dumping data for table `tags`
--

/*!40000 alter table tags disable keys */;
/*!40000 alter table tags enable keys */;

--
-- table structure for table `templates`
--

drop table if exists templates;
/*!40101 set @saved_cs_client     = @@character_set_client */;
/*!40101 set character_set_client = utf8 */;
create table templates (
  templateid int(11) not null auto_increment,
  templatekey varchar(64) not null,
  templatedescription varchar(256) default null,
  templateiscurrent tinyint(1) not null,
  templatedate datetime not null,
  primary key (templateid)
) engine=innodb default charset=utf8;
/*!40101 set character_set_client = @saved_cs_client */;

--
-- dumping data for table `templates`
--

/*!40000 alter table templates disable keys */;
/*!40000 alter table templates enable keys */;

--
-- table structure for table `topics`
--

drop table if exists topics;
/*!40101 set @saved_cs_client     = @@character_set_client */;
/*!40101 set character_set_client = utf8 */;
create table topics (
  topicid int(11) not null auto_increment,
  topictitle varchar(256) not null,
  topicshortname varchar(64) not null,
  topicdescription longtext not null,
  topiccreationdate datetime not null,
  topiclasteditdate datetime not null,
  topicviews int(11) not null,
  topicreplies int(11) not null,
  userid int(11) not null,
  topictags varchar(256) not null,
  forumid int(11) not null,
  topiclastedituser int(11) not null,
  topiclasteditip varchar(39) not null,
  active tinyint(1) not null,
  topicisclose tinyint(1) not null,
  topicorder int(11) default null,
  lastmessageid int(11) default null,
  messagesidentity int(11) not null,
  readaccessgroupid smallint(6) default null,
  postaccessgroupid smallint(6) not null,
  primary key (topicid),
  key fk_topics_forums (forumid),
  key fk_topics_users (userid),
  key fk_topics_users_lastedit (topiclastedituser),
  key ix_topics_forumid_active (active,forumid),
  key fk_topics_usersgroups_read (readaccessgroupid),
  key fk_topics_usersgroups_post (postaccessgroupid),
  constraint fk_topics_forums foreign key (forumid) references forums (forumid),
  constraint fk_topics_users foreign key (userid) references `users` (userid),
  constraint fk_topics_usersgroups_post foreign key (postaccessgroupid) references usersgroups (usergroupid) on delete no action on update no action,
  constraint fk_topics_usersgroups_read foreign key (readaccessgroupid) references usersgroups (usergroupid) on delete no action on update no action,
  constraint fk_topics_users_lastedit foreign key (topiclastedituser) references `users` (userid)
) engine=innodb default charset=utf8;
/*!40101 set character_set_client = @saved_cs_client */;

--
-- dumping data for table `topics`
--

/*!40000 alter table topics disable keys */;
/*!40000 alter table topics enable keys */;

--
-- temporary table structure for view `topicscomplete`
--

drop table if exists topicscomplete;
/*!50001 drop view if exists topicscomplete*/;
set @saved_cs_client     = @@character_set_client;
set character_set_client = utf8;
/*!50001 create table `topicscomplete` (
  topicid int(11),
  topictitle varchar(256),
  topicshortname varchar(64),
  topicdescription longtext,
  topiccreationdate datetime,
  topicviews int(11),
  topicreplies int(11),
  userid int(11),
  topictags varchar(256),
  topicisclose tinyint(1),
  topicorder int(11),
  lastmessageid int(11),
  username varchar(50),
  forumid int(11),
  forumname varchar(255),
  forumshortname varchar(32),
  readaccessgroupid int(6),
  postaccessgroupid int(6)
) engine=myisam */;
set character_set_client = @saved_cs_client;

--
-- table structure for table `topicssubscriptions`
--

drop table if exists topicssubscriptions;
/*!40101 set @saved_cs_client     = @@character_set_client */;
/*!40101 set character_set_client = utf8 */;
create table topicssubscriptions (
  topicid int(11) not null,
  userid int(11) not null,
  primary key (topicid,userid),
  key fk_topicssubscriptions_users (userid),
  constraint fk_topicssubscriptions_topics foreign key (topicid) references topics (topicid),
  constraint fk_topicssubscriptions_users foreign key (userid) references `users` (userid)
) engine=innodb default charset=utf8;
/*!40101 set character_set_client = @saved_cs_client */;

--
-- dumping data for table `topicssubscriptions`
--

/*!40000 alter table topicssubscriptions disable keys */;
/*!40000 alter table topicssubscriptions enable keys */;

--
-- table structure for table `users`
--

drop table if exists users;
/*!40101 set @saved_cs_client     = @@character_set_client */;
/*!40101 set character_set_client = utf8 */;
create table users (
  userid int(11) not null auto_increment,
  username varchar(50) not null,
  userprofile longtext,
  usersignature longtext,
  usergroupid smallint(6) not null,
  active tinyint(1) not null,
  userbirthdate datetime default null,
  userwebsite varchar(255) default null,
  userguid char(32) not null,
  usertimezone decimal(9,2) not null,
  useremail varchar(100) default null,
  useremailpolicy int(11) default null,
  userphoto varchar(1024) default null,
  userregistrationdate datetime not null,
  userexternalprofileurl varchar(255) default null,
  userprovider varchar(32) not null,
  userproviderid varchar(64) not null,
  userproviderlastcall datetime not null,
  passwordresetguid varchar(100) default null,
  passwordresetguidexpiredate datetime default null,
  primary key (userid),
  key fk_users_usersgroups (usergroupid),
  constraint fk_users_usersgroups foreign key (usergroupid) references usersgroups (usergroupid)
) engine=innodb default charset=utf8;
/*!40101 set character_set_client = @saved_cs_client */;

--
-- dumping data for table `users`
--

/*!40000 alter table users disable keys */;
/*!40000 alter table users enable keys */;

--
-- table structure for table `usersgroups`
--

drop table if exists usersgroups;
/*!40101 set @saved_cs_client     = @@character_set_client */;
/*!40101 set character_set_client = utf8 */;
create table usersgroups (
  usergroupid smallint(6) not null,
  usergroupname varchar(50) not null,
  primary key (usergroupid)
) engine=innodb default charset=utf8;
/*!40101 set character_set_client = @saved_cs_client */;

--
-- dumping data for table `usersgroups`
--

/*!40000 alter table usersgroups disable keys */;
insert into usersgroups values (1,'member'),(2,'trusted member'),(3,'moderator'),(10,'admin');
/*!40000 alter table usersgroups enable keys */;

--
-- dumping routines for database 'forums_working'
--
/*!50003 drop function if exists fncasttoint */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 function fncasttoint(number bigint) returns int(11)
begin
  return number;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop function if exists fnsplit */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 function fnsplit(
  x nvarchar(255),
  delim nvarchar(12),
  pos int
) returns varchar(255) charset utf8
return replace(substring(substring_index(x, delim, pos),
       length(substring_index(x, delim, pos -1)) + 1),
       delim, '') */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spcleandb */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spcleandb()
begin

    set foreign_key_checks = 0;

  truncate table tags;
  truncate table messages;
  truncate table topicssubscriptions;
  truncate table topics;
  truncate table templates;
  truncate table forums;
  truncate table users;
  truncate table pagecontents;
  truncate table flags;
  
    set foreign_key_checks = 1;
  
/*
default values
*/
insert into pagecontents (pagecontenttitle, pagecontentshortname, pagecontenteditdate, pagecontentbody)
	values ('about', 'about', utc_timestamp(), '
	<p>this forum is powered by <a href="http://www.nearforums.com">nearforums</a>, an open source forum engine.</p>
	<p>nearforums is released under <a href="http://nearforums.codeplex.com/license" target="_blank">mit license</a>, you can get the source at <a href="http://www.nearforums.com/source-code">www.nearforums.com/source-code</a>.</p>');
insert into pagecontents (pagecontenttitle, pagecontentshortname, pagecontenteditdate, pagecontentbody)
	values ('terms and conditions', 'terms', utc_timestamp(),
	'<h2>legal notices</h2>  <p>we, the operators of this website, provide it as a public service to our users.</p>  <p>please carefully review the following basic rules that govern your use of the website. please note that your use of the website constitutes your unconditional agreement to follow and be bound by these terms and conditions of use. if you (the "user") do not agree to them, do not use the website, provide any materials to the website or download any materials from them.</p>  <p>the operators reserve the right to update or modify these terms and conditions at any time without prior notice to user. your use of the website following any such change constitutes your unconditional agreement to follow and be bound by these terms and conditions as changed. for this reason, we encourage you to review these terms and conditions of use whenever you use the website.</p>  <p>these terms and conditions of use apply to the use of the website and do not extend to any linked third party sites. these terms and conditions and our <span>privacy policy</span>, which are hereby incorporated by reference, contain the entire agreement (the “agreement”) between you and the operators with respect to the website. any rights not expressly granted herein are reserved.</p>  <h2><span>permitted and prohibited uses</span></h2>  <p>you may use the the website for the sole purpose of sharing and exchanging ideas with other users. you may not use the the website to violate any applicable local, state, national, or international law, including without limitation any applicable laws relating to antitrust or other illegal trade or business practices, federal and state securities laws, regulations promulgated by the u.s. securities and exchange commission, any rules of any national or other securities exchange, and any u.s. laws, rules, and regulations governing the export and re-export of commodities or technical data.</p>  <p>you may not upload or transmit any material that infringes or misappropriates any person''s copyright, patent, trademark, or trade secret, or disclose via the the website any information the disclosure of which would constitute a violation of any confidentiality obligations you may have.</p>  <p>you may not upload any viruses, worms, trojan horses, or other forms of harmful computer code, nor subject the website''s network or servers to unreasonable traffic loads, or otherwise engage in conduct deemed disruptive to the ordinary operation of the website.</p>  <p>you are strictly prohibited from communicating on or through the website any unlawful, harmful, offensive, threatening, abusive, libelous, harassing, defamatory, vulgar, obscene, profane, hateful, fraudulent, sexually explicit, racially, ethnically, or otherwise objectionable material of any sort, including, but not limited to, any material that encourages conduct that would constitute a criminal offense, give rise to civil liability, or otherwise violate any applicable local, state, national, or international law.</p>  <p>you are expressly prohibited from compiling and using other users'' personal information, including addresses, telephone numbers, fax numbers, email addresses or other contact information that may appear on the website, for the purpose of creating or compiling marketing and/or mailing lists and from sending other users unsolicited marketing materials, whether by facsimile, email, or other technological means.</p>  <p>you also are expressly prohibited from distributing users'' personal information to third-party parties for marketing purposes. the operators shall deem the compiling of marketing and mailing lists using users'' personal information, the sending of unsolicited marketing materials to users, or the distribution of users'' personal information to third parties for marketing purposes as a material breach of these terms and conditions of use, and the operators reserve the right to terminate or suspend your access to and use of the website and to suspend or revoke your membership in the consortium without refund of any membership dues paid.</p>  <p>the operators note that unauthorized use of users'' personal information in connection with unsolicited marketing correspondence also may constitute violations of various state and federal anti-spam statutes. the operators reserve the right to report the abuse of users'' personal information to the appropriate law enforcement and government authorities, and the operators will fully cooperate with any authorities investigating violations of these laws.</p>  <h2><span>user submissions</span></h2>  <p>the operators do not want to receive confidential or proprietary information from you through the website. any material, information, or other communication you transmit or post ("contributions") to the website will be considered non-confidential.</p>  <p>all contributions to this site are licensed by you under the mit license to anyone who wishes to use them, including the operators.</p>  <p>if you work for a company or at a university, it''s likely that you''re not the copyright holder of anything you make, even in your free time. before making contributions to this site, get written permission from your employer.</p>  <h2><span>user discussion lists and forums</span></h2>  <p>the operators may, but are not obligated to, monitor or review any areas on the website where users transmit or post communications or communicate solely with each other, including but not limited to user forums and email lists, and the content of any such communications. the operators, however, will have no liability related to the content of any such communications, whether or not arising under the laws of copyright, libel, privacy, obscenity, or otherwise. the operators may edit or remove content on the the website at their discretion at any time.</p>  <h2><span>use of personally identifiable information</span></h2>  <p>information submitted to the website is governed according to the operators’s current <span>privacy policy</span> and the stated license of this website.</p>  <p>you agree to provide true, accurate, current, and complete information when registering with the website. it is your responsibility to maintain and promptly update this account information to keep it true, accurate, current, and complete. if you provides any information that is fraudulent, untrue, inaccurate, incomplete, or not current, or we have reasonable grounds to suspect that such information is fraudulent, untrue, inaccurate, incomplete, or not current, we reserve the right to suspend or terminate your account without notice and to refuse any and all current and future use of the website.</p>  <p>although sections of the website may be viewed simply by visiting the website, in order to access some content and/or additional features offered at the website, you may need to sign on as a guest or register as a member. if you create an account on the website, you may be asked to supply your name, address, a user id and password. you are responsible for maintaining the confidentiality of the password and account and are fully responsible for all activities that occur in connection with your password or account. you agree to immediately notify us of any unauthorized use of either your password or account or any other breach of security. you further agree that you will not permit others, including those whose accounts have been terminated, to access the website using your account or user id. you grant the operators and all other persons or entities involved in the operation of the website the right to transmit, monitor, retrieve, store, and use your information in connection with the operation of the website and in the provision of services to you. the operators cannot and do not assume any responsibility or liability for any information you submit, or your or third parties’ use or misuse of information transmitted or received using website. to learn more about how we protect the privacy of the personal information in your account, please visit our<span>privacy policy</span>.</p>  <h2><span>indemnification</span></h2>  <p>you agree to defend, indemnify and hold harmless the operators, agents, vendors or suppliers from and against any and all claims, damages, costs and expenses, including reasonable attorneys'' fees, arising from or related to your use or misuse of the website, including, without limitation, your violation of these terms and conditions, the infringement by you, or any other subscriber or user of your account, of any intellectual property right or other right of any person or entity.</p>  <h2><span>termination</span></h2>  <p>these terms and conditions of use are effective until terminated by either party. if you no longer agree to be bound by these terms and conditions, you must cease use of the website. if you are dissatisfied with the website, their content, or any of these terms, conditions, and policies, your sole legal remedy is to discontinue using the website. the operators reserve the right to terminate or suspend your access to and use of the website, or parts of the website, without notice, if we believe, in our sole discretion, that such use (i) is in violation of any applicable law; (ii) is harmful to our interests or the interests, including intellectual property or other rights, of another person or entity; or (iii) where the operators have reason to believe that you are in violation of these terms and conditions of use.</p>  <h2><span>warranty disclaimer</span></h2>  <p>the website and associated materials are provided on an "as is" and "as available" basis. to the full extent permissible by applicable law, the operators disclaim all warranties, express or implied, including, but not limited to, implied warranties of merchantability and fitness for a particular purpose, or non-infringementof intellectual property. the operators make no representations or warranty that the website will meet your requirements, or that your use of the website will be uninterrupted, timely, secure, or error free; nor do the operators make any representation or warranty as to the results that may be obtained from the use of the website. the operators make no representations or warranties of any kind, express or implied, as to the operation of the website or the information, content, materials, or products included on the website.</p>  <p>in no event shall the operators or any of their agents, vendors or suppliers be liable for any damages whatsoever (including, without limitation, damages for loss of profits, business interruption, loss of information) arising out of the use, misuse of or inability to use the website, even if the operators have been advised of the possibility of such damages. this disclaimer constitutes an essential part of this agreement. because some jurisdictions prohibit the exclusion or limitation of liability for consequential or incidental damages, the above limitation may not apply to you.</p>  <p>you understand and agree that any content downloaded or otherwise obtained through the use of the website is at your own discretion and risk and that you will be solely responsible for any damage to your computer system or loss of data or business interruption that results from the download of content. the operators shall not be responsible for any loss or damage caused, or alleged to have been caused, directly or indirectly, by the information or ideas contained, suggested or referenced in or appearing on the website. your participation in the website is solely at your own risk. no advice or information, whether oral or written, obtained by you from the operators or through the operators, their employees, or third parties shall create any warranty not expressly made herein. you acknowledge, by your use of the the website, that your use of the website is at your sole risk.</p>  <p>liability limitation. under no circumstances and under no legal or equitable theory, whether in tort, contract, negligence, strict liability or otherwise, shall the operators or any of their agents, vendors or suppliers be liable to user or to any other person for any indirect, special, incidental or consequential losses or damages of any nature arising out of or in connection with the use of or inability to use the the website or for any breach of security associated with the transmission of sensitive information through the website or for any information obtained through the website, including, without limitation, damages for lost profits, loss of goodwill, loss or corruption of data, work stoppage, accuracy of results, or computer failure or malfunction, even if an authorized representative of the operators has been advised of or should have known of the possibility of such damages.</p>  <p>the operators''s total cumulative liability for any and all claims in connection with the website will not exceed five u.s. dollars ($5.00). user agrees and acknowledges that the foregoing limitations on liability are an essential basis of the bargain and that the operators would not provide the website absent such limitation.</p>  <h2>links to other materials.</h2>  <p>the website may contain links to sites owned or operated by independent third parties. these links are provided for your convenience and reference only. we do not control such sites and, therefore, we are not responsible for any content posted on these sites. the fact that the operators offer such links should not be construed in any way as an endorsement, authorization, or sponsorship of that site, its content or the companies or products referenced therein, and the operators reserve the right to note its lack of affiliation, sponsorship, or endorsement on the website. if you decide to access any of the third party sites linked to by the website, you do this entirely at your own risk. because some sites employ automated search results or otherwise link you to sites containing information that may be deemed inappropriate or offensive, the operators cannot be held responsible for the accuracy, copyright compliance, legality, or decency of material contained in third party sites, and you hereby irrevocably waive any claim against us with respect to such sites.</p>  <h2><span>notification of possible copyright infringement</span></h2>  <p>in the event you believe that material or content published on the website may infringe on your copyright or that of another, please <span>contact</span> us.</p>');


end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spforumscategoriesgetall */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spforumscategoriesgetall()
begin
select
	categoryid
	,categoryname
	,categoryorder
from
	forumscategories
order by
	categoryorder;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spforumsdelete */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spforumsdelete(
  param_forumshortname nvarchar(32)
)
begin
update forums
set
	active = 0
where
	forumshortname = param_forumshortname;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spforumsgetbycategory */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spforumsgetbycategory(
    param_usergroupid smallint
)
begin

select
	f.forumid
	,f.forumname
	,f.forumshortname
	,f.forumdescription
	,f.userid
	,f.forumcreationdate
	,f.forumtopiccount
	,f.forummessagecount
	,c.categoryid
	,c.categoryname
from
	forumscategories c
	inner join forums f on f.categoryid = c.categoryid
where
    f.active = 1
    and
    ifnull(f.readaccessgroupid,-1) <= ifnull(param_usergroupid,-1)
order by
	c.categoryorder,
	f.forumorder;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spforumsgetbyshortname */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spforumsgetbyshortname(param_shortname nvarchar(32))
begin
select
	f.forumid
	,f.forumname
	,f.forumshortname
	,f.forumdescription
	,f.userid
	,f.forumcreationdate
	,f.forumtopiccount
	,f.forummessagecount
	,c.categoryid
	,c.categoryname
	,f.readaccessgroupid
	,f.postaccessgroupid
from
	forums f
	inner join forumscategories c on f.categoryid = c.categoryid
where
	f.forumshortname = param_shortname
	and
	f.active = 1;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spforumsgetusedshortnames */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spforumsgetusedshortnames(
  param_forumshortname nvarchar(32), param_searchshortname nvarchar(32)
)
begin
/*
	gets used short names for forums
	returns:
		if not used shortname: empty result set
		if used shortname: resultset with amount of rows used
*/

declare currentvalue nvarchar(32);
select
	forumshortname into currentvalue
from
	forums
where
	forumshortname = param_forumshortname;


if currentvalue is null then
	select null as forumshortname from forums where 1=0;
else
	select
		forumshortname
	from
		forums
	where
		forumshortname like concat(param_searchshortname, '%')
    or
		forumshortname = param_forumshortname;

end if;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spforumsinsert */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spforumsinsert(
	param_forumname nvarchar(255)
	,param_forumshortname nvarchar(32)
	,param_forumdescription longtext
	,param_categoryid int
	,param_userid int
	,param_readaccessgroupid smallint
	,param_postaccessgroupid smallint
)
begin

insert into forums
(
	forumname
	,forumshortname
	,forumdescription
	,categoryid
	,userid
	,forumcreationdate
	,forumlasteditdate
	,forumlastedituser
	,active
	,forumtopiccount
	,forummessagecount
	,forumorder
	,readaccessgroupid
	,postaccessgroupid
)
values
(
	param_forumname
	,param_forumshortname
	,param_forumdescription
	,param_categoryid
	,param_userid
	,utc_timestamp()
	,utc_timestamp()
	,param_userid
	,1
	,0
	,0
	,0
	,param_readaccessgroupid
	,param_postaccessgroupid
);

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spforumsupdate */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spforumsupdate(
	param_forumshortname nvarchar(32)
	,param_forumname nvarchar(255)
	,param_forumdescription longtext
	,param_categoryid int
	,param_userid int
	,param_readaccessgroupid smallint
	,param_postaccessgroupid smallint
)
begin


update forums
set
	forumname = param_forumname
	,forumdescription = param_forumdescription
	,categoryid = param_categoryid
	,forumlasteditdate = utc_timestamp()
	,forumlastedituser = param_userid
	,readaccessgroupid = param_readaccessgroupid
	,postaccessgroupid = param_postaccessgroupid
where
	forumshortname = param_forumshortname;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spforumsupdatelastmessage */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spforumsupdatelastmessage(
	param_topicid int
	,param_messageid int
)
begin

update forums f, topics t
set
	f.forummessagecount = f.forummessagecount + 1
where
  f.forumid = t.forumid
  and
	t.topicid = param_topicid;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spforumsupdatelasttopic */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spforumsupdatelasttopic(param_forumid int)
begin


update forums f
set
	f.forumtopiccount = f.forumtopiccount + 1
where
	f.forumid = param_forumid;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spforumsupdaterecount */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spforumsupdaterecount(param_forumid int)
begin

/*
	recounts the children messages and topics
*/
declare var_forumtopiccount int;
declare var_forummessagecount int;

select
  count(topicid)
	,sum(topicreplies)
into
  var_forumtopiccount
  ,var_forummessagecount
from
	topics
where
	forumid = param_forumid
  and
	active = 1;

update forums
set
	forumtopiccount = ifnull(var_forumtopiccount, 0)
	,forummessagecount = ifnull(var_forummessagecount, 0)
where
	forumid = param_forumid;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spmessagesdelete */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spmessagesdelete(
	param_topicid int
	,param_messageid int
	,param_userid int
)
begin

update messages
set
	active = 0
	,messagelasteditdate = utc_timestamp()
	,messagelastedituser = param_userid
where
	topicid = param_topicid
	and
	messageid = param_messageid;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spmessagesflag */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spmessagesflag(
	param_topicid int
	,param_messageid int
	,param_ip varchar(39)
)
begin
	insert ignore into flags
	(topicid, messageid, ip, flagdate)
	values
	(param_topicid, param_messageid, param_ip, utc_timestamp());
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spmessagesflagsclear */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spmessagesflagsclear(
	param_topicid int
	,param_messageid int
)
begin
delete from
	flags
where
	topicid = param_topicid
	and
	messageid = param_messageid;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spmessagesflagsgetall */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spmessagesflagsgetall()
begin
/*
	lists all flagged messages (not topics)
*/
select
	f.topicid
	,f.messageid
	,fncasttoint(count(flagid)) as totalflags
	,t.topictitle
	,t.topicshortname
	,forums.forumid
	,forums.forumshortname
	,forums.forumname
	,m.messagebody
	,m.username
	,m.userid
from
	flags f
	inner join topics t on t.topicid = f.topicid
	inner join forums on forums.forumid = t.forumid
	inner join messagescomplete m on m.topicid = t.topicid and m.messageid = f.messageid
where
	t.active = 1
	and	
	m.active = 1
group by
	f.topicid
	,f.messageid
	,t.topictitle
	,t.topicshortname
	,forums.forumid
	,forums.forumshortname
	,forums.forumname
	,m.messagebody
	,m.username
	,m.userid
order by count(flagid) desc, f.topicid;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spmessagesgetbytopic */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spmessagesgetbytopic(param_topicid int)
begin

select
  m.messageid as rownumber
	,m.topicid
	,m.messageid
	,m.messagebody
	,m.messagecreationdate
	,m.messagelasteditdate
	,m.parentid
	,userid
	,username
	,usersignature
	,usergroupid
	,usergroupname
	,userphoto
	,userregistrationdate
	,m.active
from
	messagescomplete m
where
	m.topicid = param_topicid
order by m.topicid, m.messageid;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spmessagesgetbytopicfrom */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spmessagesgetbytopicfrom(
	param_topicid int
	,param_firstmsg int
	,param_amount int
)
begin

prepare stmt from "
select
		m.messageid as rownumber
		,m.topicid
		,m.messageid
		,m.messagebody
		,m.messagecreationdate
		,m.messagelasteditdate
		,m.parentid
		,userid
		,username
		,usersignature
		,usergroupid
		,usergroupname
		,userphoto
		,userregistrationdate
		,m.active
	from
		messagescomplete m
	where
		m.topicid = ?
		and
		m.messageid > ?
  order by m.topicid, m.messageid
  limit ?";

set @param_topicid = param_topicid;
set @param_firstmsg = param_firstmsg;
set @param_amount = param_amount;

execute stmt using @param_topicid, @param_firstmsg, @param_amount;

deallocate prepare stmt;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spmessagesgetbytopiclatest */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spmessagesgetbytopiclatest(param_topicid int)
begin

select
	m.topicid
	,m.messageid
	,m.messagebody
	,m.messagecreationdate
	,m.messagelasteditdate
	,m.parentid
	,userid
	,username
	,usersignature
	,usergroupid
	,usergroupname
	,m.active
from
	messagescomplete m
where
	m.topicid = param_topicid
order by
	topicid, messageid desc
limit 20;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spmessagesgetbytopicupto */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spmessagesgetbytopicupto(
  param_topicid int,
	param_firstmsg int,
	param_lastmsg int
)
begin

select
	m.messageid as rownumber
	,m.topicid
	,m.messageid
	,m.messagebody
	,m.messagecreationdate
	,m.messagelasteditdate
	,m.parentid
	,userid
	,username
	,usersignature
	,usergroupid
	,usergroupname
	,userphoto
	,userregistrationdate
	,m.active
from
	messagescomplete m
where
	m.topicid = param_topicid
	and
	m.messageid > param_firstmsg
	and
	m.messageid <= param_lastmsg
order by m.topicid, m.messageid;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spmessagesinsert */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spmessagesinsert(
	param_topicid int
	,param_messagebody longtext
	,param_userid int
	,out param_messageid int
	,param_ip varchar(39)
	,param_parentid int
)
begin
declare exit handler for sqlexception
begin
  rollback;
end;
start transaction;

  select t.messagesidentity+1 into param_messageid from topics t where t.topicid = param_topicid;

  update topics t
  set
	  t.messagesidentity = param_messageid
  where
	  topicid = param_topicid;

	insert into messages
	(
	topicid
	,messageid
	,messagebody
	,messagecreationdate
	,messagelasteditdate
	,messagelastedituser
	,userid
	,active
	,editip
	,parentid
	)
	values
	(
	param_topicid
	,param_messageid
	,param_messagebody
	,utc_timestamp()
	,utc_timestamp()
	,param_userid
	,param_userid
	,1 -- active
	,param_ip
	,param_parentid
	);


	set @topicid=param_topicid;
  set @messageid=param_messageid;
	-- update topic
	call sptopicsupdatelastmessage (@topicid, @messageid);
	-- update forums
	call spforumsupdatelastmessage (@topicid, @messageid);
commit;


end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sppagecontentsdelete */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sppagecontentsdelete(
  param_pagecontentshortname nvarchar(128)
)
begin
delete from pagecontents
where
	pagecontentshortname = param_pagecontentshortname;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sppagecontentsget */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sppagecontentsget(
  param_pagecontentshortname nvarchar(128)
)
begin
select
	pagecontentid
	,pagecontenttitle
	,pagecontentbody
	,pagecontentshortname
from
	pagecontents
where
	pagecontentshortname = param_pagecontentshortname;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sppagecontentsgetall */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sppagecontentsgetall()
begin
select
	pagecontentid
	,pagecontenttitle
	,pagecontentbody
	,pagecontentshortname
from
	pagecontents
order by
	pagecontenttitle;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sppagecontentsgetusedshortnames */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sppagecontentsgetusedshortnames(
	param_pagecontentshortname nvarchar(32),
	param_searchshortname nvarchar(32)
)
begin
/*
	gets used short names for pagecontents
	returns:
		if not used shortname: empty result set
		if used shortname: resultset with amount of rows used
*/
declare var_currentvalue nvarchar(32);
select
	pagecontentshortname into var_currentvalue
from
	pagecontents
where
	pagecontentshortname = param_pagecontentshortname;


if var_currentvalue is null then
	select null as forumshortname from pagecontents where 1=0;
else
	select
		pagecontentshortname
	from
		pagecontents
	where
		pagecontentshortname like concat(param_searchshortname, '%')
		or
		pagecontentshortname = param_pagecontentshortname;
end if;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sppagecontentsinsert */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sppagecontentsinsert(
	param_pagecontentshortname nvarchar(128)
	,param_pagecontenttitle nvarchar(128)
	,param_pagecontentbody longtext
)
begin
insert into pagecontents
(
pagecontenttitle
,pagecontentbody
,pagecontentshortname
,pagecontenteditdate
)
values
(
param_pagecontenttitle
,param_pagecontentbody
,param_pagecontentshortname
,utc_timestamp()
);


end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sppagecontentsupdate */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sppagecontentsupdate(
	param_pagecontentshortname nvarchar(128)
	,param_pagecontenttitle nvarchar(128)
	,param_pagecontentbody longtext
 )
begin
update pagecontents
set
	pagecontenttitle = param_pagecontenttitle
	,pagecontentbody = param_pagecontentbody
	,pagecontenteditdate = utc_timestamp()
where
	pagecontentshortname = param_pagecontentshortname;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptagsgetmostviewed */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptagsgetmostviewed(
  param_forumid int
	,param_top bigint
)
begin


declare var_totalviews bigint;

select
		sum(t.topicviews) into var_totalviews
	from
		topics t
	where
		t.forumid = param_forumid;

if var_totalviews is null or var_totalviews < 1 then
	set var_totalviews = 1;
end if;

prepare stmt from "
select
	tag,
	tagviews,
	(tagviews*100.00)/? as weight
from
	(
  select
		tags.tag
		,sum(t.topicviews) as tagviews
		,count(t.topicid) as topiccount
	from
		tags
		inner join topics t on tags.topicid = t.topicid
	where
		t.forumid = ?
		and
		t.active = 1
	group by
		tags.tag
	order by sum(t.topicviews) desc
  limit ?
	) t
order by tag";

set @var_totalviews = var_totalviews;
set @param_forumid = param_forumid;
set @param_top = param_top;
execute stmt using @var_totalviews, @param_forumid, @param_top;

deallocate prepare stmt;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptagsinsert */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptagsinsert(
	param_tags nvarchar(256)
	,param_topicid int
	,param_previoustags nvarchar(256)
)
begin

declare var_parts int;
declare var_currentpart int;
/*define amount of tag parts*/
select length(param_tags) - length(replace(param_tags, ' ', '')) + 1 into var_parts;
set var_currentpart = 1;


if not param_previoustags is null then
	delete from tags
	where
		topicid = param_topicid;
end if;

while (var_currentpart <= var_parts) do
  if fnsplit(param_tags, ' ', var_currentpart) <> '' then
    insert into tags
    (tag,topicid)
    select fnsplit(param_tags, ' ', var_currentpart), param_topicid;
  end if;

  set var_currentpart = var_currentpart + 1;
end while;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptemplatesdelete */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptemplatesdelete(param_templateid int)
begin

delete from templates where templateid = param_templateid;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptemplatesget */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptemplatesget(param_templateid int)
begin


select
	templateid
	,templatekey
	,templatedescription
	,templateiscurrent
from
	templates
where
	templateid = param_templateid;


end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptemplatesgetall */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptemplatesgetall()
begin

select
	templateid
	,templatekey
	,templatedescription
	,templateiscurrent
from
	templates;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptemplatesgetcurrent */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptemplatesgetcurrent()
begin
select
	templateid
	,templatekey
	,templatedescription
from
	templates
where
	templateiscurrent = 1;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptemplatesinsert */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptemplatesinsert(
	param_templatekey nvarchar(64)
	,param_templatedescription nvarchar(256)
	,out param_templateid int
)
begin
-- ----------------------
-- if exist updates, if not insert
-- ---------------------
if not exists (select templatekey from templates where templatekey = param_templatekey) then
    insert into templates
    (
        templatekey
        ,templatedescription
        ,templatedate
        ,templateiscurrent
    )
    values
    (
        param_templatekey
        ,param_templatedescription
        ,utc_timestamp()
        ,0
    );

    select last_insert_id() into param_templateid;
else
    update templates
    set
        templatedescription = param_templatedescription
        ,templatedate = utc_timestamp()
    where 
        templatekey=param_templatekey;
end if;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptemplatesupdatecurrent */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptemplatesupdatecurrent(param_templateid int)
begin


update templates
set
	templateiscurrent = (case when templateid = param_templateid then 1 else 0 end);

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptopicsaddvisit */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptopicsaddvisit(param_topicid int)
begin

update topics
set
	topicviews = topicviews+1
where
	topicid = param_topicid;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptopicsclose */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptopicsclose(
	param_topicid int
	,param_userid int
	,param_ip varchar(39)
)
begin

update topics
	set
		topicisclose = 1
		,topiclasteditdate = utc_timestamp()
		,topiclastedituser = param_userid
		,topiclasteditip = param_ip
	where
		topicid = param_topicid;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptopicsdelete */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptopicsdelete(
	param_topicid int
	,param_userid int
	,param_ip varchar(39)
)
begin
/*
- sets the topic active=0
- updates recount on forum
*/

declare var_forumid int;
select forumid into var_forumid from topics where topicid = param_topicid;


	update topics
	set
		active = 0
		,topiclasteditdate = utc_timestamp()
		,topiclastedituser = param_userid
		,topiclasteditip = param_ip
	where
		topicid = param_topicid;

  call spforumsupdaterecount (var_forumid);
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptopicsget */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptopicsget(param_topicid int)
begin

select
	t.topicid
	,t.topictitle
	,t.topicshortname
	,t.topicdescription
	,t.topiccreationdate
	,t.topicviews
	,t.topicreplies
	,t.userid
	,t.topictags
	,t.topicisclose
	,t.topicorder
	,t.lastmessageid
	,t.username
	,t.forumid
	,t.forumname
	,t.forumshortname
	,t.readaccessgroupid
	,t.postaccessgroupid
from
	topicscomplete t
where
	t.topicid = param_topicid;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptopicsgetbyforum */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptopicsgetbyforum(
	param_forumid int
	,param_startindex int
	,param_length int
	,param_usergroupid int
)
begin

prepare stmt from "
select
		0	as rownumber
		,t.topicid
		,t.topictitle
		,t.topicshortname
		,t.topicdescription
		,t.topiccreationdate
		,t.topicviews
		,t.topicreplies
		,t.userid
		,t.topictags
		,t.topicisclose
		,t.topicorder
		,t.lastmessageid
		,t.username
		,m.messagecreationdate
		,m.userid as messageuserid
		,mu.username as messageusername
		,t.readaccessgroupid
		,t.postaccessgroupid
	from
		topicscomplete t
		left join messages m on m.topicid = t.topicid and m.messageid = t.lastmessageid and m.active = 1
		left join users mu on mu.userid = m.userid
	where
		t.forumid = ?
		and
		ifnull(t.readaccessgroupid,-1) <= ifnull(?,-1)
  order by topicorder desc, topicviews desc
  limit ?, ?";

set @param_forumid = param_forumid;
set @param_startindex = param_startindex;
set @param_length = param_length;
set @param_usergroupid = param_usergroupid;

execute stmt using @param_forumid, @param_usergroupid, @param_startindex, @param_length;

deallocate prepare stmt;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptopicsgetbyforumlatest */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptopicsgetbyforumlatest(
	param_forumid int
	,param_startindex int
	,param_length int
	,param_usergroupid int
)
begin
prepare stmt from "
select
		0	as rownumber
		,t.topicid
		,t.topictitle
		,t.topicshortname
		,t.topicdescription
		,t.topiccreationdate
		,t.topicviews
		,t.topicreplies
		,t.userid
		,t.topictags
		,t.topicisclose
		,t.topicorder
		,t.lastmessageid
		,t.username
		,m.messagecreationdate
		,m.userid as messageuserid
		,mu.username as messageusername
		,t.readaccessgroupid
		,t.postaccessgroupid
	from
		topicscomplete t
		left join messages m on m.topicid = t.topicid and m.messageid = t.lastmessageid and m.active = 1
		left join users mu on mu.userid = m.userid
	where
		t.forumid = ?
		and
		ifnull(t.readaccessgroupid,-1) <= ifnull(?,-1)
  order by 
    topicorder desc,
    (case 
        when m.messagecreationdate > t.topiccreationdate then m.messagecreationdate
        else t.topiccreationdate
    end) desc
  limit ?, ?";

set @param_forumid = param_forumid;
set @param_startindex = param_startindex;
set @param_length = param_length;
set @param_usergroupid = param_usergroupid;

execute stmt using @param_forumid, @param_usergroupid, @param_startindex, @param_length;

deallocate prepare stmt;


end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptopicsgetbyforumunanswered */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptopicsgetbyforumunanswered(
   param_forumid int
	,param_usergroupid int
)
begin

select
	t.topicid
	,t.topictitle
	,t.topicshortname
	,t.topicdescription
	,t.topiccreationdate
	,t.topicviews
	,t.topicreplies
	,t.userid
	,t.topictags
	,t.topicisclose
	,t.topicorder
	,t.lastmessageid
	,t.username
	,m.messagecreationdate
	,m.userid as messageuserid
	,mu.username as messageusername
	,t.readaccessgroupid
	,t.postaccessgroupid
from
	topicscomplete t
	left join messages m on m.topicid = t.topicid and m.messageid = t.lastmessageid and m.active = 1
	left join users mu on mu.userid = m.userid
where
	t.forumid = param_forumid
	and
	t.topicreplies = 0 -- unanswered
	and
	t.topicorder is null -- not sticky
	and
	ifnull(t.readaccessgroupid,-1) <= ifnull(param_usergroupid,-1)
order by
	topicviews desc, topicid desc;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptopicsgetbyrelated */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptopicsgetbyrelated(
  param_tag1 nvarchar(50)
	,param_tag2 nvarchar(50)
	,param_tag3 nvarchar(50)
	,param_tag4 nvarchar(50)
	,param_tag5 nvarchar(50)
	,param_tag6 nvarchar(50)
	,param_topicid int
	,param_amount int
	,param_usergroupid int
)
begin

create temporary table temp_tagsparams (tag nvarchar(50) null);

insert into
  temp_tagsparams (tag)
select
  param_tag1
union
select param_tag2
union
select param_tag3
union
select param_tag4
union
select param_tag5
union
select param_tag6;

select
	ta.tagcount
	,topics.topicid
	,topics.topictitle
	,topics.topicshortname
	,topics.topicdescription
	,topics.topiccreationdate
	,topics.topicviews
	,topics.topicreplies
	,topics.forumid
	,topics.forumname
	,topics.forumshortname
	,topics.topicisclose
	,topics.topicorder
	,topics.readaccessgroupid
	,topics.postaccessgroupid
from
	(
	select
		t.topicid
		,count(t.tag) as tagcount
	from
		tags t
		inner join temp_tagsparams p on t.tag<=>p.tag
	group by
		t.topicid
	)
	ta
	inner join topicscomplete topics on topics.topicid = ta.topicid
where
	topics.topicid <> param_topicid
	and
	ifnull(topics.readaccessgroupid,-1) <= ifnull(param_usergroupid,-1)
order by
	ta.tagcount desc, topics.topicviews desc;

drop table temp_tagsparams;


end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptopicsgetbytag */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptopicsgetbytag(
  param_tag nvarchar(50)
	,param_forumid int
	,param_usergroupid int
)
begin
-- remove the last char
set param_tag = substring(param_tag, 1, char_length(param_tag)-1);
select
		t.topicid
		,t.topictitle
		,t.topicshortname
		,t.topicdescription
		,t.topiccreationdate
		,t.topicviews
		,t.topicreplies
		,t.userid
		,t.topictags
		,t.topicisclose
		,t.topicorder
		,t.lastmessageid
		,t.username
		,m.messagecreationdate
		,m.userid as messageuserid
		,mu.username as messageusername
		,t.readaccessgroupid
		,t.postaccessgroupid
from
	tags
	inner join topicscomplete t on t.topicid = tags.topicid
	left join messages m on m.topicid = t.topicid and m.messageid = t.lastmessageid and m.active = 1
	left join users mu on mu.userid = m.userid
where
	tags.tag like concat(param_tag, '%')
	and
	t.forumid = param_forumid
	and
	ifnull(t.readaccessgroupid,-1) <= ifnull(param_usergroupid,-1)
order by topicorder desc,topicviews desc;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptopicsgetbyuser */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptopicsgetbyuser(
	param_userid int
	,param_usergroupid int
)
begin

select
	t.topicid
	,t.topictitle
	,t.topicshortname
	,t.topicdescription
	,t.topiccreationdate
	,t.topicviews
	,t.topicreplies
	,t.userid
	,t.topictags
	,t.topicisclose
	,t.topicorder
	,t.lastmessageid
	,t.username
	,m.messagecreationdate
	,t.readaccessgroupid
	,t.postaccessgroupid
from
	topicscomplete t
	left join messages m on m.topicid = t.topicid and m.messageid = t.lastmessageid and m.active = 1
where
	t.userid = param_userid
	and
	ifnull(t.readaccessgroupid,-1) <= ifnull(param_usergroupid,-1)
order by t.topicid desc;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptopicsgetlatest */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptopicsgetlatest(
    param_usergroupid int
)
begin

/*
	gets the latest messages in all forums	
*/
	select   
		t.topicid
		,t.topictitle
		,t.topicshortname
		,t.topicdescription
		,t.topiccreationdate
		,t.topicviews
		,t.topicreplies
		,t.userid
		,t.topictags
		,t.topicisclose
		,t.topicorder
		,t.lastmessageid
		,t.username
		,m.messagecreationdate
	from
		topicscomplete t
		left join messages m on m.topicid = t.topicid and m.messageid = t.lastmessageid and m.active = 1
	where
		ifnull(t.readaccessgroupid,-1) <= ifnull(param_usergroupid,-1)
	order by t.topicid desc
  limit 20;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptopicsgetmessagesbyuser */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptopicsgetmessagesbyuser(
	param_userid int
)
begin
/*
gets the messages posted by the user grouped by topic
*/
select
	t.topicid
	,m.messageid
	,m.messagecreationdate
	,t.topictitle
	,t.topicshortname
	,t.topicdescription
	,t.topiccreationdate
	,t.topicviews
	,t.topicreplies
	,t.userid
	,t.topictags
	,t.topicisclose
	,t.topicorder
from
	topicscomplete t
	inner join messages m on m.topicid = t.topicid
where
	m.userid = param_userid
order by t.topicid desc, m.messageid desc;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptopicsgetunanswered */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptopicsgetunanswered()
begin
select
	t.topicid
	,t.topictitle
	,t.topicshortname
	,t.topicdescription
	,t.topiccreationdate
	,t.topicviews
	,t.topicreplies
	,t.userid
	,t.topictags
	,t.topicisclose
	,t.topicorder
	,t.lastmessageid
	,t.username
	,m.messagecreationdate
	,t.forumid
	,t.forumname
	,t.forumshortname
from
	topicscomplete t
	left join messages m on m.topicid = t.topicid and m.messageid = t.lastmessageid and m.active = 1
where
	t.topicreplies = 0 -- unanswered
	and
	t.topicorder is null -- not sticky
order by
	topicid desc;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptopicsinsert */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptopicsinsert(
	param_topictitle nvarchar(255)
	,param_topicshortname nvarchar(64)
	,param_topicdescription longtext
	,param_userid int
	,param_topictags nvarchar(256)
	,param_topicorder int
	,param_forum nvarchar(32)
	,param_ip varchar(39)
	,param_readaccessgroupid smallint
	,param_postaccessgroupid smallint
	,out param_topicid int
)
begin

declare var_forumid int;

declare exit handler for sqlexception
begin
  rollback;
end;

select forumid into var_forumid from forums where forumshortname = param_forum;
set param_topictags = lower(param_topictags);

if param_topicorder is not null then
	select param_topicorder = max(topicorder)+1 from topics;
	select param_topicorder = ifnull(param_topicorder, 1);
end if;

start transaction;

	insert into topics
	(
	topictitle
	,topicshortname
	,topicdescription
	,topiccreationdate
	,topiclasteditdate
	,topicviews
	,topicreplies
	,userid
	,topictags
	,forumid
	,topiclastedituser
	,topiclasteditip
	,active
	,topicisclose
	,topicorder
	,messagesidentity
	,readaccessgroupid
	,postaccessgroupid
	)
	values
	(
	param_topictitle
	,param_topicshortname
	,param_topicdescription
	,utc_timestamp()
	,utc_timestamp()
	,0 -- topicviews
	,0 -- topicreplies
	,param_userid
	,param_topictags
	,var_forumid
	,param_userid
	,param_ip
	,1 -- active
	,0 -- topicisclose
	,param_topicorder
	,0 -- messageidentity
	,param_readaccessgroupid
	,param_postaccessgroupid
	);

	set param_topicid = last_insert_id();

	-- add tags
  set @tags=param_topictags;
  set @topicid=param_topicid;
  set @forumid=var_forumid;
	call sptagsinsert (@tags, @topicid, null);

	-- update forums
	call spforumsupdaterecount (@forumid);
commit;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptopicsmove */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptopicsmove(
	param_topicid int
	,param_forumid int
	,param_userid int
	,param_ip varchar(39)
)
begin

declare var_previousforumid int;

declare exit handler for sqlexception
begin
  rollback;
  -- resignal;
end;
start transaction;
  select forumid into var_previousforumid from topics where topicid = param_topicid;
	update topics
	set
		forumid = param_forumid
		,topiclasteditdate = utc_timestamp()
		,topiclastedituser = param_userid
		,topiclasteditip = param_ip
	where
		topicid = param_topicid;

  set @forumid = param_forumid;
  set @previousforumid = var_previousforumid;
	call spforumsupdaterecount (@forumid);
	call spforumsupdaterecount (@previousforumid);

commit;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptopicsopen */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptopicsopen(
	param_topicid int
	,param_userid int
	,param_ip varchar(39)
)
begin
	update topics
	set
		topicisclose = 0
		,topiclasteditdate = utc_timestamp()
		,topiclastedituser = param_userid
		,topiclasteditip = param_ip
	where
		topicid = param_topicid;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptopicssubscriptionsdelete */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptopicssubscriptionsdelete(
	param_topicid int
	,param_userid int
	,param_userguid char(32)
)
begin

delete s
from
	topicssubscriptions s
	inner join users u
where
  u.userid = s.userid
  and
	s.topicid = param_topicid
	and
	s.userid = param_userid
	and
	u.userguid = param_userguid;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptopicssubscriptionsgetbytopic */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptopicssubscriptionsgetbytopic(
	param_topicid int
)
begin
/*
	gets the active users subscribed to a topic.
	checks read access of topic vs user role
*/
select
	u.userid
	,u.username
	,u.useremail
	,u.useremailpolicy
	,u.userguid
from
	topicssubscriptions s
	inner join topics t on t.topicid = s.topicid
	inner join users u on u.userid = s.userid
where
	s.topicid = param_topicid
	and
	u.active = 1
	and
	u.usergroupid >= ifnull(t.readaccessgroupid, -1);
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptopicssubscriptionsgetbyuser */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptopicssubscriptionsgetbyuser(
  param_userid int
)
begin

select
	t.topicid
	,t.topictitle
	,t.topicshortname
	,t.forumid
	,t.forumname
	,t.forumshortname
from
	topicssubscriptions s
	inner join topicscomplete t on t.topicid = s.topicid
where
	s.userid = param_userid
order by
	s.topicid desc;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptopicssubscriptionsinsert */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptopicssubscriptionsinsert(
	param_topicid int
	,param_userid int
)
begin
if not exists (select topicid from topicssubscriptions where topicid = param_topicid and userid = param_userid) then
	insert into topicssubscriptions
	(topicid, userid)
	values
	(param_topicid, param_userid);
end if;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptopicsupdate */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptopicsupdate(
	param_topicid int
	,param_topictitle nvarchar(256)
	,param_topicdescription longtext
	,param_userid int
	,param_topictags nvarchar(256)
	,param_topicorder int
	,param_readaccessgroupid smallint
	,param_postaccessgroupid smallint
	,param_ip varchar(39)
)
begin

declare var_previoustags nvarchar(256);

start transaction;

  select topictags into var_previoustags from topics where topicid=param_topicid;

  if param_topicorder is not null then
	  select max(topicorder)+1 into param_topicorder from topics;
  	set param_topicorder = ifnull(param_topicorder, 1);
  end if;


	update topics t
	set
		topictitle = param_topictitle
		,topicdescription = param_topicdescription
		,topiclasteditdate = utc_timestamp()
		,topictags = param_topictags
		,topiclastedituser = param_userid
		,topiclasteditip = param_ip
		,topicorder = param_topicorder
		,readaccessgroupid = param_readaccessgroupid
		,postaccessgroupid = param_postaccessgroupid
	where
		topicid = param_topicid;

	-- edit tags
  set @tags=param_topictags;
  set @topicid=param_topicid;
  set @previoustags=var_previoustags;
	call sptagsinsert (@tags, @topicid, @previoustags);

commit;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists sptopicsupdatelastmessage */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure sptopicsupdatelastmessage(
	param_topicid int
	,param_messageid int
)
begin

update topics
set
	topicreplies = topicreplies + 1
	,lastmessageid = param_messageid
where
	topicid = param_topicid;


end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spusersdelete */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spusersdelete(param_userid int)
begin
update users
set
	active = 0
where
	userid = param_userid;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spusersdemote */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spusersdemote(param_userid int)
begin
declare var_usergroupid int;
select usergroupid into var_usergroupid from users where userid = param_userid;
select max(usergroupid) into var_usergroupid from usersgroups where usergroupid < var_usergroupid;

if var_usergroupid is not null then
	update users
	set
		usergroupid = var_usergroupid
	where
		userid = param_userid;
end if;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spusersget */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spusersget(param_userid int)
begin

select
	u.userid
	,u.username
	,u.userprofile
	,u.usersignature
	,u.usergroupid
	,u.userbirthdate
	,u.userwebsite
	,u.usertimezone
	,u.userphoto
	,u.userregistrationdate
	,u.userexternalprofileurl
	,u.useremail
	,u.useremailpolicy
	,ug.usergroupid
	,ug.usergroupname
from
	users u
	inner join usersgroups ug on ug.usergroupid = u.usergroupid
where
	u.userid = param_userid;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spusersgetall */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spusersgetall()
begin
select
	u.userid
	,u.username
	,u.userprofile
	,u.usersignature
	,u.usergroupid
	,u.userbirthdate
	,u.userwebsite
	,u.usertimezone
	,u.userphoto
	,u.userregistrationdate
	,ug.usergroupid
	,ug.usergroupname
from
	users u
	inner join usersgroups ug on ug.usergroupid = u.usergroupid
where
	u.active = 1
order by
	u.username;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spusersgetbyname */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spusersgetbyname(
  param_username nvarchar(50)
)
begin

select
	u.userid
	,u.username
	,u.userprofile
	,u.usersignature
	,u.usergroupid
	,u.userbirthdate
	,u.userwebsite
	,u.usertimezone
	,u.userphoto
	,u.userregistrationdate
	,ug.usergroupid
	,ug.usergroupname
from
	users u
	inner join usersgroups ug on ug.usergroupid = u.usergroupid
where
	u.username like concat('%', param_username, '%')
	and
	u.active = 1
order by
	u.username;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spusersgetbypasswordresetguid */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spusersgetbypasswordresetguid(
	param_provider nvarchar(32)
	,param_passwordresetguid nvarchar(64)
)
begin
select
	u.userid
	,u.username
	,u.usergroupid
	,u.userguid
	,u.usertimezone
	,u.userexternalprofileurl
	,u.userproviderlastcall
	,u.useremail
	,u.userproviderid
	,u.passwordresetguid
	,u.passwordresetguidexpiredate
from
	users u
where
	userprovider = param_provider
	and
	passwordresetguid = param_passwordresetguid;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spusersgetbyprovider */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spusersgetbyprovider(
	param_provider nvarchar(32)
	,param_providerid nvarchar(64)
)
begin
select
	u.userid
	,u.username
	,u.usergroupid
	,u.userguid
	,u.usertimezone
	,u.userexternalprofileurl
	,u.userproviderlastcall
	,u.useremail
from
	users u
where
	userprovider = param_provider
	and
	userproviderid = param_providerid
	and
	u.active = 1;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spusersgettestuser */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spusersgettestuser()
begin
select
	u.userid
	,u.username
	,u.usergroupid
	,u.userguid
	,u.usertimezone
	,u.userexternalprofileurl
	,u.userproviderlastcall
	,u.useremail
from
	users u
where
	u.active = 1
order by
	u.usergroupid desc
limit 1;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spusersgroupsget */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spusersgroupsget(param_usergroupid smallint)
begin

select
	usergroupid
	,usergroupname
from
	usersgroups
where
	usergroupid = param_usergroupid;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spusersgroupsgetall */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spusersgroupsgetall()
begin
    select 
        usergroupid
        ,usergroupname
    from
        usersgroups
    order by 
        usergroupid asc;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spusersinsertfromprovider */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spusersinsertfromprovider(
  param_username nvarchar(50)
	,param_userprofile longtext
	,param_usersignature longtext
	,param_usergroupid smallint
	,param_userbirthdate datetime
	,param_userwebsite nvarchar(255)
	,param_userguid char(32)
	,param_usertimezone decimal(9,2)
	,param_useremail nvarchar(100)
	,param_useremailpolicy int
	,param_userphoto nvarchar(1024)
	,param_userexternalprofileurl nvarchar(255)
	,param_userprovider nvarchar(32)
	,param_userproviderid nvarchar(64)
 )
begin

-- if it is the first active user -> make it an admin
declare var_usercount int;
declare var_userid int;
select count(userid) into var_usercount from users where active = 1;
if ifnull(var_usercount, 0) > 0 then
 set param_usergroupid = 1;
else
  select max(usergroupid) into param_usergroupid from usersgroups;
end if;

insert into users
   (username
   ,userprofile
   ,usersignature
   ,usergroupid
   ,active
   ,userbirthdate
   ,userwebsite
   ,userguid
   ,usertimezone
   ,useremail
   ,useremailpolicy
   ,userphoto
   ,userregistrationdate
   ,userexternalprofileurl
   ,userprovider
   ,userproviderid
   ,userproviderlastcall)
values
	(param_username
   ,param_userprofile
   ,param_usersignature
   ,param_usergroupid
   ,1 -- active
   ,param_userbirthdate
   ,param_userwebsite
   ,param_userguid
   ,param_usertimezone
   ,param_useremail
   ,param_useremailpolicy
   ,param_userphoto
   ,utc_timestamp() -- regitrationdate
   ,param_userexternalprofileurl
   ,param_userprovider
   ,param_userproviderid
   ,utc_timestamp() -- userproviderlastcall
	);

select last_insert_id() into var_userid;
select
	u.userid
	,u.username
	,u.usergroupid
	,u.userguid
	,u.usertimezone
	,u.userexternalprofileurl
	,u.userproviderlastcall
	,u.useremail
from
	users u
where
	u.userid = var_userid;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spuserspromote */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spuserspromote(param_userid int)
begin
declare var_usergroupid int;
select usergroupid into var_usergroupid from users where userid = param_userid;
select min(usergroupid) into var_usergroupid from usersgroups where usergroupid > var_usergroupid;

if var_usergroupid is not null then
	update users
	set
		usergroupid = var_usergroupid
	where
		userid = param_userid;
end if;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spusersupdate */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spusersupdate(
	param_userid int
	,param_username nvarchar(50)
	,param_userprofile longtext
	,param_usersignature longtext
	,param_userbirthdate datetime
	,param_userwebsite nvarchar(255)
	,param_usertimezone decimal(9,2)
	,param_useremail nvarchar(100)
	,param_useremailpolicy int
	,param_userphoto nvarchar(1024)
	,param_userexternalprofileurl nvarchar(255)
)
begin

update users
set
username = param_username
,userprofile = param_userprofile
,usersignature = param_usersignature
,userbirthdate = param_userbirthdate
,userwebsite = param_userwebsite
,usertimezone = param_usertimezone
,useremail = param_useremail
,useremailpolicy = param_useremailpolicy
,userphoto = param_userphoto
,userexternalprofileurl = param_userexternalprofileurl
where 
	userid = param_userid;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spusersupdateemail */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spusersupdateemail(
	param_userid int
	,param_useremail nvarchar(100)
	,param_useremailpolicy int
)
begin
update users
set
	useremail = param_useremail
	,useremailpolicy = param_useremailpolicy
where
	userid = param_userid;

end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;
/*!50003 drop procedure if exists spusersupdatepasswordresetguid */;
/*!50003 set @saved_cs_client      = @@character_set_client */ ;
/*!50003 set @saved_cs_results     = @@character_set_results */ ;
/*!50003 set @saved_col_connection = @@collation_connection */ ;
/*!50003 set character_set_client  = utf8 */ ;
/*!50003 set character_set_results = utf8 */ ;
/*!50003 set collation_connection  = utf8_general_ci */ ;
/*!50003 set @saved_sql_mode       = @@sql_mode */ ;
/*!50003 set sql_mode              = 'strict_trans_tables,no_auto_create_user,no_engine_substitution' */ ;
delimiter ;;
/*!50003 create*/ /*!50003 procedure spusersupdatepasswordresetguid(
	param_userid int
	,param_passwordresetguid nvarchar(100)
	,param_passwordresetguidexpiredate datetime
)
begin
update users
set
	passwordresetguid = param_passwordresetguid
	,passwordresetguidexpiredate = param_passwordresetguidexpiredate
where
	userid = param_userid;
end */;;
delimiter ;
/*!50003 set sql_mode              = @saved_sql_mode */ ;
/*!50003 set character_set_client  = @saved_cs_client */ ;
/*!50003 set character_set_results = @saved_cs_results */ ;
/*!50003 set collation_connection  = @saved_col_connection */ ;


--
-- final view structure for view `messagescomplete`
--

/*!50001 drop table if exists messagescomplete*/;
/*!50001 drop view if exists messagescomplete*/;
/*!50001 set @saved_cs_client          = @@character_set_client */;
/*!50001 set @saved_cs_results         = @@character_set_results */;
/*!50001 set @saved_col_connection     = @@collation_connection */;
/*!50001 set character_set_client      = utf8 */;
/*!50001 set character_set_results     = utf8 */;
/*!50001 set collation_connection      = utf8_general_ci */;
/*!50001 create algorithm=undefined */
/*!50001 view messagescomplete as select m.topicid as topicid,m.messageid as messageid,m.messagebody as messagebody,m.messagecreationdate as messagecreationdate,m.messagelasteditdate as messagelasteditdate,m.parentid as parentid,m.userid as userid,m.active as active,u.username as username,u.usersignature as usersignature,u.usergroupid as usergroupid,g.usergroupname as usergroupname,u.userphoto as userphoto,u.userregistrationdate as userregistrationdate from (((messages m join users u on((u.userid = m.userid))) join usersgroups g on((g.usergroupid = u.usergroupid))) left join messages p on(((p.topicid = m.topicid) and (p.messageid = m.parentid) and (p.active = 1)))) */;
/*!50001 set character_set_client      = @saved_cs_client */;
/*!50001 set character_set_results     = @saved_cs_results */;
/*!50001 set collation_connection      = @saved_col_connection */;

--
-- final view structure for view `topicscomplete`
--

/*!50001 drop table if exists topicscomplete*/;
/*!50001 drop view if exists topicscomplete*/;
/*!50001 set @saved_cs_client          = @@character_set_client */;
/*!50001 set @saved_cs_results         = @@character_set_results */;
/*!50001 set @saved_col_connection     = @@collation_connection */;
/*!50001 set character_set_client      = utf8 */;
/*!50001 set character_set_results     = utf8 */;
/*!50001 set collation_connection      = utf8_general_ci */;
/*!50001 create algorithm=undefined */
/*!50001 view topicscomplete as select t.topicid as topicid,t.topictitle as topictitle,t.topicshortname as topicshortname,t.topicdescription as topicdescription,t.topiccreationdate as topiccreationdate,t.topicviews as topicviews,t.topicreplies as topicreplies,t.userid as userid,t.topictags as topictags,t.topicisclose as topicisclose,t.topicorder as topicorder,t.lastmessageid as lastmessageid,u.username as username,f.forumid as forumid,f.forumname as forumname,f.forumshortname as forumshortname,(case when (ifnull(t.readaccessgroupid,-(1)) >= ifnull(f.readaccessgroupid,-(1))) then t.readaccessgroupid else f.readaccessgroupid end) as readaccessgroupid,(case when (t.postaccessgroupid >= ifnull(f.readaccessgroupid,-(1))) then t.postaccessgroupid else f.readaccessgroupid end) as postaccessgroupid from ((topics t join users u on((u.userid = t.userid))) join forums f on((f.forumid = t.forumid))) where ((t.active = 1) and (f.active = 1)) */;
/*!50001 set character_set_client      = @saved_cs_client */;
/*!50001 set character_set_results     = @saved_cs_results */;
/*!50001 set collation_connection      = @saved_col_connection */;

/*!40101 set sql_mode=@old_sql_mode */;
/*!40014 set foreign_key_checks=@old_foreign_key_checks */;
/*!40014 set unique_checks=@old_unique_checks */;
/*!40101 set character_set_client=@old_character_set_client */;
/*!40101 set character_set_results=@old_character_set_results */;
/*!40101 set collation_connection=@old_collation_connection */;
/*!40111 set sql_notes=@old_sql_notes */;

-- dump completed on 2012-02-21 12:28:58
