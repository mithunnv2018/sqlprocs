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
  `ofcmembers_id_fkchatemployee` varchar(50) DEFAULT NULL,
  `ofcsubmitproposalchat_message` longtext NOT NULL,
  `createdate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `status` varchar(10) NOT NULL DEFAULT 'active',
  PRIMARY KEY (`ofcsubmitproposalchat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
