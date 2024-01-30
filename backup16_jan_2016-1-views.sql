/*
SQLyog Community v8.32 
MySQL - 5.7.14-log : Database - admin_ofc
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `vw_city_state_country_details` */

DROP TABLE IF EXISTS `vw_city_state_country_details`;

/*!50001 DROP VIEW IF EXISTS `vw_city_state_country_details` */;
/*!50001 DROP TABLE IF EXISTS `vw_city_state_country_details` */;

/*!50001 CREATE TABLE  `vw_city_state_country_details`(
 `city_id` varchar(50) ,
 `city_name` varchar(1000) ,
 `city_aliasname` varchar(100) ,
 `state_id` varchar(50) ,
 `state_name` varchar(1000) ,
 `country_id` varchar(50) ,
 `country_name` varchar(1000) 
)*/;

/*Table structure for table `vw_company_city_state_country_details` */

DROP TABLE IF EXISTS `vw_company_city_state_country_details`;

/*!50001 DROP VIEW IF EXISTS `vw_company_city_state_country_details` */;
/*!50001 DROP TABLE IF EXISTS `vw_company_city_state_country_details` */;

/*!50001 CREATE TABLE  `vw_company_city_state_country_details`(
 `country_id` varchar(50) ,
 `country_name` varchar(1000) ,
 `state_id` varchar(50) ,
 `state_name` varchar(1000) ,
 `city_id` varchar(50) ,
 `city_name` varchar(1000) ,
 `company_id` varchar(50) ,
 `company_name` varchar(500) ,
 `company_emailid` varchar(100) ,
 `company_address` longtext ,
 `company_phonenos` varchar(500) ,
 `company_landline` varchar(100) ,
 `company_regno` varchar(100) ,
 `createdate` datetime ,
 `modifieddate` datetime ,
 `status` varchar(10) 
)*/;

/*Table structure for table `vw_membereducation_education` */

DROP TABLE IF EXISTS `vw_membereducation_education`;

/*!50001 DROP VIEW IF EXISTS `vw_membereducation_education` */;
/*!50001 DROP TABLE IF EXISTS `vw_membereducation_education` */;

/*!50001 CREATE TABLE  `vw_membereducation_education`(
 `ofcmembereducation_id` varchar(50) ,
 `ofcmembers_id` varchar(50) ,
 `education_id` varchar(50) ,
 `createdate` datetime ,
 `modifieddate` datetime ,
 `status` varchar(10) ,
 `education_name` varchar(500) ,
 `ofcmemsession_id` varchar(50) ,
 `ofcmemsession_deviceid` longtext ,
 `ofcmemsession_devicetype` varchar(50) 
)*/;

/*Table structure for table `vw_memberemployment_maincat` */

DROP TABLE IF EXISTS `vw_memberemployment_maincat`;

/*!50001 DROP VIEW IF EXISTS `vw_memberemployment_maincat` */;
/*!50001 DROP TABLE IF EXISTS `vw_memberemployment_maincat` */;

/*!50001 CREATE TABLE  `vw_memberemployment_maincat`(
 `ofcmememployment_id` varchar(50) ,
 `ofcmembers_id` varchar(50) ,
 `maincat_id` varchar(50) ,
 `ofcmememployment_name` varchar(500) ,
 `ofcmememployment_description` longtext ,
 `ofcmememployment_role` varchar(500) ,
 `ofcmememployment_startdate` datetime ,
 `ofcmememployment_enddate` datetime ,
 `createdate` datetime ,
 `modifieddate` datetime ,
 `status` varchar(10) ,
 `maincat_name` varchar(500) ,
 `ofcmemsession_id` varchar(50) ,
 `ofcmemsession_deviceid` longtext ,
 `ofcmemsession_devicetype` varchar(50) 
)*/;

/*Table structure for table `vw_memberexperience_maincat` */

DROP TABLE IF EXISTS `vw_memberexperience_maincat`;

/*!50001 DROP VIEW IF EXISTS `vw_memberexperience_maincat` */;
/*!50001 DROP TABLE IF EXISTS `vw_memberexperience_maincat` */;

