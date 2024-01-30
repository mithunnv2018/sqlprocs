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
/*Table structure for table `logrecord_details` */

CREATE TABLE `logrecord_details` (
  `logrecord_id` varchar(100) NOT NULL,
  `logrecord_result` longtext,
  PRIMARY KEY (`logrecord_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_certification_master` */

CREATE TABLE `tbl_certification_master` (
  `certification_id` varchar(50) NOT NULL COMMENT '{"mailtable":"","pkprefix":"CERF","pkid":"certification_id","tsname":"certification","formmodelname":"certification","subtables":[]}',
  `certification_name` varchar(500) NOT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Certification ","drptblpkname": "state_name","placeholder": "Certification Name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `certification_alias` varchar(100) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Certification Alias Name ","drptblpkname": "state_name","placeholder": "Certification Alias Name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`certification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_city_master` */

CREATE TABLE `tbl_city_master` (
  `city_id` varchar(50) NOT NULL COMMENT '{\n"mailtable":"",\n"pkprefix":"CIT",\n"pkid":"city_id",\n"tsname":"city","formmodelname":"city",\n"subtables":\n[]\n\n}',
  `city_name` varchar(1000) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "City ","drptblpkname": "state_name","placeholder": "state name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `city_aliasname` varchar(100) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "City ","drptblpkname": "state_name","placeholder": "state name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `state_id` varchar(50) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "drp","formcontrolname": "","ngmodel": "","errorstring": "State ","drptblpkname": "state_name","placeholder": "state name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  PRIMARY KEY (`city_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_company_master` */

CREATE TABLE `tbl_company_master` (
  `company_id` varchar(50) NOT NULL COMMENT '{"mailtable":"","pkprefix":"COMP","pkid":"company_id","tsname":"company","formmodelname":"company","subtables":[]}',
  `company_name` varchar(500) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "company ","drptblpkname": "state_name","placeholder": "Company name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `company_emailid` varchar(100) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Email ","drptblpkname": "state_name","placeholder": "Email name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `city_id` varchar(50) NOT NULL COMMENT '{"validation": "yes","group": "","controltype": "drp","formcontrolname": "","ngmodel": "","errorstring": "city ","drptblpkname": "city_name","placeholder": "city name","options": "drpcityoptions","drpptblname": "tbl_city_master","drptblpk": "city_id","drptblwhere": "state_id"}',
  `company_address` longtext COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Address ","drptblpkname": "state_name","placeholder": "Address name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `company_phonenos` varchar(500) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Phone nos. ","drptblpkname": "state_name","placeholder": "Phone nos. name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `company_landline` varchar(100) DEFAULT NULL COMMENT '{"validation": "no","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Landline nos. ","drptblpkname": "state_name","placeholder": "Landline nos. name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `company_regno` varchar(100) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Reg No. ","drptblpkname": "state_name","placeholder": "Reg No. name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_country_master` */

CREATE TABLE `tbl_country_master` (
  `country_id` varchar(50) NOT NULL COMMENT '{\n"mailtable":"",\n"pkprefix":"COU",\n"pkid":"countryr_id",\n"tsname":"country","formmodelname":"tbl_country_master",\n"subtables":\n[]\n\n}',
  `country_name` varchar(1000) DEFAULT NULL COMMENT '{"validation":"yes","group":"","controltype":"txt","formcontrolname":"","ngmodel":"","errorstring":"Country ","placeholder":"Country name","options":"mycustomoption","drpptblname":"","drptblpk":"","drptblwhere":""}',
  `country_aliasname` varchar(100) DEFAULT NULL COMMENT '{"validation":"yes","group":"","controltype":"txt","formcontrolname":"","ngmodel":"","errorstring":"Country Alias ","placeholder":"Country Alias name","options":"mycustomoption","drpptblname":"","drptblpk":"","drptblwhere":""}',
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`country_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_currency_master` */

CREATE TABLE `tbl_currency_master` (
  `currency_id` varchar(50) NOT NULL COMMENT '{"mailtable":"","pkprefix":"CURR","pkid":"currency_id","tsname":"currency","formmodelname":"currency","subtables":[]}',
  `currency_name` varchar(500) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Currency ","drptblpkname": "state_name","placeholder": "Currency Name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `currency_alias` varchar(100) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Currency Alias Name ","drptblpkname": "state_name","placeholder": "Currency Alias Name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`currency_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_currencyconversion_master` */

CREATE TABLE `tbl_currencyconversion_master` (
  `currconversion_id` varchar(50) NOT NULL COMMENT '{"mailtable":"","pkprefix":"CUCR","pkid":"currconversion_id","tsname":"currencyconversion","formmodelname":"currencyconversion","subtables":[]}',
  `currconversion_name` varchar(100) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Currency Conversion ","drptblpkname": "state_name","placeholder": "Currency Conversion Name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `currency_id` varchar(50) NOT NULL COMMENT '{"validation": "yes","group": "","controltype": "drp","formcontrolname": "","ngmodel": "","errorstring": "Base Currency ","drptblpkname": "currency_id","placeholder": "Currency Alias Name","options": "drpstateoptions","drpptblname": "tbl_currency_master","drptblpk": "currency_id","drptblwhere": ""}',
  `currency_id_to` varchar(50) NOT NULL COMMENT '{"validation": "yes","group": "","controltype": "drp","formcontrolname": "","ngmodel": "","errorstring": " ","drptblpkname": "currency_id","placeholder": "Currency Alias Name","options": "drpstateoptions","drpptblname": "tbl_currency_master","drptblpk": "currency_id","drptblwhere": ""}',
  `currconversion_rate` decimal(10,0) NOT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Currency Conversion ","drptblpkname": "state_name","placeholder": "Currency Conversion Name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  PRIMARY KEY (`currconversion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_education_master` */

CREATE TABLE `tbl_education_master` (
  `education_id` varchar(50) NOT NULL COMMENT '{"mailtable":"","pkprefix":"EDU","pkid":"education_id","tsname":"education","formmodelname":"education","subtables":[]}',
  `education_name` varchar(500) NOT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Education ","drptblpkname": "state_name","placeholder": "Education Name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `education_alias` varchar(100) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Education Alias Name ","drptblpkname": "state_name","placeholder": "Education Alias Name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`education_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_experience_master` */

CREATE TABLE `tbl_experience_master` (
  `experience_id` varchar(50) NOT NULL,
  `experience_name` varchar(500) DEFAULT NULL,
  `experience_alias` varchar(100) DEFAULT NULL,
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`experience_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_keyword_subcat` */

CREATE TABLE `tbl_keyword_subcat` (
  `keysubcat_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `keysubcat_name` varchar(500) NOT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Keyword ","drptblpkname": "state_name","placeholder": "Keyword","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `keysubcat_searchtext` varchar(100) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Search Text ","drptblpkname": "state_name","placeholder": "Search Text","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `subcat_id` varchar(50) NOT NULL,
  PRIMARY KEY (`keysubcat_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_language_master` */

CREATE TABLE `tbl_language_master` (
  `language_id` varchar(50) NOT NULL COMMENT '{"mailtable":"","pkprefix":"LANG","pkid":"language_id","tsname":"language","formmodelname":"language","subtables":[]}',
  `language_name` varchar(500) NOT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Language ","drptblpkname": "state_name","placeholder": "Language Name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `language_alias` varchar(100) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Language Alias Name ","drptblpkname": "state_name","placeholder": "Language Alias Name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`language_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_maincat_master` */

CREATE TABLE `tbl_maincat_master` (
  `maincat_id` varchar(50) NOT NULL COMMENT '{"mailtable":"","pkprefix":"MCAT","pkid":"maincat_id","tsname":"maincat","formmodelname":"maincat","subtables":[]}',
  `maincat_name` varchar(500) NOT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "maincat ","drptblpkname": "state_name","placeholder": "maincat name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `maincat_aliasname` varchar(100) DEFAULT NULL COMMENT '{"validation": "no","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "maincat alias name","drptblpkname": "state_name","placeholder": "maincat alias name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`maincat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_member_master` */

CREATE TABLE `tbl_member_master` (
  `member_id` varchar(50) NOT NULL,
  `member_name` varchar(100) DEFAULT NULL COMMENT '{"validation":"yes","group":"","controltype":"txt","formcontrolname":"","ngmodel":"","errorstring":"Member Name","placeholder":"Member Name","options":"mycustomoption"}',
  `member_type` varchar(50) DEFAULT NULL COMMENT '{"validation":"yes","group":"","controltype":"drp","formcontrolname":"drpmembertype","ngmodel":"","errorstring":"Member Type","placeholder":"Member Type","options":"drpmembertypeoptions"}',
  `member_contactnos` varchar(100) DEFAULT NULL COMMENT '{"validation":"yes","group":"","controltype":"txt","formcontrolname":"","ngmodel":"","errorstring":"Contact Nos.","placeholder":"Contact Nos.","options":"mycustomoption"}',
  `member_emailid` varchar(100) DEFAULT NULL COMMENT '{"validation":"yes","group":"","controltype":"txt","formcontrolname":"","ngmodel":"","errorstring":"Email","placeholder":"Email","options":"mycustomoption"}',
  `member_address` varchar(1000) DEFAULT NULL COMMENT '{"validation":"yes","group":"","controltype":"txtA","formcontrolname":"","ngmodel":"","errorstring":"Address","placeholder":"Address","options":"mycustomoption"}',
  `comp_id` varchar(50) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL COMMENT '{"validation":"yes","group":"","controltype":"txt","formcontrolname":"","ngmodel":"","errorstring":"Password","placeholder":"Password","options":"mycustomoption"}',
  `username` varchar(255) DEFAULT NULL COMMENT '{"validation":"yes","group":"","controltype":"txt","formcontrolname":"","ngmodel":"","errorstring":"User Name","placeholder":"User Name","options":"mycustomoption"}',
  PRIMARY KEY (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_membersecurity_answer` */

CREATE TABLE `tbl_membersecurity_answer` (
  `memsecurity_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `securityquest_id` varchar(50) DEFAULT NULL,
  `ofcmembers_id` varchar(50) DEFAULT NULL,
  `memsecurity_answer` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`memsecurity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_membershiptype_master` */

CREATE TABLE `tbl_membershiptype_master` (
  `membershiptype_id` varchar(50) NOT NULL COMMENT '{"mailtable":"","pkprefix":"MEMT","pkid":"membershiptype_id","tsname":"membershiptype","formmodelname":"membershiptype","subtables":[]}',
  `membershiptype_name` varchar(500) NOT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Membership Type ","drptblpkname": "state_name","placeholder": "Membership Type Name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `membershiptype_alias` varchar(100) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Membership Type Alias Name ","drptblpkname": "state_name","placeholder": "Membership Type Alias Name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `membershiptype_coinspoints` int(11) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Membership Coins ","drptblpkname": "state_name","placeholder": "Membership Coins","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`membershiptype_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_ofcmembercertificate_details` */

CREATE TABLE `tbl_ofcmembercertificate_details` (
  `ofcmembercertificate_id` varchar(50) NOT NULL,
  `certificate_id` varchar(50) DEFAULT NULL,
  `ofcmembers_id` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ofcmembercertificate_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_ofcmembereducation_details` */

CREATE TABLE `tbl_ofcmembereducation_details` (
  `ofcmembereducation_id` varchar(50) NOT NULL,
  `ofcmembers_id` varchar(50) DEFAULT NULL,
  `education_id` varchar(50) DEFAULT NULL,
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ofcmembereducation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_ofcmemberemployment_details` */

CREATE TABLE `tbl_ofcmemberemployment_details` (
  `ofcmememployment_id` varchar(50) NOT NULL,
  `ofcmembers_id` varchar(50) DEFAULT NULL,
  `maincat_id` varchar(50) DEFAULT NULL,
  `ofcmememployment_name` varchar(500) DEFAULT NULL,
  `ofcmememployment_description` longtext,
  `ofcmememployment_role` varchar(500) DEFAULT NULL,
  `ofcmememployment_startdate` datetime DEFAULT NULL,
  `ofcmememployment_enddate` datetime DEFAULT NULL,
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ofcmememployment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_ofcmemberemploymentskill_details` */

CREATE TABLE `tbl_ofcmemberemploymentskill_details` (
  `ofcmememploymentskill_id` varchar(50) NOT NULL,
  `ofcmememployment_id` varchar(50) NOT NULL,
  `skill_id` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ofcmememploymentskill_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_ofcmemberexperience_details` */

CREATE TABLE `tbl_ofcmemberexperience_details` (
  `ofcmemexperience_id` varchar(50) NOT NULL,
  `ofcmembers_id` varchar(50) DEFAULT NULL,
  `maincat_id` varchar(50) DEFAULT NULL,
  `ofcmemexperience_name` varchar(500) DEFAULT NULL,
  `ofcmemexperience_description` longtext,
  `ofcmemexperience_role` varchar(500) DEFAULT NULL,
  `ofcmemexperience_startdate` datetime DEFAULT NULL,
  `ofcmemexperience_enddate` datetime DEFAULT NULL,
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ofcmemexperience_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_ofcmemberexperienceskill_details` */

CREATE TABLE `tbl_ofcmemberexperienceskill_details` (
  `ofcmemexperienceskill_id` varchar(50) NOT NULL,
  `ofcmemexperience_id` varchar(50) NOT NULL,
  `skill_id` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ofcmemexperienceskill_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_ofcmembermyproject_details` */

CREATE TABLE `tbl_ofcmembermyproject_details` (
  `ofcmemmyproject_id` varchar(50) NOT NULL,
  `maincat_id` varchar(50) NOT NULL,
  `ofcmembers_id` varchar(50) NOT NULL,
  `ofcmemmyproject_title` varchar(500) DEFAULT NULL,
  `ofcmemmyproject_url` longtext,
  `ofcmemmyproject_description` longtext,
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ofcmemmyproject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_ofcmemberprojectskill_details` */

CREATE TABLE `tbl_ofcmemberprojectskill_details` (
  `ofcmemprojectskill_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ofcmemmyproject_id` varchar(50) NOT NULL,
  `skill_id` varchar(50) NOT NULL,
  PRIMARY KEY (`ofcmemprojectskill_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_ofcmembers_master` */

CREATE TABLE `tbl_ofcmembers_master` (
  `ofcmembers_id` varchar(50) NOT NULL,
  `ofcmembers_fname` varchar(500) DEFAULT NULL,
  `ofcmembers_mname` varchar(500) DEFAULT NULL,
  `ofcmembers_lname` varchar(500) DEFAULT NULL,
  `ofcmembers_name` varchar(1000) DEFAULT NULL,
  `ofcmember_type` varchar(50) DEFAULT 'company/individual',
  `city_id` varchar(50) DEFAULT NULL,
  `ofcmembers_emailid` varchar(500) DEFAULT NULL,
  `ofcmembers_password` varchar(500) DEFAULT NULL,
  `ofcmembers_address1` varchar(1000) DEFAULT NULL,
  `ofcmembers_address2` varchar(1000) DEFAULT NULL,
  `ofcmembers_pincode` varchar(500) DEFAULT NULL,
  `ofcmembers_contactnos` varchar(500) DEFAULT NULL,
  `ofcmembers_availability` varchar(50) DEFAULT NULL,
  `ofcmembers_displayname` varchar(500) DEFAULT NULL,
  `ofcmembers_description` longtext,
  `ofcmembers_selfrating` int(11) DEFAULT NULL,
  `ofcmembers_experiencelevel` varchar(50) DEFAULT NULL,
  `ofcmembers_gender` varchar(50) DEFAULT NULL,
  `ofcmembers_dob` datetime DEFAULT NULL,
  `ofcmembers_nosofteammembers` int(11) DEFAULT NULL,
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ofcmembers_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_ofcmemberskill_details` */

CREATE TABLE `tbl_ofcmemberskill_details` (
  `ofcmemberskill_id` bigint(50) NOT NULL AUTO_INCREMENT,
  `skill_id` varchar(50) DEFAULT NULL,
  `ofcmembers_id` varchar(50) DEFAULT NULL,
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ofcmemberskill_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_ofcmemsession_details` */

CREATE TABLE `tbl_ofcmemsession_details` (
  `ofcmemsession_id` varchar(50) NOT NULL,
  `ofcmembers_id` varchar(50) DEFAULT NULL,
  `ofcmemsession_deviceid` longtext,
  `ofcmemsession_devicetype` varchar(50) DEFAULT NULL,
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ofcmemsession_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_ofcprojectpost_details` */

CREATE TABLE `tbl_ofcprojectpost_details` (
  `ofcprojectpost_id` varchar(50) NOT NULL,
  `ofcmembers_id` varchar(50) NOT NULL,
  `subcat_id` varchar(50) NOT NULL,
  `experience_id` varchar(50) NOT NULL,
  `ofcprojectpost_budget` varchar(50) DEFAULT 'sure',
  `ofcprojectpost_negotiable` varchar(50) DEFAULT 'yes',
  `ofcprojectpost_title` varchar(500) DEFAULT NULL,
  `ofcprojectpost_description` longtext,
  `ofcprojectpost_timeframe` varchar(100) DEFAULT '6months',
  `ofcprojectpost_typepreference` varchar(100) NOT NULL DEFAULT 'company/individual/any',
  `ofcprojectpost_kind` varchar(100) DEFAULT 'onging/onetime/notsure',
  `ofcprojectpost_budgetamount` decimal(10,0) DEFAULT NULL,
  `ofcprojectpost_commissionpercentage` decimal(10,0) DEFAULT NULL,
  `ofcprojectpost_ofccommission` decimal(10,0) DEFAULT NULL COMMENT 'will be calcuated in background',
  `ofcprojectpost_estimatestartdate` datetime DEFAULT NULL,
  `ofcprojectpost_startdate` datetime DEFAULT NULL,
  `ofcprojectpost_enddate` datetime DEFAULT NULL,
  `ofcprojectpost_invitefreelancers` varchar(50) DEFAULT 'yes',
  `ofcprojectpost_public` varchar(50) DEFAULT 'yes',
  `country_id` varchar(50) DEFAULT NULL COMMENT 'target country id',
  `language_id` varchar(50) DEFAULT NULL,
  `ofcprojectpost_projectamount` decimal(10,0) DEFAULT NULL COMMENT 'project amount',
  `ofcprojectpost_advanceamount` decimal(10,0) DEFAULT NULL,
  `ofcprojectpost_finalpaidamount` decimal(10,0) DEFAULT NULL,
  `ofcprojectpost_ispaymenttermsagreed` varchar(50) DEFAULT 'no',
  `ofcprojectpost_ispaid` varchar(50) DEFAULT 'no',
  `ofcprojectpost_iscompleted` varchar(50) DEFAULT 'no',
  `ofcprojectpost_delayed` varchar(50) DEFAULT 'no',
  `ofcprojectpost_istermsaggreedbyme` varchar(50) DEFAULT 'no',
  `ofcprojectpost_istermsaggreedbyfreelancer` varchar(50) DEFAULT 'no',
  `ofcprojectpost_isdispute` varchar(50) DEFAULT 'no',
  `ofcprojectpost_isrefundrequested` varchar(50) DEFAULT 'no',
  `ofcprojectpost_isrefunded` varchar(50) DEFAULT 'no',
  `ofcprojectpost_isdisputeresolved` varchar(50) DEFAULT 'no',
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT 'active',
  PRIMARY KEY (`ofcprojectpost_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_ofcprojectpost_keywords` */

CREATE TABLE `tbl_ofcprojectpost_keywords` (
  `ofcprojectpostkeywords_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ofcprojectpost_id` varchar(50) NOT NULL,
  `keywords_id` varchar(50) NOT NULL,
  PRIMARY KEY (`ofcprojectpostkeywords_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_ofcprojectpost_questions` */

CREATE TABLE `tbl_ofcprojectpost_questions` (
  `projectpostquestions_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ofcprojectpost_id` varchar(50) DEFAULT NULL,
  `projectpostquestions_name` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`projectpostquestions_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_ofcprojectpost_skill` */

CREATE TABLE `tbl_ofcprojectpost_skill` (
  `ofcprojectpostskill_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ofcprojectpost_id` varchar(50) NOT NULL,
  `skill_id` varchar(50) NOT NULL,
  PRIMARY KEY (`ofcprojectpostskill_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_plan_master` */

CREATE TABLE `tbl_plan_master` (
  `plan_id` varchar(50) NOT NULL COMMENT '{"mailtable":"","pkprefix":"PLAN","pkid":"plan_id","tsname":"plan","formmodelname":"plan","subtables":[]}',
  `plan_name` varchar(500) NOT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Plan Person Name","drptblpkname": "state_name","placeholder": "Plan Person name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `plan_bidsnos` int(11) NOT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Plan Bid Nos.","drptblpkname": "state_name","placeholder": "Plan Descrpiption","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `plan_feespercentage` decimal(10,0) NOT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Plan Fees %","drptblpkname": "state_name","placeholder": "Plan Fees %","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `plan_nosofcategories` int(11) NOT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Plan Browse Nos of categories","drptblpkname": "state_name","placeholder": "Plan Browse Nos of categories","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_popularsearch_homepage` */

CREATE TABLE `tbl_popularsearch_homepage` (
  `popularsearch_id` varchar(50) NOT NULL COMMENT '{"mailtable":"","pkprefix":"POPS","pkid":"popularsearch_id","tsname":"popularsearch","formmodelname":"popularsearch","subtables":[]}',
  `popularsearch_srno` int(11) NOT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Popular Search ","drptblpkname": "state_name","placeholder": "Popular Search name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `maincat_id` varchar(50) NOT NULL COMMENT '{"validation": "yes", "group": "", "controltype": "drp", "formcontrolname": "", "ngmodel": "", "errorstring": "Main Category ",  "drptblpkname": "maincat_name",  "placeholder": "Sub Category Alias Name",  "options": "drpmaincatoptions",  "drpptblname": "tbl_maincat_master",  "drptblpk": "maincat_id",  "drptblwhere": ""}',
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`popularsearch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_pricerange_master` */

CREATE TABLE `tbl_pricerange_master` (
  `pricerange_id` varchar(50) NOT NULL COMMENT '{"mailtable":"","pkprefix":"PRIR","pkid":"pricerange_id","tsname":"pricerange","formmodelname":"pricerange","subtables":[]}',
  `pricerange_name` varchar(500) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Price Range ","drptblpkname": "state_name","placeholder": "Price Range Name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `pricerange_alias` varchar(100) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Price Range Alias","drptblpkname": "state_name","placeholder": "Price Range Alias Name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `pricerange_from` decimal(10,0) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Price Range From","drptblpkname": "state_name","placeholder": "Price Range From ","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `pricerange_to` decimal(10,0) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Price Range To","drptblpkname": "state_name","placeholder": "Price Range To ","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`pricerange_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_running_master` */

CREATE TABLE `tbl_running_master` (
  `running_id` varchar(50) NOT NULL,
  `running_name` varchar(50) DEFAULT NULL,
  `running_prefix` varchar(50) DEFAULT NULL,
  `running_number` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`running_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_securityquestion_master` */

CREATE TABLE `tbl_securityquestion_master` (
  `securityquest_id` varchar(50) NOT NULL COMMENT '{"mailtable":"","pkprefix":"SECQ","pkid":"securityquestion_id","tsname":"securityquestion","formmodelname":"securityquestion","subtables":[]}',
  `securityquest_name` varchar(1000) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Security Question ","drptblpkname": "state_name","placeholder": "Security Question Name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `securityquest_alias` varchar(500) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Security Question Alias Name ","drptblpkname": "state_name","placeholder": "Security Question Alias Name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`securityquest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_skill_master` */

CREATE TABLE `tbl_skill_master` (
  `skill_id` varchar(50) NOT NULL COMMENT '{"mailtable":"","pkprefix":"SKIL","pkid":"skill_id","tsname":"skill","formmodelname":"skill","subtables":[]}',
  `skill_name` varchar(500) NOT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Skill ","drptblpkname": "state_name","placeholder": "Skill Name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}\r\n',
  `skill_alias` varchar(100) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Skill Alias Name ","drptblpkname": "state_name","placeholder": "Skill Alias Name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}\r\n',
  `subcat_id` varchar(50) DEFAULT NULL COMMENT '{"validation": "yes", "group": "", "controltype": "drp", "formcontrolname": "", "ngmodel": "", "errorstring": "Sub Category Alias Name ",  "drptblpkname": "subcat_name",  "placeholder": "Sub Category Alias Name",  "options": "drpsubcatoptions",  "drpptblname": "tbl_subcat_master",  "drptblpk": "subcat_id",  "drptblwhere": ""}',
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`skill_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_state_master` */

CREATE TABLE `tbl_state_master` (
  `state_id` varchar(50) NOT NULL COMMENT '{\n"mailtable":"",\n"pkprefix":"STA",\n"pkid":"state_id",\n"tsname":"state","formmodelname":"state",\n"subtables":\n[]\n\n}',
  `state_name` varchar(1000) DEFAULT NULL COMMENT '{"validation":"yes","group":"","controltype":"txt","formcontrolname":"","ngmodel":"","errorstring":"State ","placeholder":"State name","options":"mycustomoption","drpptblname":"","drptblpk":"","drptblwhere":""}',
  `state_aliasname` varchar(100) DEFAULT NULL COMMENT '{"validation":"yes","group":"","controltype":"txt","formcontrolname":"","ngmodel":"","errorstring":"State Alias ","placeholder":"State Alias name","options":"mycustomoption","drpptblname":"","drptblpk":"","drptblwhere":""}',
  `country_id` varchar(50) DEFAULT NULL COMMENT '{"validation":"yes","group":"","controltype":"drp","formcontrolname":"","ngmodel":"","errorstring":"Country ","drptblpkname":"country_name","placeholder":"Country name","options":"drpcountryoptions","drpptblname":"tbl_country_master","drptblpk":"country_id","drptblwhere":""}',
  PRIMARY KEY (`state_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_subcat_master` */

CREATE TABLE `tbl_subcat_master` (
  `subcat_id` varchar(50) NOT NULL COMMENT '{"mailtable":"","pkprefix":"SCAT","pkid":"subcat_id","tsname":"subcat","formmodelname":"subcat","subtables":[{"tblname":"tbl_keyword_subcat","tsname":"keysubcat"}]}',
  `subcat_name` varchar(500) NOT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Sub Category ","drptblpkname": "state_name","placeholder": "Sub Category name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `subcat_aliasname` varchar(100) DEFAULT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Sub Category Alias Name ","drptblpkname": "state_name","placeholder": "Sub Category Alias Name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `maincat_id` varchar(50) NOT NULL COMMENT '{"validation": "yes", "group": "", "controltype": "drp", "formcontrolname": "", "ngmodel": "", "errorstring": "Sub Category Alias Name ",  "drptblpkname": "maincat_name",  "placeholder": "Sub Category Alias Name",  "options": "drpmaincatoptions",  "drpptblname": "tbl_maincat_master",  "drptblpk": "maincat_id",  "drptblwhere": ""}',
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`subcat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_testimonial_master` */

CREATE TABLE `tbl_testimonial_master` (
  `testimonial_id` varchar(50) NOT NULL COMMENT '{"mailtable":"","pkprefix":"TEST","pkid":"testimonial_id","tsname":"testimonial","formmodelname":"testimonial","subtables":[]}',
  `testimonial_name` varchar(500) NOT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Testimonial Person Name","drptblpkname": "state_name","placeholder": "Testimonial Person name","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `testimonial_description` longtext NOT NULL COMMENT '{"validation": "yes","group": "","controltype": "txt","formcontrolname": "","ngmodel": "","errorstring": "Testimonial Descrpiption","drptblpkname": "state_name","placeholder": "Testimonial Descrpiption","options": "drpstateoptions","drpptblname": "tbl_state_master","drptblpk": "state_id","drptblwhere": "country_id"}',
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`testimonial_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_uploadedfile_master` */

CREATE TABLE `tbl_uploadedfile_master` (
  `uploadfile_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uploadfile_tblname` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `uploadfile_actulalfilename` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `uploadfile_filename` varchar(1000) COLLATE utf8_bin DEFAULT NULL,
  `uploadfile_type` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `uploadfile_path` longtext COLLATE utf8_bin,
  `uploadfile_status` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `uploadfile_tblpkid` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`uploadfile_id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
