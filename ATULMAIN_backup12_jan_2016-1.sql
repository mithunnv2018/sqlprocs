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
/*Table structure for table `tbl_membersecurity_answer` */

CREATE TABLE `tbl_membersecurity_answer` (
  `memsecurity_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `securityquest_id` varchar(50) DEFAULT NULL,
  `ofcmembers_id` varchar(50) DEFAULT NULL,
  `memsecurity_answer` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`memsecurity_id`)
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

/*Table structure for table `tbl_ofcmemberskill_details` */

CREATE TABLE `tbl_ofcmemberskill_details` (
  `ofcmemberskill_id` varchar(50) NOT NULL,
  `skill_id` varchar(50) DEFAULT NULL,
  `ofcmembers_id` varchar(50) DEFAULT NULL,
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ofcmemberskill_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