/*!50001 CREATE TABLE  `vw_memberexperience_maincat`(
 `ofcmemexperience_id` varchar(50) ,
 `ofcmembers_id` varchar(50) ,
 `maincat_id` varchar(50) ,
 `ofcmemexperience_name` varchar(500) ,
 `ofcmemexperience_description` longtext ,
 `ofcmemexperience_role` varchar(500) ,
 `ofcmemexperience_startdate` datetime ,
 `ofcmemexperience_enddate` datetime ,
 `createdate` datetime ,
 `modifieddate` datetime ,
 `status` varchar(10) ,
 `maincat_name` varchar(500) ,
 `ofcmemsession_id` varchar(50) ,
 `ofcmemsession_deviceid` longtext ,
 `ofcmemsession_devicetype` varchar(50) 
)*/;

/*Table structure for table `vw_membermyproject_maincat` */

DROP TABLE IF EXISTS `vw_membermyproject_maincat`;

/*!50001 DROP VIEW IF EXISTS `vw_membermyproject_maincat` */;
/*!50001 DROP TABLE IF EXISTS `vw_membermyproject_maincat` */;

/*!50001 CREATE TABLE  `vw_membermyproject_maincat`(
 `maincat_id` varchar(50) ,
 `maincat_name` varchar(500) ,
 `ofcmemmyproject_id` varchar(50) ,
 `ofcmembers_id` varchar(50) ,
 `ofcmemmyproject_title` varchar(500) ,
 `ofcmemmyproject_url` longtext ,
 `ofcmemmyproject_description` longtext ,
 `createdate` datetime ,
 `modifieddate` datetime ,
 `status` varchar(10) ,
 `ofcmemsession_id` varchar(50) ,
 `ofcmemsession_deviceid` longtext ,
 `ofcmemsession_devicetype` varchar(50) 
)*/;

/*Table structure for table `vw_ofcmember_myproject` */

DROP TABLE IF EXISTS `vw_ofcmember_myproject`;

/*!50001 DROP VIEW IF EXISTS `vw_ofcmember_myproject` */;
/*!50001 DROP TABLE IF EXISTS `vw_ofcmember_myproject` */;

/*!50001 CREATE TABLE  `vw_ofcmember_myproject`(
 `ofcmembers_id` varchar(1) ,
 `ofcmemmyproject_title` varchar(500) ,
 `ofcmemmyproject_url` longtext ,
 `ofcmemmyproject_description` longtext ,
 `createdate` datetime ,
 `modifieddate` datetime ,
 `status` varchar(10) ,
 `maincat_id` varchar(50) ,
 `ofcmemmyproject_id` varchar(50) 
)*/;

/*Table structure for table `vw_ofcsession_ofcmembers_details` */

DROP TABLE IF EXISTS `vw_ofcsession_ofcmembers_details`;

/*!50001 DROP VIEW IF EXISTS `vw_ofcsession_ofcmembers_details` */;
/*!50001 DROP TABLE IF EXISTS `vw_ofcsession_ofcmembers_details` */;

/*!50001 CREATE TABLE  `vw_ofcsession_ofcmembers_details`(
 `ofcmemsession_id` varchar(50) ,
 `ofcmemsession_deviceid` longtext ,
 `ofcmemsession_devicetype` varchar(50) ,
 `logindate` datetime ,
 `ofcmembers_fname` varchar(500) ,
 `ofcmembers_lname` varchar(500) ,
 `ofcmembers_name` varchar(1000) ,
 `ofcmember_type` varchar(50) ,
 `city_id` varchar(50) ,
 `ofcmembers_emailid` varchar(500) ,
 `ofcmembers_address1` varchar(1000) ,
 `ofcmembers_address2` varchar(1000) ,
 `ofcmembers_pincode` varchar(500) ,
 `ofcmembers_contactnos` varchar(500) ,
 `ofcmembers_availability` varchar(50) ,
 `ofcmembers_displayname` varchar(500) ,
 `ofcmembers_description` longtext ,
 `ofcmembers_selfrating` int(11) ,
 `ofcmembers_experiencelevel` varchar(50) ,
 `ofcmembers_gender` varchar(50) ,
 `ofcmembers_dob` datetime ,
 `ofcmembers_nosofteammembers` int(11) 
)*/;

