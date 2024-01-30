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
/*Table structure for table `tbl_ofcsubmitproposal_chat` */

DROP TABLE IF EXISTS `tbl_ofcsubmitproposal_chat`;

CREATE TABLE `tbl_ofcsubmitproposal_chat` (
  `ofcsubmitproposalchat_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ofcsubmitproposal_id_fkchat` varchar(50) NOT NULL,
  `ofcmembers_id_fkchatemployeer` varchar(50) NOT NULL,
  `ofcmembers_id_fkchatemployee` varchar(50) NOT NULL,
  `ofcsubmitproposalchat_message` longtext NOT NULL,
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) NOT NULL DEFAULT 'active',
  PRIMARY KEY (`ofcsubmitproposalchat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_ofcsubmitproposal_details` */

DROP TABLE IF EXISTS `tbl_ofcsubmitproposal_details`;

CREATE TABLE `tbl_ofcsubmitproposal_details` (
  `ofcsubmitproposal_id` varchar(50) NOT NULL,
  `ofcprojectpost_id_fksubmitproposal` varchar(50) DEFAULT NULL,
  `ofcmembers_id_fksubmitproposal` varchar(50) DEFAULT NULL,
  `ofcsubmitproposal_coverletter` longtext,
  `ofcsubmitproposal_budget` decimal(10,0) DEFAULT NULL,
  `ofcsubmitproposal_negotiable` varchar(50) DEFAULT 'yes',
  `ofcsubmitproposal_commissionpercentage` decimal(10,0) DEFAULT NULL,
  `ofcsubmitproposal_commissionamount` decimal(10,0) DEFAULT NULL,
  `ofcsubmitproposal_finalamount` decimal(10,0) DEFAULT NULL,
  `ofcsubmitproposal_timeframe` varchar(50) DEFAULT NULL,
  `ofcsubmitproposal_availability` varchar(100) DEFAULT NULL,
  `ofcsubmitproposal_status` varchar(100) DEFAULT 'accepted/rejected/shortlisted',
  `ofcsubmitproposal_remarks` longtext,
  `ofcsubmitproposal_terms` longtext,
  `ofcsubmitproposal_estimatestartdate` datetime DEFAULT NULL,
  `ofcsubmitproposal_startdate` datetime DEFAULT NULL,
  `ofcsubmitproposal_enddate` datetime DEFAULT NULL,
  `ofcsubmitproposal_estimatedays` int(11) DEFAULT NULL,
  `ofcsubmitproposal_estimatedhoursindays` decimal(10,0) DEFAULT NULL,
  `ofcsubmitproposal_reportabusebyemployeer` varchar(50) DEFAULT 'no',
  `ofcsubmitproposal_reportabusebyfreelancer` varchar(50) DEFAULT 'no',
  `ofcsubmitproposal_proposalacceptdate` datetime DEFAULT NULL,
  `ofcsubmitproposal_proposalrejectdate` datetime DEFAULT NULL,
  `ofcsubmitproposal_completeddate` datetime DEFAULT NULL,
  `ofcsubmitproposal_iscompletedbyemployeer` varchar(50) DEFAULT 'no',
  `ofcsubmitproposal_iscompletedbyfreelancer` varchar(50) DEFAULT 'no',
  `ofcsubmitproposal_workstatus` varchar(500) DEFAULT 'inprogress/interrupted/waitingforemployeersreply/completed',
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT 'active',
  PRIMARY KEY (`ofcsubmitproposal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_ofcsubmitproposal_questionanswers` */

DROP TABLE IF EXISTS `tbl_ofcsubmitproposal_questionanswers`;

CREATE TABLE `tbl_ofcsubmitproposal_questionanswers` (
  `ofcsubmitproposalquest_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ofcsubmitproposal_id_ofcsubmitproposalquest` varchar(50) DEFAULT NULL,
  `ofcsubmitproposalquest_question` varchar(500) DEFAULT NULL,
  `ofcsubmitproposalquest_answer` longtext,
  PRIMARY KEY (`ofcsubmitproposalquest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tbl_ofcsubmitproposal_terms` */

DROP TABLE IF EXISTS `tbl_ofcsubmitproposal_terms`;

CREATE TABLE `tbl_ofcsubmitproposal_terms` (
  `ofcsubmitproposalterms_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ofcsubmitproposal_id_fkterms` varchar(50) NOT NULL,
  `ofcsubmitproposalterms_terms` longtext,
  `ofcsubmitproposalterms_agreedbyemployer` varchar(50) DEFAULT 'no',
  `ofcsubmitproposalterms_agreedbyemployee` varchar(50) DEFAULT 'no',
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) DEFAULT 'active',
  PRIMARY KEY (`ofcsubmitproposalterms_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
