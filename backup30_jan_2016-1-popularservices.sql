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
/*Table structure for table `tbl_savedprojects_details` */

DROP TABLE IF EXISTS `tbl_savedprojects_details`;

CREATE TABLE `tbl_savedprojects_details` (
  `savedprojects_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ofcprojectpost_id_fksavedprojects` varchar(50) NOT NULL,
  `ofcmembers_id_fksavedprojects` varchar(50) NOT NULL,
  PRIMARY KEY (`savedprojects_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* Procedure structure for procedure `proc_member_ofcprojectsavefavourite` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_member_ofcprojectsavefavourite` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_member_ofcprojectsavefavourite`(
    IN membersessionid VARCHAR(100),
    IN projectpostid varchar(100), -- tbl_ofcmembers_master
    OUT outparam json
    )
label1:
BEGIN
   
   
   
    DECLARE errcount INT;
    DECLARE errno INT;
    DECLARE msg TEXT;
    DECLARE p TEXT;
       
    DECLARE Isuccess BOOLEAN;
    DECLARE outparam1 json;
    DECLARE  Validation TEXT;
    DECLARE Error TEXT;
    DECLARE Controlid TEXT;
   
   
   
   
   
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
        SET Isuccess =FALSE;
   
    SET  Validation ='';
    SET Error ='';
    SET Controlid ='';
        SET Error = 'SQL Exception';
       
       
       
       
        GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
        GET CURRENT DIAGNOSTICS errcount = NUMBER;
        IF errcount = 0
        THEN
            SELECT '1mapped insert succeeded, current DA is empty' AS op;
            SET Error = 'mapped insert succeeded, current DA is empty' ;
        ELSE
           
            GET CURRENT DIAGNOSTICS CONDITION 1
            errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
            -- SELECT '2stacked DA after mapped insert' AS op, errno, msg;
           
        END IF ;
        GET STACKED DIAGNOSTICS CONDITION 1
        errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
        -- SELECT '3stacked DA after mapped insert' AS op, errno, msg;
        SET Error = CONCAT("ERROR ", errno, " : ", msg);
        SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
            'Error', Error,
            'Validation', Validation,
            'Controlid', Controlid));
       
         ROLLBACK;
    END;
   
   
    -- SET GLOBAL tx_isolation = 'READ-COMMITTED';
    -- SET tx_isolation = 'READ-COMMITTED';
    -- SET GLOBAL innodb_lock_wait_timeout = 40000;
    SET SESSION group_concat_max_len=10000000000000;
     START TRANSACTION;
     SET Isuccess =FALSE;
   
    SET  Validation ='';
    SET Error ='';
    SET Controlid ='';
    SET @truesession = FALSE;
    SET @outparam1 = '';
   
    CALL proc_membersession_validate(membersessionid,@truesession);
   
    IF @truesession THEN
        -- SET istrue=TRUE;
         
         SET @memid = (SELECT ofcmembers_id FROM tbl_ofcmemsession_details WHERE ofcmemsession_id=membersessionid);
         -- SET @memid = (SELECT ofcmembers_id FROM tbl_ofcmembers_master WHERE ofcmembers_id=@memid AND ofcmembers_password=oldpassword);
         IF @memid IS NULL AND @memid = '' THEN
            SET Error = 'Invalid current session..!';
            SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
            'Error', Error,
            'Validation', Validation,
            'Controlid', Controlid));
            LEAVE label1;
         ELSE
		insert into tbl_savedprojects_details
		(ofcprojectpost_id_fksavedprojects,ofcmembers_id_fksavedprojects)
		values(projectpostid,
		@memid);
         
		
           
           
         END IF;
         
    END IF;
    IF (@truesession = FALSE) THEN
   
        SET Error = 'Invalid session. Please login again...!';
        SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
            'Error', Error,
            'Validation', Validation,
            'Controlid', Controlid));
           
        LEAVE label1;
   
    END IF;
   
     COMMIT;
     SET Isuccess = TRUE;
     SET Error = 'Project Saved Successfully..!';
     SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
         'Error', Error,
         'Validation', Validation,
       'Controlid', Controlid));
    END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