/*Table structure for table `vw_popuplarsearch_homepage_filesimages` */

DROP TABLE IF EXISTS `vw_popuplarsearch_homepage_filesimages`;

/*!50001 DROP VIEW IF EXISTS `vw_popuplarsearch_homepage_filesimages` */;
/*!50001 DROP TABLE IF EXISTS `vw_popuplarsearch_homepage_filesimages` */;

/*!50001 CREATE TABLE  `vw_popuplarsearch_homepage_filesimages`(
 `popularsearch_id` varchar(50) ,
 `popularsearch_srno` int(11) ,
 `maincat_id` varchar(50) ,
 `createdate` datetime ,
 `modifieddate` datetime ,
 `status` varchar(10) ,
 `uploadfile_id` bigint(20) ,
 `uploadfile_tblname` varchar(500) ,
 `uploadfile_actulalfilename` varchar(500) ,
 `uploadfile_filename` varchar(1000) ,
 `uploadfile_type` varchar(100) ,
 `uploadfile_path` longtext ,
 `uploadfile_status` varchar(50) ,
 `uploadfile_tblpkid` varchar(100) 
)*/;

/*Table structure for table `vw_skill_subcat_maincat_details` */

DROP TABLE IF EXISTS `vw_skill_subcat_maincat_details`;

/*!50001 DROP VIEW IF EXISTS `vw_skill_subcat_maincat_details` */;
/*!50001 DROP TABLE IF EXISTS `vw_skill_subcat_maincat_details` */;

/*!50001 CREATE TABLE  `vw_skill_subcat_maincat_details`(
 `subcat_id` varchar(50) ,
 `subcat_name` varchar(500) ,
 `maincat_id` varchar(50) ,
 `maincat_name` varchar(500) ,
 `skill_id` varchar(50) ,
 `skill_name` varchar(500) ,
 `skill_alias` varchar(100) ,
 `createdate` datetime ,
 `modifieddate` datetime ,
 `status` varchar(10) 
)*/;

/*Table structure for table `vw_state_country_details` */

DROP TABLE IF EXISTS `vw_state_country_details`;

/*!50001 DROP VIEW IF EXISTS `vw_state_country_details` */;
/*!50001 DROP TABLE IF EXISTS `vw_state_country_details` */;

/*!50001 CREATE TABLE  `vw_state_country_details`(
 `country_id` varchar(50) ,
 `country_name` varchar(1000) ,
 `country_aliasname` varchar(100) ,
 `state_id` varchar(50) ,
 `state_name` varchar(1000) ,
 `state_aliasname` varchar(100) 
)*/;

/*Table structure for table `vw_subcat_keyword_details` */

DROP TABLE IF EXISTS `vw_subcat_keyword_details`;

/*!50001 DROP VIEW IF EXISTS `vw_subcat_keyword_details` */;
/*!50001 DROP TABLE IF EXISTS `vw_subcat_keyword_details` */;

/*!50001 CREATE TABLE  `vw_subcat_keyword_details`(
 `subcat_id` varchar(50) ,
 `subcat_name` varchar(500) ,
 `subcat_aliasname` varchar(100) ,
 `maincat_id` varchar(50) ,
 `createdate` datetime ,
 `modifieddate` datetime ,
 `status` varchar(10) ,
 `keysubcat_id` bigint(20) ,
 `keysubcat_name` varchar(500) ,
 `keysubcat_searchtext` varchar(100) 
)*/;

/*Table structure for table `vw_subcat_maincat_details` */

DROP TABLE IF EXISTS `vw_subcat_maincat_details`;

/*!50001 DROP VIEW IF EXISTS `vw_subcat_maincat_details` */;
/*!50001 DROP TABLE IF EXISTS `vw_subcat_maincat_details` */;

/*!50001 CREATE TABLE  `vw_subcat_maincat_details`(
 `maincat_id` varchar(50) ,
 `maincat_name` varchar(500) ,
 `subcat_id` varchar(50) ,
 `subcat_name` varchar(500) ,
 `subcat_aliasname` varchar(100) ,
 `createdate` datetime ,
 `modifieddate` datetime ,
 `status` varchar(10) 
)*/;

/*View structure for view vw_city_state_country_details */

/*!50001 DROP TABLE IF EXISTS `vw_city_state_country_details` */;
/*!50001 DROP VIEW IF EXISTS `vw_city_state_country_details` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_city_state_country_details` AS (select `b`.`city_id` AS `city_id`,`b`.`city_name` AS `city_name`,`b`.`city_aliasname` AS `city_aliasname`,`a`.`state_id` AS `state_id`,`a`.`state_name` AS `state_name`,`a`.`country_id` AS `country_id`,`a`.`country_name` AS `country_name` from (`vw_state_country_details` `a` join `tbl_city_master` `b`) where (`a`.`state_id` = `b`.`state_id`)) */;

/*View structure for view vw_company_city_state_country_details */

/*!50001 DROP TABLE IF EXISTS `vw_company_city_state_country_details` */;
/*!50001 DROP VIEW IF EXISTS `vw_company_city_state_country_details` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_company_city_state_country_details` AS (select `a`.`country_id` AS `country_id`,`a`.`country_name` AS `country_name`,`a`.`state_id` AS `state_id`,`a`.`state_name` AS `state_name`,`a`.`city_id` AS `city_id`,`a`.`city_name` AS `city_name`,`b`.`company_id` AS `company_id`,`b`.`company_name` AS `company_name`,`b`.`company_emailid` AS `company_emailid`,`b`.`company_address` AS `company_address`,`b`.`company_phonenos` AS `company_phonenos`,`b`.`company_landline` AS `company_landline`,`b`.`company_regno` AS `company_regno`,`b`.`createdate` AS `createdate`,`b`.`modifieddate` AS `modifieddate`,`b`.`status` AS `status` from (`vw_city_state_country_details` `a` join `tbl_company_master` `b`) where (`a`.`city_id` = `b`.`city_id`)) */;

/*View structure for view vw_membereducation_education */

/*!50001 DROP TABLE IF EXISTS `vw_membereducation_education` */;
/*!50001 DROP VIEW IF EXISTS `vw_membereducation_education` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_membereducation_education` AS (select `a`.`ofcmembereducation_id` AS `ofcmembereducation_id`,`a`.`ofcmembers_id` AS `ofcmembers_id`,`a`.`education_id` AS `education_id`,`a`.`createdate` AS `createdate`,`a`.`modifieddate` AS `modifieddate`,`a`.`status` AS `status`,`b`.`education_name` AS `education_name`,`c`.`ofcmemsession_id` AS `ofcmemsession_id`,`c`.`ofcmemsession_deviceid` AS `ofcmemsession_deviceid`,`c`.`ofcmemsession_devicetype` AS `ofcmemsession_devicetype` from ((`tbl_ofcmembereducation_details` `a` join `tbl_education_master` `b`) join `tbl_ofcmemsession_details` `c`) where ((`a`.`education_id` = `b`.`education_id`) and (`a`.`ofcmembers_id` = `c`.`ofcmembers_id`) and (`c`.`status` = 'active'))) */;

/*View structure for view vw_memberemployment_maincat */

/*!50001 DROP TABLE IF EXISTS `vw_memberemployment_maincat` */;
/*!50001 DROP VIEW IF EXISTS `vw_memberemployment_maincat` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_memberemployment_maincat` AS (select `a`.`ofcmememployment_id` AS `ofcmememployment_id`,`a`.`ofcmembers_id` AS `ofcmembers_id`,`a`.`maincat_id` AS `maincat_id`,`a`.`ofcmememployment_name` AS `ofcmememployment_name`,`a`.`ofcmememployment_description` AS `ofcmememployment_description`,`a`.`ofcmememployment_role` AS `ofcmememployment_role`,`a`.`ofcmememployment_startdate` AS `ofcmememployment_startdate`,`a`.`ofcmememployment_enddate` AS `ofcmememployment_enddate`,`a`.`createdate` AS `createdate`,`a`.`modifieddate` AS `modifieddate`,`a`.`status` AS `status`,`b`.`maincat_name` AS `maincat_name`,`c`.`ofcmemsession_id` AS `ofcmemsession_id`,`c`.`ofcmemsession_deviceid` AS `ofcmemsession_deviceid`,`c`.`ofcmemsession_devicetype` AS `ofcmemsession_devicetype` from ((`tbl_ofcmemberemployment_details` `a` join `tbl_maincat_master` `b`) join `tbl_ofcmemsession_details` `c`) where ((`a`.`maincat_id` = `b`.`maincat_id`) and (`a`.`ofcmembers_id` = `c`.`ofcmembers_id`) and (`c`.`status` = 'active'))) */;

/*View structure for view vw_memberexperience_maincat */

/*!50001 DROP TABLE IF EXISTS `vw_memberexperience_maincat` */;
/*!50001 DROP VIEW IF EXISTS `vw_memberexperience_maincat` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_memberexperience_maincat` AS (select `a`.`ofcmemexperience_id` AS `ofcmemexperience_id`,`a`.`ofcmembers_id` AS `ofcmembers_id`,`a`.`maincat_id` AS `maincat_id`,`a`.`ofcmemexperience_name` AS `ofcmemexperience_name`,`a`.`ofcmemexperience_description` AS `ofcmemexperience_description`,`a`.`ofcmemexperience_role` AS `ofcmemexperience_role`,`a`.`ofcmemexperience_startdate` AS `ofcmemexperience_startdate`,`a`.`ofcmemexperience_enddate` AS `ofcmemexperience_enddate`,`a`.`createdate` AS `createdate`,`a`.`modifieddate` AS `modifieddate`,`a`.`status` AS `status`,`b`.`maincat_name` AS `maincat_name`,`c`.`ofcmemsession_id` AS `ofcmemsession_id`,`c`.`ofcmemsession_deviceid` AS `ofcmemsession_deviceid`,`c`.`ofcmemsession_devicetype` AS `ofcmemsession_devicetype` from ((`tbl_ofcmemberexperience_details` `a` join `tbl_maincat_master` `b`) join `tbl_ofcmemsession_details` `c`) where ((`a`.`ofcmembers_id` = `c`.`ofcmembers_id`) and (`a`.`maincat_id` = `b`.`maincat_id`) and (`c`.`status` = 'active'))) */;

/*View structure for view vw_membermyproject_maincat */

/*!50001 DROP TABLE IF EXISTS `vw_membermyproject_maincat` */;
/*!50001 DROP VIEW IF EXISTS `vw_membermyproject_maincat` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_membermyproject_maincat` AS (select `a`.`maincat_id` AS `maincat_id`,`b`.`maincat_name` AS `maincat_name`,`a`.`ofcmemmyproject_id` AS `ofcmemmyproject_id`,`a`.`ofcmembers_id` AS `ofcmembers_id`,`a`.`ofcmemmyproject_title` AS `ofcmemmyproject_title`,`a`.`ofcmemmyproject_url` AS `ofcmemmyproject_url`,`a`.`ofcmemmyproject_description` AS `ofcmemmyproject_description`,`a`.`createdate` AS `createdate`,`a`.`modifieddate` AS `modifieddate`,`a`.`status` AS `status`,`c`.`ofcmemsession_id` AS `ofcmemsession_id`,`c`.`ofcmemsession_deviceid` AS `ofcmemsession_deviceid`,`c`.`ofcmemsession_devicetype` AS `ofcmemsession_devicetype` from ((`tbl_ofcmembermyproject_details` `a` join `tbl_maincat_master` `b`) join `tbl_ofcmemsession_details` `c`) where ((`a`.`maincat_id` = `b`.`maincat_id`) and (`a`.`ofcmembers_id` = `c`.`ofcmembers_id`) and (`c`.`status` = 'active'))) */;

/*View structure for view vw_ofcmember_myproject */

/*!50001 DROP TABLE IF EXISTS `vw_ofcmember_myproject` */;
/*!50001 DROP VIEW IF EXISTS `vw_ofcmember_myproject` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_ofcmember_myproject` AS (select '-' AS `ofcmembers_id`,`a`.`ofcmemmyproject_title` AS `ofcmemmyproject_title`,`a`.`ofcmemmyproject_url` AS `ofcmemmyproject_url`,`a`.`ofcmemmyproject_description` AS `ofcmemmyproject_description`,`a`.`createdate` AS `createdate`,`a`.`modifieddate` AS `modifieddate`,`a`.`status` AS `status`,`a`.`maincat_id` AS `maincat_id`,`a`.`ofcmemmyproject_id` AS `ofcmemmyproject_id` from `tbl_ofcmembermyproject_details` `a`) */;

/*View structure for view vw_ofcsession_ofcmembers_details */

/*!50001 DROP TABLE IF EXISTS `vw_ofcsession_ofcmembers_details` */;
/*!50001 DROP VIEW IF EXISTS `vw_ofcsession_ofcmembers_details` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_ofcsession_ofcmembers_details` AS (select `a`.`ofcmemsession_id` AS `ofcmemsession_id`,`a`.`ofcmemsession_deviceid` AS `ofcmemsession_deviceid`,`a`.`ofcmemsession_devicetype` AS `ofcmemsession_devicetype`,`a`.`createdate` AS `logindate`,`b`.`ofcmembers_fname` AS `ofcmembers_fname`,`b`.`ofcmembers_lname` AS `ofcmembers_lname`,`b`.`ofcmembers_name` AS `ofcmembers_name`,`b`.`ofcmember_type` AS `ofcmember_type`,`b`.`city_id` AS `city_id`,`b`.`ofcmembers_emailid` AS `ofcmembers_emailid`,`b`.`ofcmembers_address1` AS `ofcmembers_address1`,`b`.`ofcmembers_address2` AS `ofcmembers_address2`,`b`.`ofcmembers_pincode` AS `ofcmembers_pincode`,`b`.`ofcmembers_contactnos` AS `ofcmembers_contactnos`,`b`.`ofcmembers_availability` AS `ofcmembers_availability`,`b`.`ofcmembers_displayname` AS `ofcmembers_displayname`,`b`.`ofcmembers_description` AS `ofcmembers_description`,`b`.`ofcmembers_selfrating` AS `ofcmembers_selfrating`,`b`.`ofcmembers_experiencelevel` AS `ofcmembers_experiencelevel`,`b`.`ofcmembers_gender` AS `ofcmembers_gender`,`b`.`ofcmembers_dob` AS `ofcmembers_dob`,`b`.`ofcmembers_nosofteammembers` AS `ofcmembers_nosofteammembers` from (`tbl_ofcmemsession_details` `a` join `tbl_ofcmembers_master` `b`) where ((`a`.`ofcmembers_id` = `b`.`ofcmembers_id`) and (`a`.`status` = 'active') and (`b`.`status` = 'active'))) */;

/*View structure for view vw_popuplarsearch_homepage_filesimages */

/*!50001 DROP TABLE IF EXISTS `vw_popuplarsearch_homepage_filesimages` */;
/*!50001 DROP VIEW IF EXISTS `vw_popuplarsearch_homepage_filesimages` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_popuplarsearch_homepage_filesimages` AS (select `a`.`popularsearch_id` AS `popularsearch_id`,`a`.`popularsearch_srno` AS `popularsearch_srno`,`a`.`maincat_id` AS `maincat_id`,`a`.`createdate` AS `createdate`,`a`.`modifieddate` AS `modifieddate`,`a`.`status` AS `status`,`b`.`uploadfile_id` AS `uploadfile_id`,`b`.`uploadfile_tblname` AS `uploadfile_tblname`,`b`.`uploadfile_actulalfilename` AS `uploadfile_actulalfilename`,`b`.`uploadfile_filename` AS `uploadfile_filename`,`b`.`uploadfile_type` AS `uploadfile_type`,`b`.`uploadfile_path` AS `uploadfile_path`,`b`.`uploadfile_status` AS `uploadfile_status`,`b`.`uploadfile_tblpkid` AS `uploadfile_tblpkid` from (`tbl_popularsearch_homepage` `a` join `tbl_uploadedfile_master` `b`) where ((`a`.`popularsearch_id` = `b`.`uploadfile_tblpkid`) and (`b`.`uploadfile_tblname` = 'tbl_popularsearch_homepage'))) */;

/*View structure for view vw_skill_subcat_maincat_details */

/*!50001 DROP TABLE IF EXISTS `vw_skill_subcat_maincat_details` */;
/*!50001 DROP VIEW IF EXISTS `vw_skill_subcat_maincat_details` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_skill_subcat_maincat_details` AS (select `a`.`subcat_id` AS `subcat_id`,`a`.`subcat_name` AS `subcat_name`,`a`.`maincat_id` AS `maincat_id`,`a`.`maincat_name` AS `maincat_name`,`b`.`skill_id` AS `skill_id`,`b`.`skill_name` AS `skill_name`,`b`.`skill_alias` AS `skill_alias`,`b`.`createdate` AS `createdate`,`b`.`modifieddate` AS `modifieddate`,`b`.`status` AS `status` from (`vw_subcat_maincat_details` `a` join `tbl_skill_master` `b`) where (`a`.`subcat_id` = `b`.`subcat_id`)) */;

/*View structure for view vw_state_country_details */

/*!50001 DROP TABLE IF EXISTS `vw_state_country_details` */;
/*!50001 DROP VIEW IF EXISTS `vw_state_country_details` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_state_country_details` AS (select `a`.`country_id` AS `country_id`,`a`.`country_name` AS `country_name`,`a`.`country_aliasname` AS `country_aliasname`,`b`.`state_id` AS `state_id`,`b`.`state_name` AS `state_name`,`b`.`state_aliasname` AS `state_aliasname` from (`tbl_country_master` `a` join `tbl_state_master` `b`) where (`a`.`country_id` = `b`.`country_id`)) */;

/*View structure for view vw_subcat_keyword_details */

/*!50001 DROP TABLE IF EXISTS `vw_subcat_keyword_details` */;
/*!50001 DROP VIEW IF EXISTS `vw_subcat_keyword_details` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_subcat_keyword_details` AS (select `a`.`subcat_id` AS `subcat_id`,`a`.`subcat_name` AS `subcat_name`,`a`.`subcat_aliasname` AS `subcat_aliasname`,`a`.`maincat_id` AS `maincat_id`,`a`.`createdate` AS `createdate`,`a`.`modifieddate` AS `modifieddate`,`a`.`status` AS `status`,`b`.`keysubcat_id` AS `keysubcat_id`,`b`.`keysubcat_name` AS `keysubcat_name`,`b`.`keysubcat_searchtext` AS `keysubcat_searchtext` from (`tbl_subcat_master` `a` join `tbl_keyword_subcat` `b`) where (`a`.`subcat_id` = `b`.`subcat_id`)) */;

/*View structure for view vw_subcat_maincat_details */

/*!50001 DROP TABLE IF EXISTS `vw_subcat_maincat_details` */;
/*!50001 DROP VIEW IF EXISTS `vw_subcat_maincat_details` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_subcat_maincat_details` AS (select `b`.`maincat_id` AS `maincat_id`,`b`.`maincat_name` AS `maincat_name`,`a`.`subcat_id` AS `subcat_id`,`a`.`subcat_name` AS `subcat_name`,`a`.`subcat_aliasname` AS `subcat_aliasname`,`a`.`createdate` AS `createdate`,`a`.`modifieddate` AS `modifieddate`,`a`.`status` AS `status` from (`tbl_subcat_master` `a` join `tbl_maincat_master` `b`) where (`a`.`maincat_id` = `b`.`maincat_id`)) */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
