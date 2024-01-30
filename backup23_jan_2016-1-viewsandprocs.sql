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
/* Procedure structure for procedure `proc_common_auto_create` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_common_auto_create` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_common_auto_create`(in subtables json, in procname varchar(1000),in tblname varchar(100),
IN pkname VARCHAR(100),IN pkprefix VARCHAR(100))
BEGIN
	declare procconcat text;
	declare subtableconcat text;
	DECLARE subtableparamname TEXT;
	DECLARE subtableparamconcat TEXT;
	
	
	set subtableconcat = '';
	set subtableparamname = '';
	set subtableparamconcat = '';
	SET @countpk = JSON_LENGTH(JSON_EXTRACT(subtables , '$[0].subtables'));
	     SET @x1=0;
	     SELECT @outparam1 AS 'uploadfile param';
	     SELECT @x1 , @countpk;
	     if @countpk > 0 then
	     
	     set @subtablesarr = JSON_UNQUOTE(JSON_EXTRACT(subtables , '$[0].subtables'));
	     WHILE @x1  < @countpk DO
		set subtableparamname = concat ('subinput',@x1);
		set subtableparamconcat =concat(subtableparamconcat,' IN ',subtableparamname, ' json' ,',');
		set @subtblnametemp = JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(@subtablesarr , '$[*].tblname'),CONCAT('$[',@x1,']')));
		select @subtblnametemp;
		SET subtableconcat = concat(subtableconcat,'\n','call proc_common_sub_insert(',subtableparamname,',\'',@subtblnametemp,'\',\'',pkname,'\',JSON_UNQUOTE(JSON_EXTRACT(outparam , \'$[0].Idupdated\')),outparam);');
		set @x1 = @x1+1;
		end while;
		
	     end if;
	SET procconcat='';
	SET procconcat =CONCAT(procconcat,'DELIMITER $$\n', 'DROP PROCEDURE IF EXISTS `',procname,'`$$\n', 'CREATE DEFINER=`root`@`localhost` PROCEDURE `',procname,'`(');
	SET procconcat =CONCAT(procconcat,'IN inparam json,  ',subtableparamconcat ,'OUT result json,', 'OUT outparam json', ')\n', 'label1:\n', 'BEGIN\n ', 'DECLARE errcount INT;\n', 'DECLARE errno INT;\n', 'DECLARE msg TEXT;\n', 'DECLARE p TEXT;\n', 'DECLARE Isuccess BOOLEAN;\n', 'DECLARE outparam1 json;\n', 'DECLARE  Validation TEXT;\n', 'DECLARE Error TEXT;\n', 'DECLARE Controlid TEXT;\n', 'DECLARE EXIT HANDLER FOR SQLEXCEPTION\n ', 'BEGIN\n ', 'SET Isuccess =FALSE;\n', 'SET  Validation =\'\';\n', 'SET Error =\'\';\n', 'SET Controlid =\'\';', 'SET Error = \'SQL Exception\';\n', ' GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;\n');
	SET procconcat =CONCAT(procconcat, 'GET CURRENT DIAGNOSTICS errcount = NUMBER;\n', 'IF errcount = 0 ', ' THEN ', 'SELECT \'1mapped insert succeeded, current DA is empty\' AS op;\n', 'SET Error = \'mapped insert succeeded, current DA is empty\' ;\n', 'ELSE ', 'GET CURRENT DIAGNOSTICS CONDITION 1 ', 'errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;');
	SET procconcat =CONCAT(procconcat, 'END IF ;', 'GET STACKED DIAGNOSTICS CONDITION 1 ', 'errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;', 'SET Error = CONCAT("ERROR ", errno, " : ", msg);', 'SET outparam =  (SELECT JSON_OBJECT(\'Isuccess\', Isuccess, \'Error\', Error,\'Validation\', Validation,\'Controlid\', Controlid));');
	
	SET procconcat =CONCAT(procconcat,'ROLLBACK;', 'END;', 'START TRANSACTION;', 'SET Isuccess =FALSE;', 'SET  Validation =\'\';', 'SET Error =\'\';', 'SET Controlid =\'\';', 'CALL proc_common_insert(inparam,\'',tblname,'\',\'',pkname,'\',\'',pkprefix,'\',outparam);',subtableconcat);
	SET procconcat =CONCAT(procconcat,'COMMIT;', 'SET Isuccess = TRUE;', 'CALL proc_',tblname,'_selectjson(@result1,outparam);', 'SET result =@result1;', 'END$$', 'DELIMITER ;');
	
	select procconcat;
	
	  
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_common_auto_drpjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_common_auto_drpjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_common_auto_drpjson`(in inparam json)
BEGIN
	declare procconcat text;
	set procconcat ='';
	SET @procname ='';
	set @controltype = JSON_UNQUOTE(JSON_EXTRACT(inparam ,'$[0].controltype'));
	SET @drpptblname = JSON_UNQUOTE(JSON_EXTRACT(inparam ,'$[0].drpptblname'));
	SET @drptblpk = JSON_UNQUOTE(JSON_EXTRACT(inparam ,'$[0].drptblpk'));
	SET @drptblwhere = JSON_UNQUOTE(JSON_EXTRACT(inparam ,'$[0].drptblwhere'));
	set @drptblpkname = JSON_UNQUOTE(JSON_EXTRACT(inparam ,'$[0].drptblpkname'));
	
	set @drpwhereclause = '';
	set @procname = concat('proc_',@drpptblname,'_');
	set @procparams = '';
	
	set @drpproc = concat('CALL proc_common_drpjson(\'',@drptblpk,'\',\'',@drptblpkname,'\',','\'',@drpptblname,'');
	if @controltype = 'drp' then
		if @drptblwhere <> '' and @drptblwhere is not null then
			set @drpwhereclause = concat(',concat( \' ' ,@drptblwhere,'=\','''''''',',@drptblwhere,'_param,'''''''')' );
			set @procname = concat(@procname,@drptblwhere,'_');
			set @procparams = concat(@procparams,'IN ', @drptblwhere,'_param varchar(100),');
		else
			set @drpwhereclause = concat(@drpwhereclause,',\'\'');
		end if;
		SET @procname = CONCAT(@procname,'drpjson');
		
		set @drpproc = concat(@drpproc,'\'',@drpwhereclause,',','result);');
	
	SET procconcat =CONCAT(procconcat,'DELIMITER $$\n', 'DROP PROCEDURE IF EXISTS `',@procname,'`$$\n', 'CREATE DEFINER=`root`@`localhost` PROCEDURE `',@procname,'`(');
	SET procconcat =CONCAT(procconcat,@procparams  ,'OUT result json,', 'OUT outparam json', ')\n', 'label1:\n', 'BEGIN\n ', 'DECLARE errcount INT;\n', 'DECLARE errno INT;\n', 'DECLARE msg TEXT;\n', 'DECLARE p TEXT;\n', 'DECLARE Isuccess BOOLEAN;\n', 'DECLARE outparam1 json;\n', 'DECLARE  Validation TEXT;\n', 'DECLARE Error TEXT;\n', 'DECLARE Controlid TEXT;\n', 'DECLARE EXIT HANDLER FOR SQLEXCEPTION\n ', 'BEGIN\n ', 'SET Isuccess =FALSE;\n', 'SET  Validation =\'\';\n', 'SET Error =\'\';\n', 'SET Controlid =\'\';', 'SET Error = \'SQL Exception\';\n', ' GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;\n');
	SET procconcat =CONCAT(procconcat, 'GET CURRENT DIAGNOSTICS errcount = NUMBER;\n', 'IF errcount = 0 ', ' THEN ', 'SELECT \'1mapped insert succeeded, current DA is empty\' AS op;\n', 'SET Error = \'mapped insert succeeded, current DA is empty\' ;\n', 'ELSE ', 'GET CURRENT DIAGNOSTICS CONDITION 1 ', 'errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;');
	SET procconcat =CONCAT(procconcat, 'END IF ;', 'GET STACKED DIAGNOSTICS CONDITION 1 ', 'errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;', 'SET Error = CONCAT("ERROR ", errno, " : ", msg);', 'SET outparam =  (SELECT JSON_OBJECT(\'Isuccess\', Isuccess, \'Error\', Error,\'Validation\', Validation,\'Controlid\', Controlid));');
	
	SET procconcat =CONCAT(procconcat,'ROLLBACK;', 'END;', 'START TRANSACTION;', 'SET Isuccess =FALSE;', 'SET  Validation =\'\';', 'SET Error =\'\';', 'SET Controlid =\'\';', @drpproc);
	SET procconcat =CONCAT(procconcat,'COMMIT;', 'SET Isuccess = TRUE;', 'END$$', 'DELIMITER ;');
	END IF;
	select procconcat;
	if @drptblwhere = '' or @drptblwhere is null then
		CALL proc_common_ws (CONCAT('proc_',@drpptblname,'_drpjson'),CONCAT('WS_',@drpptblname,'_drpjson'),0);
	else
		CALL proc_common_ws (CONCAT('proc_',@drpptblname,'_',@drptblwhere,'_drpjson'),CONCAT('WS_',@drpptblname,'_',@drptblwhere,'_drpjson'),1);
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_common_auto_selectedit` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_common_auto_selectedit` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_common_auto_selectedit`(in procname varchar(1000),in tblname varchar(100),
IN pkname VARCHAR(100))
BEGIN
	declare procconcat text;
	
	
	
	
	
	SET procconcat='';
	SET procconcat =CONCAT(procconcat,'DELIMITER $$\n', 'DROP PROCEDURE IF EXISTS `',procname,'`$$\n', 'CREATE DEFINER=`root`@`localhost` PROCEDURE `',procname,'`(');
	SET procconcat =CONCAT(procconcat,'IN pkid varchar(1000),', 'OUT result json,', 'OUT outparam json', ')\n', 'label1:\n', 'BEGIN\n ', 'DECLARE errcount INT;\n', 'DECLARE errno INT;\n', 'DECLARE msg TEXT;\n', 'DECLARE p TEXT;\n', 'DECLARE Isuccess BOOLEAN;\n', 'DECLARE outparam1 json;\n', 'DECLARE  Validation TEXT;\n', 'DECLARE Error TEXT;\n', 'DECLARE Controlid TEXT;\n', 'DECLARE EXIT HANDLER FOR SQLEXCEPTION\n ', 'BEGIN\n ', 'SET Isuccess =FALSE;\n', 'SET  Validation =\'\';\n', 'SET Error =\'\';\n', 'SET Controlid =\'\';', 'SET Error = \'SQL Exception\';\n', ' GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;\n');
	SET procconcat =CONCAT(procconcat, 'GET CURRENT DIAGNOSTICS errcount = NUMBER;\n', 'IF errcount = 0 ', ' THEN ', 'SELECT \'1mapped insert succeeded, current DA is empty\' AS op;\n', 'SET Error = \'mapped insert succeeded, current DA is empty\' ;\n', 'ELSE ', 'GET CURRENT DIAGNOSTICS CONDITION 1 ', 'errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;');
	SET procconcat =CONCAT(procconcat, 'END IF ;', 'GET STACKED DIAGNOSTICS CONDITION 1 ', 'errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;', 'SET Error = CONCAT("ERROR ", errno, " : ", msg);', 'SET outparam =  (SELECT JSON_OBJECT(\'Isuccess\', Isuccess, \'Error\', Error,\'Validation\', Validation,\'Controlid\', Controlid));');
	
	SET procconcat =CONCAT(procconcat,'ROLLBACK;', 'END;', 'START TRANSACTION;', 'SET Isuccess =FALSE;', 'SET  Validation =\'\';', 'SET Error =\'\';', 'SET Controlid =\'\';', 'CALL proc_common_select_single_json(\'',tblname,'\',CONCAT(\'',pkname,'=\','''''''',pkid,''''''''),result);');
	SET procconcat =CONCAT(procconcat,'COMMIT;', 'SET Isuccess = TRUE;', 'set outparam=\'[]\';', '', 'END$$', 'DELIMITER ;');
	
	select procconcat;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_common_auto_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_common_auto_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_common_auto_selectjson`(in procname varchar(1000),in tblname varchar(100),
IN tblwhereclause VARCHAR(1000))
BEGIN
	declare procconcat text;
	
	declare pramname text;
	
	set pramname='';
	-- CALL proc_common_selectjson('vw_state_country_details','country_id=\'COU3\'',@result);
	
	if tblwhereclause <> '' then
		SET pramname = concat('IN ',tblwhereclause,'_param varchar(100),');
		set tblwhereclause = concat('concat(\'',tblwhereclause,'=\'',',\'\\\'\',',tblwhereclause,'_param,\'\\\'\'),');
	else
		set tblwhereclause = concat('\'\',');
	end if;
	-- concat('\'',tblwhereclause,'\'=',',',country_id_param)
	-- CALL proc_common_selectjson('vw_state_country_details',concat('country_id=',country_id_param),result);
	SET procconcat='';
	SET procconcat =CONCAT(procconcat,'DELIMITER $$\n', 'DROP PROCEDURE IF EXISTS `',procname,'`$$\n', 'CREATE DEFINER=`root`@`localhost` PROCEDURE `',procname,'`(');
	SET procconcat =CONCAT(procconcat,pramname, 'OUT result json,', 'OUT outparam json', ')\n', 'label1:\n', 'BEGIN\n ', 'DECLARE errcount INT;\n', 'DECLARE errno INT;\n', 'DECLARE msg TEXT;\n', 'DECLARE p TEXT;\n', 'DECLARE Isuccess BOOLEAN;\n', 'DECLARE outparam1 json;\n', 'DECLARE  Validation TEXT;\n', 'DECLARE Error TEXT;\n', 'DECLARE Controlid TEXT;\n', 'DECLARE EXIT HANDLER FOR SQLEXCEPTION\n ', 'BEGIN\n ', 'SET Isuccess =FALSE;\n', 'SET  Validation =\'\';\n', 'SET Error =\'\';\n', 'SET Controlid =\'\';', 'SET Error = \'SQL Exception\';\n', ' GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;\n');
	SET procconcat =CONCAT(procconcat, 'GET CURRENT DIAGNOSTICS errcount = NUMBER;\n', 'IF errcount = 0 ', ' THEN ', 'SELECT \'1mapped insert succeeded, current DA is empty\' AS op;\n', 'SET Error = \'mapped insert succeeded, current DA is empty\' ;\n', 'ELSE ', 'GET CURRENT DIAGNOSTICS CONDITION 1 ', 'errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;');
	SET procconcat =CONCAT(procconcat, 'END IF ;', 'GET STACKED DIAGNOSTICS CONDITION 1 ', 'errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;', 'SET Error = CONCAT("ERROR ", errno, " : ", msg);', 'SET outparam =  (SELECT JSON_OBJECT(\'Isuccess\', Isuccess, \'Error\', Error,\'Validation\', Validation,\'Controlid\', Controlid));');
	
	SET procconcat =CONCAT(procconcat,'ROLLBACK;', 'END;', 'START TRANSACTION;', 'SET Isuccess =FALSE;', 'SET  Validation =\'\';', 'SET Error =\'\';', 'SET Controlid =\'\';', 'CALL proc_common_selectjson(\'',tblname,'\',',tblwhereclause,'result);');
	SET procconcat =CONCAT(procconcat,'COMMIT;', 'SET Isuccess = TRUE;', 'set outparam=\'[]\';', '', 'END$$', 'DELIMITER ;');
	
	select procconcat;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_common_auto_update` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_common_auto_update` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_common_auto_update`(in subtables json,in procname varchar(1000),in tblname varchar(100),
IN pkname VARCHAR(100))
BEGIN
	declare procconcat text;
	DECLARE subtableconcat TEXT;
	DECLARE subtableparamname TEXT;
	DECLARE subtableparamconcat TEXT;
	declare subtabledeleteconcat text;
	
	SET subtableconcat = '';
	SET subtableparamname = '';
	SET subtableparamconcat = '';
	set subtabledeleteconcat = '';
	SET @countpk = JSON_LENGTH(JSON_EXTRACT(subtables , '$[0].subtables'));
	     SET @x1=0;
	     SELECT @outparam1 AS 'uploadfile param';
	     SELECT @x1 , @countpk;
	     IF @countpk > 0 THEN
	     
	     SET @subtablesarr = JSON_UNQUOTE(JSON_EXTRACT(subtables , '$[0].subtables'));
	     WHILE @x1  < @countpk DO
		SET subtableparamname = CONCAT ('subinput',@x1);
		SET subtableparamconcat =CONCAT(subtableparamconcat,' IN ',subtableparamname, ' json' ,',');
		SET @subtblnametemp = JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(@subtablesarr , '$[*].tblname'),CONCAT('$[',@x1,']')));
		SELECT @subtblnametemp;
		SET subtableconcat = CONCAT(subtableconcat,'\n','call proc_common_sub_insert(',subtableparamname,',\'',@subtblnametemp,'\',\'',pkname,'\',JSON_UNQUOTE(JSON_EXTRACT(inparam , \'$[0].',pkname,'\')),outparam);');
		set subtabledeleteconcat = concat(subtabledeleteconcat,'\n','CALL proc_common_sub_delete(\'',@subtblnametemp,'\',\'',pkname,'\',JSON_UNQUOTE(JSON_EXTRACT(inparam , \'$[0].',pkname,'\')),@delvar);');
		SET @x1 = @x1+1;
		END WHILE;
		
	     END IF;
	
	set subtableconcat = concat(subtabledeleteconcat,subtableconcat);
	SET procconcat='';
	SET procconcat =CONCAT(procconcat,'DELIMITER $$\n', 'DROP PROCEDURE IF EXISTS `',procname,'`$$\n', 'CREATE DEFINER=`root`@`localhost` PROCEDURE `',procname,'`(');
	SET procconcat =CONCAT(procconcat,'IN inparam json,',subtableparamconcat,'  ', 'OUT result json,', 'OUT outparam json', ')\n', 'label1:\n', 'BEGIN\n ', 'DECLARE errcount INT;\n', 'DECLARE errno INT;\n', 'DECLARE msg TEXT;\n', 'DECLARE p TEXT;\n', 'DECLARE Isuccess BOOLEAN;\n', 'DECLARE outparam1 json;\n', 'DECLARE  Validation TEXT;\n', 'DECLARE Error TEXT;\n', 'DECLARE Controlid TEXT;\n', 'DECLARE EXIT HANDLER FOR SQLEXCEPTION\n ', 'BEGIN\n ', 'SET Isuccess =FALSE;\n', 'SET  Validation =\'\';\n', 'SET Error =\'\';\n', 'SET Controlid =\'\';', 'SET Error = \'SQL Exception\';\n', ' GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;\n');
	SET procconcat =CONCAT(procconcat, 'GET CURRENT DIAGNOSTICS errcount = NUMBER;\n', 'IF errcount = 0 ', ' THEN ', 'SELECT \'1mapped insert succeeded, current DA is empty\' AS op;\n', 'SET Error = \'mapped insert succeeded, current DA is empty\' ;\n', 'ELSE ', 'GET CURRENT DIAGNOSTICS CONDITION 1 ', 'errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;');
	SET procconcat =CONCAT(procconcat, 'END IF ;', 'GET STACKED DIAGNOSTICS CONDITION 1 ', 'errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;', 'SET Error = CONCAT("ERROR ", errno, " : ", msg);', 'SET outparam =  (SELECT JSON_OBJECT(\'Isuccess\', Isuccess, \'Error\', Error,\'Validation\', Validation,\'Controlid\', Controlid));');
	
	SET procconcat =CONCAT(procconcat,'ROLLBACK;', 'END;', 'START TRANSACTION;', 'SET Isuccess =FALSE;', 'SET  Validation =\'\';', 'SET Error =\'\';', 'SET Controlid =\'\';', 'CALL proc_common_update(inparam,\'',tblname,'\',\'',pkname,'\',JSON_UNQUOTE(JSON_EXTRACT(inparam , \'$[0].',pkname,'\')),outparam);',subtableconcat);
	SET procconcat =CONCAT(procconcat,'COMMIT;', 'SET Isuccess = TRUE;', 'CALL proc_',tblname,'_selectjson(@result1,outparam);', 'SET result =@result1;', 'END$$', 'DELIMITER ;');
	
	select procconcat;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_common_createallprocedures` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_common_createallprocedures` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_common_createallprocedures`(in tblname varchar(1000),in pkname varchar(100))
BEGIN
	DECLARE pkidcomment text;
	declare tblhtml text;
	set pkidcomment = (SELECT COLUMN_COMMENT
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE table_name = tblname AND COLUMN_NAME=pkname AND table_schema = DATABASE()
		);
	set @frmmodelname = JSON_UNQUOTE(JSON_EXTRACT(pkidcomment , '$[0].formmodelname'));
	select pkidcomment,JSON_UNQUOTE(JSON_EXTRACT(pkidcomment , '$[0].pkprefix')),@frmmodelname;
	select pkidcomment,CONCAT('proc_',tblname,'_create'),tblname,pkname, JSON_UNQUOTE(JSON_EXTRACT(pkidcomment , '$[0].pkprefix'));
	CALL proc_common_auto_create(pkidcomment,concat('proc_',tblname,'_create'),tblname,pkname, JSON_UNQUOTE(JSON_EXTRACT(pkidcomment , '$[0].pkprefix')));
	CALL proc_common_auto_update(pkidcomment,CONCAT('proc_',tblname,'_update'),tblname,pkname);
	CALL proc_common_auto_selectjson(CONCAT('proc_',tblname,'_selectjson'),tblname,'');
	CALL proc_common_auto_selectedit(CONCAT('proc_',tblname,'_selectedit'),tblname,pkname);
	call proc_common_select_ts(tblname,@tblts);
	select @tblts as 'table TS';
	
	call proc_common__blankjson(tblname,@tbltsblank);
	select @tbltsblank as 'tbl ts blank';
	set tblhtml='';
	set @tbldisplayhtml='';
	 call proc_common_select_html(tblname,@frmmodelname,@tbldisplayhtml);
	 select @tbldisplayhtml as 'tbl html';
	 -- CALL proc_common_select_html('tbl_assigned_project','assingtask',@tblhtml);
	
	set @subtblcount = 1;
	set @subtblcount = @subtblcount + JSON_LENGTH(JSON_EXTRACT(pkidcomment, '$[0].subtables'));
	CALL proc_common_ws (concat('proc_',tblname,'_create'),CONCAT('WS_',tblname,'_create'),@subtblcount);
	CALL proc_common_ws (CONCAT('proc_',tblname,'_update'),CONCAT('WS_',tblname,'_update'),@subtblcount);
	CALL proc_common_ws (CONCAT('proc_',tblname,'_selectjson'),CONCAT('WS_',tblname,'_selectjson'),0);
	CALL proc_common_ws (CONCAT('proc_',tblname,'_selectedit'),CONCAT('WS_',tblname,'_selectedit'),1);
	
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_common_drpjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_common_drpjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_common_drpjson`(in pkid varchar(100), in pkname varchar(100) ,in tblnamendwhere varchar(1000), in tblwhere varchar(1000) ,out outparam json)
BEGIN
	DECLARE statustrue BOOLEAN;
	SET statustrue=FALSE;
	
	CALL proc_runningid('LF',@p);
	SET SESSION group_concat_max_len=10000000000000;
	
	SET statustrue=(SELECT IF(COLUMN_NAME='status',TRUE,FALSE)
	  FROM INFORMATION_SCHEMA.COLUMNS
	  WHERE table_name = tblnamendwhere AND  COLUMN_NAME ='status' AND table_schema = DATABASE());
	 -- select statustrue;
	 IF statustrue THEN
		IF tblwhere <> '' THEN
		   SET tblwhere = CONCAT('where status=\'active\' and ',tblwhere);
		ELSE
		   SET tblwhere = CONCAT('where status=\'active\'');
		END IF;
	ELSE
		IF tblwhere <> '' THEN
			SET tblwhere = CONCAT('where ',tblwhere);
		END IF;
	END IF;
	-- select tblwhere;
	
	
	SET @QUERY1 = CONCAT('insert into logrecord_details (logrecord_id,logrecord_result) SELECT \'',@p,'\', CONCAT(\'[\', GROUP_CONCAT(CONCAT(json_object(\'label\',',pkname,',\'value\',',pkid ,') )),\']\' ) FROM ',tblnamendwhere,' ' , tblwhere);
	-- select @QUERY1;
	PREPARE stmt1 FROM @QUERY1; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1; 
	set outparam=(select logrecord_result from logrecord_details where logrecord_id=@p);
	delete from logrecord_details WHERE logrecord_id=@p;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_common_generate_multiplesubquery` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_common_generate_multiplesubquery` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_common_generate_multiplesubquery`(in subtables json)
BEGIN
	
 SET SESSION group_concat_max_len=10000000000000;
 
 
 SET @primarypk=JSON_UNQUOTE(JSON_EXTRACT(subtables , '$[0].mainpkname')); -- 'ofcprojectpost_id';
 SET @primarytable=JSON_UNQUOTE(JSON_EXTRACT(subtables , '$[0].maintable')); -- 'tbl_ofcprojectpost_details';
 
SET @mainconcatstart = 'SELECT CONCAT(\'[\', (SELECT GROUP_CONCAT(CONCAT(\'{\',';
SET @maina=(SELECT DISTINCT GROUP_CONCAT(CONCAT('\'"', COLUMN_NAME,'":"\',IF(ISNULL(maina.',COLUMN_NAME,'),\'-\',',
CONCAT(IF ( DATA_TYPE = 'datetime',CONCAT('UNIX_TIMESTAMP(maina.',COLUMN_NAME,')*1000'),CONCAT('maina.',COLUMN_NAME,''))),'),\'",\''))
	  FROM INFORMATION_SCHEMA.COLUMNS
	  WHERE table_name = @primarytable AND table_schema = DATABASE());
	 select @mainconcatstart,@maina,JSON_UNQUOTE(JSON_EXTRACT(subtables , '$[0].mainpkname'));
	 SELECT @primarypk,@primarytable; 
 SET @countpk = JSON_LENGTH(JSON_EXTRACT(subtables , '$[0].subtables'));
 SET @x1=0;
 SET @subtablesarr = JSON_UNQUOTE(JSON_EXTRACT(subtables , '$[0].subtables'));
 set @subtablefinalquery='';
 -- {"maintable":"tbl_ofcprojectpost_details","mainpkname":"ofcprojectpost_id","subtables":[{"subtblname":"tbl_ofcprojectpost_questions","mainpkname":"ofcprojectpost_id","subkey":"projectpostquestionsid","subpkname":"projectpostquestions_id"},{"subtblname":"tbl_ofcprojectpost_keywords","mainpkname":"ofcprojectpost_id","subkey":"ofcprojectpostkeywords","subpkname":"ofcprojectpostkeywords_id"}]}
 select @countpk;
 WHILE @x1  < @countpk DO
	SET @subtblnametemp = JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(@subtablesarr , '$[*].subtblname'),CONCAT('$[',@x1,']')));
	SET @submainpknametemp = JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(@subtablesarr , '$[*].mainpkname'),CONCAT('$[',@x1,']')));
	SET @subkey = JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(@subtablesarr , '$[*].subkey'),CONCAT('$[',@x1,']')));
	SET @subpkname = JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(@subtablesarr , '$[*].subpkname'),CONCAT('$[',@x1,']')));
	  
	  SET @a=(SELECT DISTINCT GROUP_CONCAT(CONCAT('\'', COLUMN_NAME,'\',',IF ( DATA_TYPE = 'datetime',CONCAT('UNIX_TIMESTAMP(','sub',@x1,'.',COLUMN_NAME,')*1000'),concat('sub',@x1,'.',COLUMN_NAME))))
	  FROM INFORMATION_SCHEMA.COLUMNS
	  WHERE table_name = @subtblnametemp AND table_schema = DATABASE());
	  
	  SET @subprefix = '(SELECT CONCAT(\'[\',GROUP_CONCAT( json_object(';
	  -- 
	  
	  set @x1temp = @x1 + 1;
	  -- select @x1temp ;
	  set @bracktemp='';
	  if @x1temp = @countpk then
		-- select concat('true - ',@x1temp);
		SET @subend = ')) ,\']}\')';
		SET @bracktemp=')';
	  else
		-- select concat('false',@x1temp);
		SET @subend = ')) ,\'],\')';
	  end if;
	  -- final
	  SET @subtablefinalquery = CONCAT( @subtablefinalquery,@bracktemp,',\'"',@subkey,'":\',',@subprefix,@a,@subend);
	  SET @subtablefinalquery = CONCAT(@subtablefinalquery,'FROM ',@primarytable,' main',@x1,', ',@subtblnametemp,' sub',@x1,' WHERE main',@x1,'.',@primarypk,'=sub',@x1,'.',@submainpknametemp,' AND sub',@x1,'.',@subpkname,' = sub',@x1,'.',@subpkname,')');
	  SET @x1 = @x1+1;
	END WHILE;
  
	select @subtablefinalquery;
	SET @mainsuba = CONCAT(@mainconcatstart,@maina,@subtablefinalquery,')','FROM ',@primarytable,' maina where maina.',@primarypk,'=maina.',@primarypk,'  ),\']\')');
	select @maina;
	select  @mainsuba;
 
 
 
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_common_insert` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_common_insert` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_common_insert`(    
    IN inparamjson json,  
    in tblname varchar(1000),
    in primarykey varchar(100),
    in prefix1 varchar(100),
    out outparam longtext
    )
label1:
BEGIN
	
	
	
	DECLARE errcount INT;
	DECLARE errno INT;
	DECLARE msg TEXT;
	DECLARE p TEXT;
		
	DECLARE Isuccess BOOLEAN;
	declare outparam1 json;
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
	
	 START TRANSACTION;
	SET Isuccess =FALSE;
	
	SET  Validation ='';
	SET Error ='';
	SET Controlid ='';
	
	
	CALL proc_runningid(prefix1,@p);
	 
	  SET @colums1=(SELECT  GROUP_CONCAT(COLUMN_NAME) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = tblname AND table_schema =  database() AND COLUMN_NAME IN (SELECT DISTINCT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME <>'modifieddate' and table_name = tblname AND table_schema =  database()));
	   SELECT @colums1;
	  SET @pram =( SELECT  GROUP_CONCAT( if(COLUMN_NAME=primarykey,concat('\'',@p,'\''),
	     IF(COLUMN_NAME='createdate',concat('\'',now(),'\'') ,IF(COLUMN_NAME='status',concat('\'active\''),CONCAT('JSON_UNQUOTE(JSON_EXTRACT(\'',inparamjson , '\',\'$[0].',COLUMN_NAME,'\'))')))
					)
		)
	      FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = tblname AND table_schema =  database() AND COLUMN_NAME IN (SELECT DISTINCT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME <>'modifieddate' AND table_name = tblname AND table_schema =  database()));
	  select @pram;
	  
	   SET @updatestmt1 = (SELECT CONCAT ('insert into ',tblname,'(', @colums1,') values(',@pram,')'));
	   select @updatestmt1;
	  
	     PREPARE stmt1 FROM @updatestmt1; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1; 
		-- tbl_project_master Succesful insert
	     -- set Controlid = @p;
	     -- get count of json array
	    
	
	
     COMMIT;
     SET Isuccess = TRUE;
     SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
         'Error', Error,
         'Validation', Validation,
       'Controlid', Controlid,'Idupdated',@p));
     
       
       -- SELECT * FROM tbl_member_master WHERE STATUS='active';
       -- CALL proc_testone_selectjson(strjson);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_common_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_common_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_common_selectjson`(in tblnamendwhere varchar(1000), in tblwhere varchar(1000) ,out outparam json)
BEGIN
	declare statustrue boolean;
	set statustrue=false;
	CALL proc_runningid('LF',@p);
	SET SESSION group_concat_max_len=10000000000000;
	SET @a=(SELECT DISTINCT GROUP_CONCAT(CONCAT('\'', COLUMN_NAME,'\',',IF ( DATA_TYPE = 'datetime',CONCAT('UNIX_TIMESTAMP(',COLUMN_NAME,')*1000'),COLUMN_NAME)))
	  FROM INFORMATION_SCHEMA.COLUMNS
	  WHERE table_name = tblnamendwhere and table_schema = database());
	  
	SET statustrue=(SELECT if(COLUMN_NAME='status',true,false)
	  FROM INFORMATION_SCHEMA.COLUMNS
	  WHERE table_name = tblnamendwhere AND  COLUMN_NAME ='status' and table_schema = DATABASE());
	 -- select statustrue;
	 if statustrue then
		if tblwhere <> '' then
		   set tblwhere = concat('where status=\'active\' and ',tblwhere);
		else
		   SET tblwhere = CONCAT('where status=\'active\'');
		end if;
	else
		IF tblwhere <> '' THEN
			SET tblwhere = CONCAT('where ',tblwhere);
		end if;
	end if;
	-- select tblwhere;
	  
	SET @QUERY1 = CONCAT('insert into logrecord_details (logrecord_id,logrecord_result) select \'', @p ,'\', concat(\'[\',GROUP_CONCAT( json_object(',@a , ')),\']\') from ',tblnamendwhere, ' ' , tblwhere);
	PREPARE stmt1 FROM @QUERY1; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1; 
	set outparam=(select logrecord_result from logrecord_details where logrecord_id=@p);
	delete from logrecord_details WHERE logrecord_id=@p;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_common_select_html` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_common_select_html` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_common_select_html`(IN tblnamendwhere VARCHAR(1000), IN formmodelname VARCHAR(1000) ,OUT outparam json)
label1:
BEGIN
		
	
	
	DECLARE concatfields TEXT;
	DECLARE fieldtemp TEXT;
	DECLARE consthtmlfront TEXT;
	DECLARE consthtmlreare TEXT;
	DECLARE consthtmlbutton TEXT;
		
	
	SET consthtmlfront = CONCAT( '<div class=\'ui-grid-row\' style=\'width:100%;\'>', '<div class=\'ui-g form-group\' style=\'width:80%;\'>', '<div class=\'ui-g-12 ui-md-4\' style=\'width:100%;\'>', '<span class=\'md-inputfield\'>');
	
	SET consthtmlreare = CONCAT('</div>'); -- ,'<div class=\'ui-grid-col-4\'>','','','','','','','','');
	set consthtmlbutton = concat('<div class="ui-grid-row" style="width:100%;">',' <div class="ui-g form-group" style="width:80%;">','<div class="ui-g-12 ui-md-4" style="width:100%;float:left;">','<div style="width:50%">','<button pButton  (click)="onSubmit()" label="Submit" ></button><br/>','</div>  ','<div style="width:50%;float:right;">','<button pButton  (click)="clear()" label="Clear" ></button>','</div>','</div>','</div>','</div>');
	START TRANSACTION;
	SET SESSION group_concat_max_len=10000000000000;
	
	-- SET @countpk = JSON_LENGTH(JSON_EXTRACT(fileuploadjson , '$[*].fileName'));
	SET @x1=0;
	
	set @pknamefetch = (SELECT column_name
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE table_name= tblnamendwhere AND table_schema = DATABASE());
	
	SET @columnarr=(SELECT CONCAT ('[',
       GROUP_CONCAT( json_object(
       'columnname',COLUMN_NAME,'columncomment',COLUMN_COMMENT,'datatype',DATA_TYPE)),']')
		FROM INFORMATION_SCHEMA.COLUMNS
			WHERE table_name = tblnamendwhere AND
				table_schema = Database() AND COLUMN_COMMENT <> '' and COLUMN_NAME<>@pknamefetch);
	
	SET @countpk=JSON_LENGTH(JSON_EXTRACT(@columnarr , '$[*].columnname'));
	SET @concatfields='';
	SET @fieldtemp='';
	set @formgroupvalid = 'this.userform = this.fb.group({';
	set @formgroupvalidend = '});';
	set @formgroupvalidfinal ='';
	 WHILE @x1  < @countpk DO
	 
		-- select JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(@columnarr , '$[*].columnname'),CONCAT('$[',@x1,']'))), JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(@columnarr , '$[*].columncomment'),CONCAT('$[',@x1,']')));
		 -- comments retrived
		SET @comarr = (SELECT JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(@columnarr , '$[*].columncomment'),CONCAT('$[',@x1,']'))));
		SET @columnnametemp = JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(@columnarr , '$[*].columnname'),CONCAT('$[',@x1,']')));
		SET @datatypetemp = JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(@columnarr , '$[*].datatype'),CONCAT('$[',@x1,']')));
		SET @validate = JSON_UNQUOTE(JSON_EXTRACT(@comarr , '$[0].validation'));
		SET @controltype = JSON_UNQUOTE(JSON_EXTRACT(@comarr , '$[0].controltype'));
		SET @formcontrolname = JSON_UNQUOTE(JSON_EXTRACT(@comarr , '$[0].formcontrolname'));
		SET @ngmodel = JSON_UNQUOTE(JSON_EXTRACT(@comarr , '$[0].ngmodel'));
		SET @errorstring = JSON_UNQUOTE(JSON_EXTRACT(@comarr , '$[0].errorstring'));
		SET @placeholder = JSON_UNQUOTE(JSON_EXTRACT(@comarr , '$[0].placeholder'));
		set @drpoptions = JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(@columnarr , '$[*].options'),CONCAT('$[',@x1,']')));
		-- SELECT @controltype,@columnnametemp,@validate,@formcontrolname,@ngmodel,@errorstring,@placeholder;
		
		
		
		SET @formcontrolname= IF(@formcontrolname<>'' and @formcontrolname IS NOT NULL,@formcontrolname,@columnnametemp);
		SET @ngmodel=IF(@ngmodel<>'' and @ngmodel IS NOT NULL,@ngmodel,CONCAT(formmodelname,'.',@columnnametemp));
		
		IF @validate IS NOT NULL and @validate = 'yes' THEN
			SET @formgroupvalidfinal = concat(@formgroupvalidfinal,'\'',@formcontrolname,'\':new FormControl(\'\', Validators. required),');
		END IF;
		IF @validate IS NOT NULL and @validate = 'no' THEN
			SET @formgroupvalidfinal = CONCAT('\'',@formcontrolname,'\':new FormControl(\'\', null)');
		END IF;
			-- textbox
			IF @controltype = 'txt' THEN
				
				set @inputtype = 'input pInputText type=\'text\'';
				
				if @datatypetemp = 'int' or @datatypetemp = 'bigint' then
					
				SET @inputtype='p-spinner [min]="0" [step]="1"';
				
				end if;
				
				IF @datatypetemp = 'decimal' OR @datatypetemp = 'double' OR @datatypetemp = 'float' THEN
					
					SET @inputtype='p-spinner [min]="0" [step]="0.25"';
				
				END IF;
				 
				-- select 'inside controtype';
				SET @fieldtemp = CONCAT('<',@inputtype,' [(ngModel)]=\'', @ngmodel,'\' formControlName=\'',@formcontrolname,'\' /> <label>',@placeholder,'</label></span></div></div>');
				-- select @fieldtemp;
				IF @validate IS NOT NULL OR @validate = 'yes' THEN
					SET @tempvalidate =CONCAT( '<div class="ui-grid-col-4">   <div class="ui-message ui-messages-error ui-corner-all" *ngIf="!userform.controls[\'',@formcontrolname,'\'].valid&&userform.controls[\'',@formcontrolname,'\'].touched">',@errorstring,' Required</div></div>');
					SET @fieldtemp = CONCAT(@fieldtemp,@tempvalidate);
				END IF;
			END IF;
			
			-- dropdown
			IF @controltype = 'drp' THEN
								 
				-- select 'inside controtype';
				SET @fieldtemp = CONCAT('<p-dropdown [options]="',@drpoptions,'" [(ngModel)]="', @ngmodel,'" formControlName="',@formcontrolname,'"></p-dropdown> </span></div></div>');
				-- select @fieldtemp;
				IF @validate IS NOT NULL OR @validate = 'yes' THEN
					SET @tempvalidate =CONCAT( '<div class="ui-grid-col-4">   <div class="ui-message ui-messages-error ui-corner-all" *ngIf="!userform.controls[\'',@formcontrolname,'\'].valid&&userform.controls[\'',@formcontrolname,'\'].touched">',@errorstring,' Required</div></div>');
					SET @fieldtemp = CONCAT(@fieldtemp,@tempvalidate);
				END IF;
			END IF;
			
			-- calendar
			IF @controltype = 'date' THEN
								 
				-- select 'inside controtype';
				SET @fieldtemp = CONCAT('<p-calendar [(ngModel)]="',@ngmodel,'"  dateFormat="mm/dd/yy" formControlName="',@formcontrolname,'"> </span></div></div>');
				-- select @fieldtemp;
				IF @validate IS NOT NULL OR @validate = 'yes' THEN
					SET @tempvalidate =CONCAT( '<div class="ui-grid-col-4">   <div class="ui-message ui-messages-error ui-corner-all" *ngIf="!userform.controls[\'',@formcontrolname,'\'].valid&&userform.controls[\'',@formcontrolname,'\'].touched">',@errorstring,' Required</div></div>');
					SET @fieldtemp = CONCAT(@fieldtemp,@tempvalidate);
				END IF;
			END IF;
			
			-- text area
			IF @controltype = 'txtA' THEN
								 
				-- select 'inside controtype';
				SET @fieldtemp = CONCAT('<textarea pInputTextarea [(ngModel)]="',@ngmodel,'" formControlName="',@formcontrolname,'" autoResize="autoResize"></textarea>  </span></div></div>');
				-- select @fieldtemp;
				IF @validate IS NOT NULL OR @validate = 'yes' THEN
					SET @tempvalidate =CONCAT( '<div class="ui-grid-col-4">   <div class="ui-message ui-messages-error ui-corner-all" *ngIf="!userform.controls[\'',@formcontrolname,'\'].valid&&userform.controls[\'',@formcontrolname,'\'].touched">',@errorstring,' Required</div></div>');
					SET @fieldtemp = CONCAT(@fieldtemp,@tempvalidate);
				END IF;
			END IF;
		-- select @fieldtemp;
		IF @fieldtemp IS NOT NULL OR @fieldtemp <> '' THEN
			-- select 'inside if condition';
			SET @concatfields= CONCAT(@concatfields,consthtmlfront,@fieldtemp,consthtmlreare );
		END IF;
		SET @x1 = @x1+1;
	 END WHILE;
	COMMIT;
	
	SET @formgroupvalidfinal =concat(@formgroupvalid ,@formgroupvalidfinal,@formgroupvalidend);
	SET @concatfields = CONCAT('<p-growl [value]="msgs"></p-growl>
    <h1>Create projects</h1><br/>', '<form [formGroup]="userform" ><div class="ui-grid ui-grid-responsive ui-grid-pad ui-fluid" style="margin: 10px 0px;width:80%;">',@concatfields,consthtmlbutton,
    '</div></form>\n',@formgroupvalidfinal);
	SELECT @concatfields;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_common_select_single_json` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_common_select_single_json` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_common_select_single_json`(in tblnamendwhere varchar(1000), in tblwhere varchar(1000) ,out outparam json)
BEGIN
	DECLARE statustrue BOOLEAN;
	SET statustrue=FALSE;
	CALL proc_runningid('LF',@p);
SET SESSION group_concat_max_len=10000000000000;
	SET @a=(SELECT DISTINCT GROUP_CONCAT(CONCAT('\'', COLUMN_NAME,'\',',IF ( DATA_TYPE = 'datetime',CONCAT('UNIX_TIMESTAMP(',COLUMN_NAME,')*1000'),COLUMN_NAME)))
	  FROM INFORMATION_SCHEMA.COLUMNS
	  WHERE table_name = tblnamendwhere AND table_schema = DATABASE());
	SET statustrue=(SELECT IF(COLUMN_NAME='status',TRUE,FALSE)
	  FROM INFORMATION_SCHEMA.COLUMNS
	  WHERE table_name = tblnamendwhere AND  COLUMN_NAME ='status' AND table_schema = DATABASE());
	 -- select statustrue;
	 IF statustrue THEN
		IF tblwhere <> '' THEN
		   SET tblwhere = CONCAT('where status=\'active\' and ',tblwhere);
		ELSE
		   SET tblwhere = CONCAT('where status=\'active\'');
		END IF;
	ELSE
		IF tblwhere <> '' THEN
			SET tblwhere = CONCAT('where ',tblwhere);
		END IF;
	END IF;
	 -- select tblwhere;
	SET @QUERY1 = CONCAT('insert into logrecord_details (logrecord_id,logrecord_result) select \'', @p ,'\',concat(GROUP_CONCAT( json_object(',@a , ')),\'\') from ',tblnamendwhere, ' ' ,tblwhere,';');
	-- select @QUERY1;
	PREPARE stmt1 FROM @QUERY1; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1; 
	SET outparam=(SELECT logrecord_result FROM logrecord_details WHERE logrecord_id=@p);
	DELETE FROM logrecord_details WHERE logrecord_id=@p;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_common_select_subhtml` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_common_select_subhtml` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_common_select_subhtml`(IN tblnamendwhere VARCHAR(1000), IN formmodelname VARCHAR(1000),IN vwnamendwhere VARCHAR(1000), IN vwformmodelname VARCHAR(1000), in parentpkname varchar(100) ,OUT outparam json)
label1:
BEGIN
		
	
	
	DECLARE concatfields TEXT;
	DECLARE fieldtemp TEXT;
	DECLARE consthtmlfront TEXT;
	DECLARE consthtmlreare TEXT;
	DECLARE consthtmlbutton TEXT;
		
	DECLARE consthtmlfront2 TEXT;
	DECLARE consthtmlreare2 TEXT;
	
	set consthtmlfront ='';
	set consthtmlbutton='';
	SET consthtmlfront = CONCAT( '<div class="ui-grid ui-grid-responsive ui-grid-pad ui-fluid" style="margin: 10px 0px;width:80%;"><label>',formmodelname,' Details</label><div formGroupName="',formmodelname,'_subgroup">');
	
	SET consthtmlreare = CONCAT(''); -- ,'<div class=\'ui-grid-col-4\'>','','','','','','','','');
	set consthtmlbutton = concat('<div class="ui-grid-row" style="width:100%;">','<div class="ui-g form-group" style="width:80%;">','<div class="ui-g-12 ui-md-4" style="width:100%;float:left;">','<div style="width:50%"><button pButton (click)="onSubmit',formmodelname,'()" label="Add"></button><br/></div>','</div>','</div>','</div>','<p-dataTable [value]="',vwformmodelname,'s" selectionMode="single" [rows]="10" [paginator]="true" (onRowSelect)="on',vwformmodelname,'RowSelected($event)" [(selection)]="selected',vwformmodelname,'Row">');
	
	set consthtmlfront2 = '';
	set consthtmlreare2 = '';
	
	SET consthtmlfront2 = CONCAT(consthtmlfront2,'<div class="ui-grid-row" style="width:100%;"> <div class="ui-g form-group" style="width:80%;"> <div class="ui-g-12 ui-md-4" style="width:100%;">');
	SET consthtmlreare2 = CONCAT(consthtmlreare2,'</div> ');
	START TRANSACTION;
	SET SESSION group_concat_max_len=10000000000000;
	
	-- SET @countpk = JSON_LENGTH(JSON_EXTRACT(fileuploadjson , '$[*].fileName'));
	SET @x1=0;
	
	set @pknamefetch = (SELECT column_name
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE table_name= tblnamendwhere AND table_schema = DATABASE());
	
	SET @columnarr=(SELECT CONCAT ('[',
       GROUP_CONCAT( json_object(
       'columnname',COLUMN_NAME,'columncomment',COLUMN_COMMENT,'datatype',DATA_TYPE)),']')
		FROM INFORMATION_SCHEMA.COLUMNS
			WHERE table_name = tblnamendwhere AND
				table_schema = Database() AND COLUMN_COMMENT <> '' and COLUMN_NAME<>@pknamefetch);
	
	SET @columnarr2=(SELECT CONCAT ('[',
       GROUP_CONCAT( json_object(
       'columnname',COLUMN_NAME,'columncomment',COLUMN_COMMENT,'datatype',DATA_TYPE)),']')
		FROM INFORMATION_SCHEMA.COLUMNS
			WHERE table_name = vwnamendwhere AND
				table_schema = DATABASE());
	
	SET @x3=0;
	SET @countpk3=JSON_LENGTH(JSON_EXTRACT(@columnarr2 , '$[*].columnname'));
	select @x3,@countpk3;
	-- SELECT consthtmlbutton as 'before';
	WHILE @x3  < @countpk3 DO
			SET @columnnametemp = JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(@columnarr2 , '$[*].columnname'),CONCAT('$[',@x3,']')));
			-- SET @placeholder = JSON_UNQUOTE(JSON_EXTRACT(@columnarr2 , '$[0].placeholder'));
			SET @placeholder = @columnnametemp;
			SET consthtmlbutton = CONCAT(consthtmlbutton,'<p-column field="',@columnnametemp,'" [filter]="true" filterPlaceholder="Search ',@placeholder,'"  header="',@placeholder,'"></p-column>');
			SET @x3=@x3+1;
	END WHILE;
	SET consthtmlbutton = CONCAT(consthtmlbutton,'</p-dataTable></div>');
	-- select consthtmlbutton;
	-- making json select for view proc and WS and TS
	CALL proc_common_auto_selectjson(CONCAT('proc_',vwnamendwhere,'_selectjson'),vwnamendwhere,parentpkname);
	call proc_common_select_ts(vwnamendwhere,@tsresult);
	select @tsresult as 'TS grid';
	call proc_common__blankjson(vwnamendwhere,@blanktsresult);
	SELECT @blanktsresult AS 'Blank TS grid';
	call proc_common_ws(concat('proc_',vwnamendwhere,'_selectjson'),concat('WS_',vwnamendwhere,'_selectjson'),if(parentpkname<>'' and parentpkname is not null,1,0));
	-- End of TS view proc WS.
	
	
	SET @countpk=JSON_LENGTH(JSON_EXTRACT(@columnarr2 , '$[*].columnname'));
	SET @concatfields='';
	SET @fieldtemp='';
	set @formgroupvalid = 'this.usersubform = this.fb.group({';
	set @formgroupvalidend = '});';
	set @formgroupvalidfinal ='';
	 WHILE @x1  < @countpk DO
	 
		-- select JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(@columnarr , '$[*].columnname'),CONCAT('$[',@x1,']'))), JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(@columnarr , '$[*].columncomment'),CONCAT('$[',@x1,']')));
		 -- comments retrived
		SET @comarr = (SELECT JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(@columnarr , '$[*].columncomment'),CONCAT('$[',@x1,']'))));
		SET @columnnametemp = JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(@columnarr , '$[*].columnname'),CONCAT('$[',@x1,']')));
		SET @datatypetemp = JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(@columnarr , '$[*].datatype'),CONCAT('$[',@x1,']')));
		SET @validate = JSON_UNQUOTE(JSON_EXTRACT(@comarr , '$[0].validation'));
		SET @controltype = JSON_UNQUOTE(JSON_EXTRACT(@comarr , '$[0].controltype'));
		SET @formcontrolname = JSON_UNQUOTE(JSON_EXTRACT(@comarr , '$[0].formcontrolname'));
		SET @ngmodel = JSON_UNQUOTE(JSON_EXTRACT(@comarr , '$[0].ngmodel'));
		SET @errorstring = JSON_UNQUOTE(JSON_EXTRACT(@comarr , '$[0].errorstring'));
		SET @placeholder = JSON_UNQUOTE(JSON_EXTRACT(@comarr , '$[0].placeholder'));
		-- SELECT @controltype,@columnnametemp,@validate,@formcontrolname,@ngmodel,@errorstring,@placeholder;
		
		
		
		SET @formcontrolname= IF(@formcontrolname<>'' and @formcontrolname IS NOT NULL,@formcontrolname,@columnnametemp);
		SET @ngmodel=IF(@ngmodel<>'' and @ngmodel IS NOT NULL,@ngmodel,CONCAT(formmodelname,'.',@columnnametemp));
		
		IF @validate IS NOT NULL and @validate = 'yes' THEN
			SET @formgroupvalidfinal = concat(@formgroupvalidfinal,'\'',@formcontrolname,'\':new FormControl(\'\', Validators. required),');
		END IF;
		IF @validate IS NOT NULL and @validate = 'no' THEN
			SET @formgroupvalidfinal = CONCAT('\'',@formcontrolname,'\':new FormControl(\'\', null)');
		END IF;
			-- textbox
			IF @controltype = 'txt' THEN
				
				set @inputtype = 'input pInputText type=\'text\'';
				
				if @datatypetemp = 'int' or @datatypetemp = 'bigint' then
					
				SET @inputtype='p-spinner [min]="0" [step]="1"';
				
				end if;
				
				IF @datatypetemp = 'decimal' OR @datatypetemp = 'double' OR @datatypetemp = 'float' THEN
					
					SET @inputtype='p-spinner [min]="0" [step]="0.25"';
				
				END IF;
				 
				-- select 'inside controtype';
				SET @fieldtemp = CONCAT('<',@inputtype,' [(ngModel)]=\'', @ngmodel,'\' formControlName=\'',@formcontrolname,'\' /> <span><label>',@placeholder,'</label></span></div></div>');
				-- select @fieldtemp;
				IF @validate IS NOT NULL OR @validate = 'yes' THEN
					SET @tempvalidate =CONCAT( '<div class="ui-grid-col-4">   <!-- <div class="ui-message ui-messages-error ui-corner-all" *ngIf="!usersubform.controls[\'',@formcontrolname,'\'].valid&&usersubform.controls[\'',@formcontrolname,'\'].touched">',@errorstring,' Required</div>--></div>');
					SET @fieldtemp = CONCAT(@fieldtemp,@tempvalidate);
				END IF;
			END IF;
			
			-- dropdown
			IF @controltype = 'drp' THEN
								 
				-- select 'inside controtype';
				SET @fieldtemp = CONCAT('<p-dropdown [options]="drpproject" [(ngModel)]="', @ngmodel,'" formControlName="',@formcontrolname,'"></p-dropdown> </span></div></div>');
				-- select @fieldtemp;
				IF @validate IS NOT NULL OR @validate = 'yes' THEN
					SET @tempvalidate =CONCAT( '<div class="ui-grid-col-4">   <!-- <div class="ui-message ui-messages-error ui-corner-all" *ngIf="!usersubform.controls[\'',@formcontrolname,'\'].valid&&usersubform.controls[\'',@formcontrolname,'\'].touched">',@errorstring,' Required</div>--></div>');
					SET @fieldtemp = CONCAT(@fieldtemp,@tempvalidate);
				END IF;
			END IF;
			
			-- calendar
			IF @controltype = 'date' THEN
								 
				-- select 'inside controtype';
				SET @fieldtemp = CONCAT('<p-calendar [(ngModel)]="',@ngmodel,'"  dateFormat="mm/dd/yy" formControlName="',@formcontrolname,'"> </span></div></div>');
				-- select @fieldtemp;
				IF @validate IS NOT NULL OR @validate = 'yes' THEN
					SET @tempvalidate =CONCAT( '<div class="ui-grid-col-4">   <!-- <div class="ui-message ui-messages-error ui-corner-all" *ngIf="!usersubform.controls[\'',@formcontrolname,'\'].valid&&usersubform.controls[\'',@formcontrolname,'\'].touched">',@errorstring,' Required</div>--></div>');
					SET @fieldtemp = CONCAT(@fieldtemp,@tempvalidate);
				END IF;
			END IF;
			
			-- text area
			IF @controltype = 'txtA' THEN
								 
				-- select 'inside controtype';
				SET @fieldtemp = CONCAT('<textarea pInputTextarea [(ngModel)]="',@ngmodel,'" formControlName="',@formcontrolname,'" autoResize="autoResize"></textarea>  </span></div></div>');
				-- select @fieldtemp;
				IF @validate IS NOT NULL OR @validate = 'yes' THEN
					SET @tempvalidate =CONCAT( '<div class="ui-grid-col-4">  <!--  <div class="ui-message ui-messages-error ui-corner-all" *ngIf="!usersubform.controls[\'',@formcontrolname,'\'].valid&&usersubform.controls[\'',@formcontrolname,'\'].touched">',@errorstring,' Required</div>--></div>');
					SET @fieldtemp = CONCAT(@fieldtemp,@tempvalidate);
				END IF;
			END IF;
		-- select @fieldtemp;
		IF @fieldtemp IS NOT NULL OR @fieldtemp <> '' THEN
			-- select 'inside if condition';
			SET @concatfields= CONCAT(@concatfields,consthtmlfront2,@fieldtemp,consthtmlreare2 );
		END IF;
		SET @x1 = @x1+1;
	 END WHILE;
	COMMIT;
	
	SET @formgroupvalidfinal =concat(@formgroupvalid ,@formgroupvalidfinal,@formgroupvalidend);
	-- select consthtmlfront;
	SET @concatfields = CONCAT(consthtmlfront,@concatfields,'</div>',consthtmlbutton,
    '\n',@formgroupvalidfinal);
	SELECT @concatfields;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_common_select_ts` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_common_select_ts` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_common_select_ts`(in tblnamendwhere varchar(1000) ,out outparam longtext)
BEGIN
SET SESSION group_concat_max_len=10000000000000;
	SET outparam=(SELECT DISTINCT GROUP_CONCAT(CONCAT('', COLUMN_NAME,':string;'))
	  FROM INFORMATION_SCHEMA.COLUMNS
	  WHERE table_name = tblnamendwhere AND table_schema = DATABASE());
	
	SET outparam = concat('{', outparam , '}');
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_common_sub_delete` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_common_sub_delete` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_common_sub_delete`(    
    
    in tblname varchar(1000),
    in primarykey varchar(100),
    in pkid varchar(100),
    out outparam longtext
    )
label1:
BEGIN
	
	
	
	DECLARE errcount INT;
	DECLARE errno INT;
	DECLARE msg TEXT;
	DECLARE p TEXT;
		
	DECLARE Isuccess BOOLEAN;
	declare outparam1 json;
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
	
	 START TRANSACTION;
	SET Isuccess =FALSE;
	
	SET  Validation ='';
	SET Error ='';
	SET Controlid ='';
	
	
	-- CALL proc_runningid(prefix1,@p);
	 
	  
	  
	   SET @updatestmt1 = (SELECT CONCAT ('delete from ',tblname,' where ', primarykey ,'=\'',pkid,'\''));
	   select @updatestmt1;
	  
	     PREPARE stmt1 FROM @updatestmt1; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1; 
		-- tbl_project_master Succesful insert
	     
	     -- get count of json array
	    
	
	
     COMMIT;
     SET Isuccess = TRUE;
     SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
         'Error', Error,
         'Validation', Validation,
       'Controlid', Controlid));
     
       
       -- SELECT * FROM tbl_member_master WHERE STATUS='active';
       -- CALL proc_testone_selectjson(strjson);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_common_sub_generateprimary_insert` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_common_sub_generateprimary_insert` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_common_sub_generateprimary_insert`(    
    IN inparamjson LONGTEXT,  
    IN tblname VARCHAR(1000),
    IN primarykey VARCHAR(100),
    IN pkid VARCHAR(100),
    in prefix1 varchar(100),
    in subprimarykey varchar(100),
    in subsubtblname varchar(1000),
    IN subsubjsonkeyname VARCHAR(100),
    OUT outparam LONGTEXT
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
	
	 START TRANSACTION;
	SET Isuccess =FALSE;
	
	SET  Validation ='';
	SET Error ='';
	SET Controlid ='';
	
	
	-- CALL proc_runningid(prefix1,@p);
	 SET SESSION group_concat_max_len=10000000000000;
	  SET @colums1=(SELECT  GROUP_CONCAT(COLUMN_NAME) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = tblname AND table_schema =  DATABASE() AND COLUMN_NAME IN (SELECT DISTINCT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = tblname AND table_schema =  DATABASE() AND COLUMN_NAME <> (SELECT column_name
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE table_schema = DATABASE() AND table_name = tblname)));
	   SELECT @colums1;
	  
	SET @countpk = JSON_LENGTH(JSON_EXTRACT(inparamjson , concat('$[*].',primarykey,'')));
	     SET @x1=0;
	     
	WHILE @x1  < @countpk DO
	select @x1 , @countpk;
	select CONCAT('JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(\'',inparamjson , '\',\'$[*].',primarykey,'\'),\'$[',@x1,']\'))');
	  set @p='';
	  CALL proc_runningid(prefix1,@p);
	  
	  SET @pram =( SELECT  GROUP_CONCAT( 
	     IF(COLUMN_NAME=primarykey,CONCAT('\'',pkid,'\''),
	     if(COLUMN_NAME=subprimarykey,CONCAT('\'',@p,'\''),
	     CONCAT('JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(\'',inparamjson , '\',\'$[*].',COLUMN_NAME,'\'),\'$[',@x1,']\'))')
		    )
		  )
		)
		
	      FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = tblname AND table_schema =  DATABASE() AND COLUMN_NAME IN (SELECT DISTINCT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = tblname AND table_schema =  DATABASE() AND COLUMN_NAME <> (SELECT column_name
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE table_schema = DATABASE() AND table_name = tblname)));
	  SELECT @pram;
	  
	   SET @updatestmt1 = (SELECT CONCAT ('insert into ',tblname,'(', @colums1,') values(',@pram,')'));
	   SELECT @updatestmt1;
	  
	   
	PREPARE stmt1 FROM @updatestmt1; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1; 
	
	-- subsubjsonkeyname
	set @outparam1='';
	-- select JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(inparamjson ,'$[*].',primarykey,''),'$[',@x1,']'));
	CALL proc_common_sub_insert(JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(inparamjson ,concat('$[*].',primarykey,'')),concat('$[',@x1,']'))),subsubtblname,subprimarykey,@p,@outparam1);-- JSON_UNQUOTE(JSON_EXTRACT(outparam , '$[0].Idupdated')),@outparam1);
	
	-- SELECT  GROUP_CONCAT( IF(COLUMN_NAME=primarykey,CONCAT('\'',pkid,'\''), 
	   --   CONCAT('JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(\'',inparamjson , '\',\'$[*].',COLUMN_NAME,'\'),\'$[',@x1,']\'))')
	     
		-- 	)
	-- 	) as 'mine'
		
	   --    FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = tblname AND table_schema =  DATABASE() AND COLUMN_NAME IN (SELECT DISTINCT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = tblname AND table_schema =  DATABASE() AND COLUMN_NAME <> (SELECT column_name
-- FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE table_schema = DATABASE() AND table_name = tblname));
		-- tbl_project_master Succesful insert
	     
	     -- get count of json array
	     set @x1 = @x1 + 1;
	  end while;  
	
	
     COMMIT;
     SET Isuccess = TRUE;
     SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
         'Error', Error,
         'Validation', Validation,
       'Controlid', Controlid));
     
       
       -- SELECT * FROM tbl_member_master WHERE STATUS='active';
       -- CALL proc_testone_selectjson(strjson);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_common_sub_insert` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_common_sub_insert` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_common_sub_insert`(    
    IN inparamjson LONGTEXT,  
    IN tblname VARCHAR(1000),
    IN primarykey VARCHAR(100),
    IN pkid VARCHAR(100),
    OUT outparam LONGTEXT
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
	
	 START TRANSACTION;
	SET Isuccess =FALSE;
	
	SET  Validation ='';
	SET Error ='';
	SET Controlid ='';
	
	
	-- CALL proc_runningid(prefix1,@p);
	 SET SESSION group_concat_max_len=10000000000000;
	  SET @colums1=(SELECT  GROUP_CONCAT(COLUMN_NAME) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = tblname AND table_schema =  DATABASE() AND COLUMN_NAME IN (SELECT DISTINCT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = tblname AND table_schema =  DATABASE() AND COLUMN_NAME <> (SELECT column_name
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE table_schema = DATABASE() AND table_name = tblname)));
	   SELECT @colums1;
	  
	SET @countpk = JSON_LENGTH(JSON_EXTRACT(inparamjson , concat('$[*].',primarykey,'')));
	     SET @x1=0;
	     
	WHILE @x1  < @countpk DO
	select @x1 , @countpk;
	select CONCAT('JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(\'',inparamjson , '\',\'$[*].',primarykey,'\'),\'$[',@x1,']\'))');
	  
	  SET @pram =( SELECT  GROUP_CONCAT( IF(COLUMN_NAME=primarykey,CONCAT('\'',pkid,'\''),
	     CONCAT('JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(\'',inparamjson , '\',\'$[*].',COLUMN_NAME,'\'),\'$[',@x1,']\'))')
	     
			)
		)
		
	      FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = tblname AND table_schema =  DATABASE() AND COLUMN_NAME IN (SELECT DISTINCT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = tblname AND table_schema =  DATABASE() AND COLUMN_NAME <> (SELECT column_name
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE table_schema = DATABASE() AND table_name = tblname)));
	  SELECT @pram;
	  
	   SET @updatestmt1 = (SELECT CONCAT ('insert into ',tblname,'(', @colums1,') values(',@pram,')'));
	   SELECT @updatestmt1;
	  
	   
	PREPARE stmt1 FROM @updatestmt1; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1; 
	
	SELECT  GROUP_CONCAT( IF(COLUMN_NAME=primarykey,CONCAT('\'',pkid,'\''),
	     CONCAT('JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(\'',inparamjson , '\',\'$[*].',COLUMN_NAME,'\'),\'$[',@x1,']\'))')
	     
			)
		) as 'mine'
		
	      FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = tblname AND table_schema =  DATABASE() AND COLUMN_NAME IN (SELECT DISTINCT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = tblname AND table_schema =  DATABASE() AND COLUMN_NAME <> (SELECT column_name
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE table_schema = DATABASE() AND table_name = tblname));
		-- tbl_project_master Succesful insert
	     
	     -- get count of json array
	     set @x1 = @x1 + 1;
	  end while;  
	
	
     COMMIT;
     SET Isuccess = TRUE;
     SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
         'Error', Error,
         'Validation', Validation,
       'Controlid', Controlid));
     
       
       -- SELECT * FROM tbl_member_master WHERE STATUS='active';
       -- CALL proc_testone_selectjson(strjson);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_common_update` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_common_update` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_common_update`(    
    IN inparamjson longtext,  
    in tblname varchar(1000),
    in primarykey varchar(100),
    in pkid varchar(100),
    out outparam longtext
    )
label1:
BEGIN
	
	
	
	DECLARE errcount INT;
	DECLARE errno INT;
	DECLARE msg TEXT;
	DECLARE p TEXT;
		
	DECLARE Isuccess BOOLEAN;
	declare outparam1 json;
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
	
	 START TRANSACTION;
	SET Isuccess =FALSE;
	
	SET  Validation ='';
	SET Error ='';
	SET Controlid ='';
	
	
	-- CALL proc_runningid(prefix1,@p);
	 
	 -- SET @colums1=(SELECT  GROUP_CONCAT(COLUMN_NAME) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = tblname AND table_schema =  database() AND COLUMN_NAME IN (SELECT DISTINCT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = tblname AND table_schema =  database()));
	   -- SELECT @colums1;
	 
           SET @colums1=(SELECT  GROUP_CONCAT(if(COLUMN_NAME='modifieddate',concat(COLUMN_NAME,'=\'',now(),'\''),
	   concat(COLUMN_NAME,'=','JSON_UNQUOTE(JSON_EXTRACT(\'',inparamjson , '\',\'$[0].',COLUMN_NAME,'\'))'))
	   ) FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME <> primarykey and COLUMN_NAME <>'createdate' AND table_name = tblname AND table_schema =  database() AND COLUMN_NAME IN (SELECT DISTINCT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = tblname AND table_schema =  database()));
	   SELECT @colums1;
	 
	  
	  
	   SET @updatestmt1 = (SELECT CONCAT ('update ', tblname ,' set ',@colums1,' where ',primarykey,'=\'',pkid,'\''));
	   select @updatestmt1;
	  
	     PREPARE stmt1 FROM @updatestmt1; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1; 
		-- tbl_project_master Succesful insert
	     
	     -- get count of json array
	    
	
	
     COMMIT;
     SET Isuccess = TRUE;
     SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
         'Error', Error,
         'Validation', Validation,
       'Controlid', Controlid));
     
       
       -- SELECT * FROM tbl_member_master WHERE STATUS='active';
       -- CALL proc_testone_selectjson(strjson);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_common_ws` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_common_ws` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_common_ws`(IN procname VARCHAR(1000),in wsname varchar(1000),in nosofparams int)
BEGIN
	DECLARE inparams TEXT;
	declare inputvalues text;
	declare printinputvalues text;
	declare beginproctext text;
	declare inputquest text;
	
	
	SET @x1=0;
	set inparams='';
	set inputvalues='';
	set printinputvalues='';
	set inputquest='';
	WHILE @x1  < nosofparams DO
		IF @x1+1 = nosofparams THEN
		SET inparams = CONCAT(inparams,'@FormParam("input',@x1,'") String input',@x1);
		set inputvalues = concat(inputvalues,'input',@x1,'');
		SET printinputvalues =CONCAT(printinputvalues,'input',@x1);
		SET inputquest =CONCAT(inputquest,'?,');
		ELSE
		
		SET inparams = CONCAT(inparams,'@FormParam("input',@x1,'") String input',@x1 ,',');
		SET inputvalues = CONCAT(inputvalues,'input',@x1,',');
		SET printinputvalues =CONCAT(printinputvalues,'input',@x1,' + ');
		SET inputquest =CONCAT(inputquest,'?,');
		END IF;
		
		
		
		SET @x1=@x1+1;
	END WHILE;
	
	IF nosofparams IS NOT NULL AND nosofparams = 0 THEN
		SET nosofparams=1;
		SET inparams = CONCAT(inparams,'@FormParam("input0") String input0');
	END IF;
	
	SET beginproctext = CONCAT('@POST\n','@Path("',wsname,'")\n','@Produces(MediaType.APPLICATION_JSON)\n','public Response ',wsname,'(',inparams,',@Context HttpServletRequest request,@Context HttpServletResponse response){\n');
	set beginproctext =concat(beginproctext,'System.out.println("MyApp.',wsname,'()" + ',printinputvalues,');\n','String proccommand="CALL ',procname,'(',inputquest,'?,?)";\n','int[] types={Types.VARCHAR,Types.VARCHAR};\n');
	
	SET beginproctext =CONCAT(beginproctext,'Object[] inputvalues={',inputvalues,'};\n','String createSQLQuery;\n','String output="[]";\n','try {\n','ArrayList callprocforoutputparamsV2 = QuickUtil.callprocforoutputparamsV2(proccommand, inputvalues, types);\n','System.out.println("',wsname,' Result="+callprocforoutputparamsV2.toString());\n');
	SET beginproctext =CONCAT(beginproctext,'if(callprocforoutputparamsV2!=null && callprocforoutputparamsV2.size()>0){\n','if (callprocforoutputparamsV2.get(0) != null){\n','output=(String) callprocforoutputparamsV2.get(0);\n','}\n','}\n','}catch (SQLException e) {\n','e.printStackTrace();\n','} catch (Exception e) {\n','e.printStackTrace();\n','}\n','return Response.status(200).entity(output).build();\n','}\n');
	-- SELECT inparams;
	select beginproctext;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_common__blankjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_common__blankjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_common__blankjson`(in tblnamendwhere varchar(1000) ,out outparam longtext)
BEGIN
SET SESSION group_concat_max_len=10000000000000;
	SET outparam=(SELECT DISTINCT GROUP_CONCAT(CONCAT('', COLUMN_NAME,':\'\''))
	  FROM INFORMATION_SCHEMA.COLUMNS
	  WHERE table_name = tblnamendwhere AND table_schema = DATABASE());
	
	SET outparam = concat('{', outparam , '}');
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_createuploadfilename` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_createuploadfilename` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_createuploadfilename`(
    IN filename VARCHAR(1000),
    IN tblname VARCHAR(500),
    OUT outfilename VARCHAR(1000)
    )
BEGIN
	
	declare firstpart text;
	declare lastpart text;
	declare p text;
	
	call proc_runningid(tblname,p);
	set lastpart=(SELECT SUBSTRING(filename,LENGTH(filename)-3,4));   
	set firstpart=(SELECT SUBSTRING(filename,1,LENGTH(filename)-4));
	
	
	set outfilename = (select concat(firstpart,p,lastpart));
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_getkeywords_subcat_drpjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_getkeywords_subcat_drpjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_getkeywords_subcat_drpjson`(in subcatid varchar(100),out outparam json)
BEGIN
	call proc_common_drpjson('keysubcat_id','keysubcat_name','vw_subcat_keyword_details',CONCAT('subcat_id=\'',subcatid,'\''),outparam); -- SELECT * FROM vw_subcat_keyword_details
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_getskills_subcat_drpjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_getskills_subcat_drpjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_getskills_subcat_drpjson`(in subcatid varchar(100),out outparam json)
BEGIN
	call proc_common_drpjson('skill_id','skill_name','vw_skill_subcat_maincat_details',concat('subcat_id=\'',subcatid,'\''),outparam); -- SELECT * FROM vw_skill_subcat_maincat_details
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_membersession_validate` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_membersession_validate` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_membersession_validate`(in membersessionid varchar(100), out istrue boolean)
BEGIN
	set @memid = '';
	set @memid = (select ofcmembers_id from tbl_ofcmemsession_details where ofcmemsession_id=membersessionid);
	set istrue=false;
	if @memid is not null and @memid <> '' then
		SET istrue=true;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_member_changepassword` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_member_changepassword` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_member_changepassword`(
    IN membersessionid VARCHAR(100),
    in oldpassword varchar(100), 
    in newpassword varchar(100),
    out outparam json
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
	set @truesession = false;
	call proc_membersession_validate(membersessionid,@truesession);
	IF @truesession THEN
		-- SET istrue=TRUE;
		 
		 SET @memid = (SELECT ofcmembers_id FROM tbl_ofcmemsession_details WHERE ofcmemsession_id=membersessionid);
		 SET @memid = (SELECT ofcmembers_id FROM tbl_ofcmembers_master WHERE ofcmembers_id=@memid and ofcmembers_password=oldpassword); 
		 if @memid is null and @memid = '' then
			SET Error = 'In correct current password entered..!';
			SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
			'Error', Error,
			'Validation', Validation,
			'Controlid', Controlid));
			LEAVE label1;
		 else
			update tbl_ofcmembers_master set ofcmembers_password=newpassword where ofcmembers_id=@memid;
		 end if;
		 
	END IF;
	IF (@truesession = FALSE) THEN
		SET Error = 'Invalid session. Please login again...!';
		SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
			'Error', Error,
			'Validation', Validation,
			'Controlid', Controlid));
			
		leave label1;
	
	END IF;
	
	 COMMIT;
     SET Isuccess = TRUE;
     SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
         'Error', Error,
         'Validation', Validation,
       'Controlid', Controlid));
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_member_changesecurityquestion` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_member_changesecurityquestion` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_member_changesecurityquestion`(
    IN membersessionid VARCHAR(100),
    IN oldsecurityanswer VARCHAR(100), 
    in newsecurityid varchar(100),
    IN newsecurityanswer VARCHAR(100),
    out outparam json
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
	set @truesession = false;
	call proc_membersession_validate(membersessionid,@truesession);
	IF @truesession THEN
		-- SET istrue=TRUE;
		 
		 SET @memid = (SELECT ofcmembers_id FROM tbl_ofcmemsession_details WHERE ofcmemsession_id=membersessionid);
		 SET @securityid = (SELECT securityquest_id FROM tbl_membersecurity_answer WHERE ofcmembers_id=@memid); 
		 set @securitycount = 0;
		 
		 if @securityid is not null or @securityid <> '' then
			SET @securitycount = (SELECT count(securityquest_id) FROM tbl_membersecurity_answer WHERE securityquest_id=@securityid and ofcmembers_id=@memid and memsecurity_answer=oldsecurityanswer);
			if @securitycount is null or @securitycount = 0 then
				SET Error = 'Incorrect current answer. Please answer the it correctly in order to change the security question/answer!';
				SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
				'Error', Error,
				'Validation', Validation,
				'Controlid', Controlid));
				LEAVE label1;
			end if;
		 end if;
		 
		 delete from tbl_membersecurity_answer where ofcmembers_id=@memid;
			
			insert into tbl_membersecurity_answer 
			 (securityquest_id,memsecurity_answer,ofcmembers_id)
			 values(newsecurityid,newsecurityanswer,@memid); 
		
		 
	END IF;
	IF (@truesession = FALSE) THEN
		SET Error = 'Invalid session. Please login again...!';
		SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
			'Error', Error,
			'Validation', Validation,
			'Controlid', Controlid));
			
		leave label1;
	
	END IF;
	
	 COMMIT;
     SET Isuccess = TRUE;
     SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
         'Error', Error,
         'Validation', Validation,
       'Controlid', Controlid));
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_member_education` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_member_education` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_member_education`(
    IN membersessionid VARCHAR(100),
    IN inparam json, -- tbl_ofcmembereducation_details
        
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
			SET Error = 'In correct current password entered..!';
			SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
			'Error', Error,
			'Validation', Validation,
			'Controlid', Controlid));
			LEAVE label1;
		 ELSE
			CALL proc_runningid('MEDU',@p);
		 	INSERT INTO tbl_ofcmembereducation_details 
		 	(ofcmembereducation_id,ofcmembers_id,education_id,ofcmembereducation_title
		 	,ofcmembereducation_specilization,ofcmembereducation_startdate,ofcmembereducation_enddate
		 	,createdate,STATUS)
		 	VALUES(@p,
		 	@memid,
		 	JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].education_id')),
		 	JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcmembereducation_title')),
		 	JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcmembereducation_specilization')),
			JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcmembereducation_startdate')),
			JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcmembereducation_enddate')),
		 	NOW(),'active');
		 	
		 	-- JSON_UNQUOTE(JSON_EXTRACT(outparam , '$[0].Idupdated'))
			-- CALL proc_common_sub_insert(inparam2,'tbl_ofcmemberprojectskill_details','ofcmemmyproject_id',@p,@output2);
			-- JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].task_id'))
			
			
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
     SET Error = 'Saved Successfully';
     SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
         'Error', Error,
         'Validation', Validation,
       'Controlid', Controlid));
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_member_employment` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_member_employment` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_member_employment`(
    IN membersessionid VARCHAR(100),
    IN inparam json, -- tbl_ofcmemberemployment_details
    IN inparam2 json, -- tbl_skill_master
    IN fileuploadjson json,  
    OUT outparam json,
    out outfileupload json -- delete uncessary file returned from this parameter
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
	set @outparam1 = '';
	
	CALL proc_membersession_validate(membersessionid,@truesession);
	
	IF @truesession THEN
		-- SET istrue=TRUE;
		 
		 SET @memid = (SELECT ofcmembers_id FROM tbl_ofcmemsession_details WHERE ofcmemsession_id=membersessionid);
		 -- SET @memid = (SELECT ofcmembers_id FROM tbl_ofcmembers_master WHERE ofcmembers_id=@memid AND ofcmembers_password=oldpassword); 
		 IF @memid IS NULL AND @memid = '' THEN
			SET Error = 'In correct current password entered..!';
			SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
			'Error', Error,
			'Validation', Validation,
			'Controlid', Controlid));
			LEAVE label1;
		 ELSE
		 
			CALL proc_runningid('OMEMP',@p);
		 	-- call proc_common_update(inparam,'tbl_ofcmembers_master','ofcmembers_id',@memid,@outparam1);
		 	insert into tbl_ofcmemberemployment_details
		 	(ofcmememployment_id,ofcmembers_id,maincat_id,ofcmememployment_name,
		 	ofcmememployment_description,ofcmememployment_role,ofcmememployment_startdate,
		 	ofcmememployment_enddate,createdate,status)
		 	values
		 	(@p,@memid,JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].maincat_id')),
		 	JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcmememployment_name')),
		 	JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcmememployment_description')),
		 	JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcmememployment_role')),
		 	JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcmememployment_startdate')),
		 	JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcmememployment_enddate')),
		 	now(),'active'
		 	);
		 	
		 	
			set @outparam2 = '';
			
			insert into tbl_ofcmemberemploymentskill_details
			(skill_id,ofcmememployment_id)
			values(JSON_UNQUOTE(JSON_EXTRACT(inparam2 , '$[0].skill_id')),@p);
			
			CALL proc_uploadfile_master_updatejson('tbl_ofcmemberemployment_details',@p,fileuploadjson,@outparam2);
			
			SET outfileupload = @outparam2;
			
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
     set Error = 'Saved Successfully';
     SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
         'Error', Error,
         'Validation', Validation,
       'Controlid', Controlid));
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_member_experience` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_member_experience` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_member_experience`(
    IN membersessionid VARCHAR(100),
    IN inparam json, -- tbl_ofcmemberexperience_details
    IN inparam2 json, -- tbl_skill_master
    IN fileuploadjson json,  
    OUT outparam json,
    out outfileupload json -- delete uncessary file returned from this parameter
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
	set @outparam1 = '';
	
	CALL proc_membersession_validate(membersessionid,@truesession);
	
	IF @truesession THEN
		-- SET istrue=TRUE;
		 
		 SET @memid = (SELECT ofcmembers_id FROM tbl_ofcmemsession_details WHERE ofcmemsession_id=membersessionid);
		 -- SET @memid = (SELECT ofcmembers_id FROM tbl_ofcmembers_master WHERE ofcmembers_id=@memid AND ofcmembers_password=oldpassword); 
		 IF @memid IS NULL AND @memid = '' THEN
			SET Error = 'In correct current password entered..!';
			SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
			'Error', Error,
			'Validation', Validation,
			'Controlid', Controlid));
			LEAVE label1;
		 ELSE
		 
			CALL proc_runningid('OMEMP',@p);
		 	-- call proc_common_update(inparam,'tbl_ofcmembers_master','ofcmembers_id',@memid,@outparam1);
		 	insert into tbl_ofcmemberexperience_details
		 	(ofcmemexperience_id,ofcmembers_id,maincat_id,ofcmemexperience_name,
		 	ofcmemexperience_description,ofcmemexperience_role,ofcmemexperience_startdate,
		 	ofcmemexperience_enddate,createdate,status)
		 	values
		 	(@p,@memid,JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].maincat_id')),
		 	JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcmemexperience_name')),
		 	JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcmemexperience_description')),
		 	JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcmemexperience_role')),
		 	JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcmemexperience_startdate')),
		 	JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcmemexperience_enddate')),
		 	now(),'active'
		 	);
		 	
		 	
			set @outparam2 = '';
			
			insert into tbl_ofcmemberexperienceskill_details
			(skill_id,ofcmemexperience_id)
			values(JSON_UNQUOTE(JSON_EXTRACT(inparam2 , '$[0].skill_id')),@p);
			
			CALL proc_uploadfile_master_updatejson('tbl_ofcmemberexperience_details',@p,fileuploadjson,@outparam2);
			
			SET outfileupload = @outparam2;
			
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
     set Error = 'Saved Successfully';
     SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
         'Error', Error,
         'Validation', Validation,
       'Controlid', Controlid));
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_member_getall_latestprojectposted` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_member_getall_latestprojectposted` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_member_getall_latestprojectposted`(
    IN membersessionid VARCHAR(100),   
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
			SET Error = 'In correct current password entered..!';
			SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
			'Error', Error,
			'Validation', Validation,
			'Controlid', Controlid));
			LEAVE label1;
		 ELSE
		 
			set outparam=(SELECT CONCAT('[', (SELECT GROUP_CONCAT(CONCAT('{"ofcprojectpost_id"',':"',IF(ISNULL(a.ofcprojectpost_id),'-',a.ofcprojectpost_id),'","','subcat_id_fkprojectpost','":"',IF(ISNULL(a.subcat_id_fkprojectpost),'-',a.subcat_id_fkprojectpost),'","'
,'experience_id_fkprojectpost','":"',IF(ISNULL(a.experience_id_fkprojectpost),'-',a.experience_id_fkprojectpost),'",'
,'"','ofcprojectpost_budget','":"',IF(ISNULL(a.ofcprojectpost_budget),'-',a.ofcprojectpost_budget),'",'
,'"','ofcprojectpost_negotiable','":"',IF(ISNULL(a.ofcprojectpost_negotiable),'-',a.ofcprojectpost_negotiable),'",'
,'"','ofcprojectpost_title','":"',IF(ISNULL(a.ofcprojectpost_title),'-',a.ofcprojectpost_title),'",'
,'"','ofcprojectpost_description','":"',IF(ISNULL(a.ofcprojectpost_description),'-',a.ofcprojectpost_description),'",'
,'"','ofcprojectpost_timeframe','":"',IF(ISNULL(a.ofcprojectpost_timeframe),'-',a.ofcprojectpost_timeframe),'",'
,'"','ofcprojectpost_typepreference','":"',IF(ISNULL(a.ofcprojectpost_typepreference),'-',a.ofcprojectpost_typepreference),'",'
,'"','ofcprojectpost_kind','":"',IF(ISNULL(a.ofcprojectpost_kind),'-',a.ofcprojectpost_kind),'",'
,'"','ofcprojectpost_budgetamount','":"',IF(ISNULL(a.ofcprojectpost_budgetamount),'-',a.ofcprojectpost_budgetamount),'",'
,'"','ofcprojectpost_commissionpercentage','":"',IF(ISNULL(a.ofcprojectpost_commissionpercentage),'-',a.ofcprojectpost_commissionpercentage),'",'
,'"','ofcprojectpost_ofccommission','":"',IF(ISNULL(a.ofcprojectpost_ofccommission),'-',a.ofcprojectpost_ofccommission),'",'
,'"','ofcprojectpost_estimatestartdate','":"',IF(ISNULL(a.ofcprojectpost_estimatestartdate),'-',a.ofcprojectpost_estimatestartdate),'",'
,'"','ofcprojectpost_startdate','":"',IF(ISNULL(a.ofcprojectpost_startdate),'-',a.ofcprojectpost_startdate),'",'
,'"','ofcprojectpost_enddate','":"',IF(ISNULL(a.ofcprojectpost_enddate),'-',a.ofcprojectpost_enddate),'",'
,'"','ofcprojectpost_invitefreelancers','":"',IF(ISNULL(a.ofcprojectpost_invitefreelancers),'-',a.ofcprojectpost_invitefreelancers),'",'
,'"','ofcprojectpost_public','":"',IF(ISNULL(a.ofcprojectpost_public),'-',a.ofcprojectpost_public),'",'
,'"','country_id_fkprojectpost','":"',IF(ISNULL(a.country_id_fkprojectpost),'-',a.country_id_fkprojectpost),'",'
,'"','language_id_fkprojectpost','":"',IF(ISNULL(a.language_id_fkprojectpost),'-',a.language_id_fkprojectpost),'",'
,'"','ofcprojectpost_projectamount','":"',IF(ISNULL(a.ofcprojectpost_projectamount),'-',a.ofcprojectpost_projectamount),'",'
,'"','ofcprojectpost_advanceamount','":"',IF(ISNULL(a.ofcprojectpost_advanceamount),'-',a.ofcprojectpost_advanceamount),'",'
,'"','ofcprojectpost_finalpaidamount','":"',IF(ISNULL(a.ofcprojectpost_finalpaidamount),'-',a.ofcprojectpost_finalpaidamount),'",'
,'"','ofcprojectpost_ispaymenttermsagreed','":"',IF(ISNULL(a.ofcprojectpost_ispaymenttermsagreed),'-',a.ofcprojectpost_ispaymenttermsagreed),'",'
,'"','ofcprojectpost_ispaid','":"',IF(ISNULL(a.ofcprojectpost_ispaid),'-',a.ofcprojectpost_ispaid),'",'
,'"','ofcprojectpost_iscompleted','":"',IF(ISNULL(a.ofcprojectpost_iscompleted),'-',a.ofcprojectpost_iscompleted),'",'
,'"','ofcprojectpost_delayed','":"',IF(ISNULL(a.ofcprojectpost_delayed),'-',a.ofcprojectpost_delayed),'",'
,'"','ofcprojectpost_istermsaggreedbyme','":"',IF(ISNULL(a.ofcprojectpost_istermsaggreedbyme),'-',a.ofcprojectpost_istermsaggreedbyme),'",'
,'"','ofcprojectpost_istermsaggreedbyfreelancer','":"',IF(ISNULL(a.ofcprojectpost_istermsaggreedbyfreelancer),'-',a.ofcprojectpost_istermsaggreedbyfreelancer),'",'
,'"','ofcprojectpost_isdispute','":"',IF(ISNULL(a.ofcprojectpost_isdispute),'-',a.ofcprojectpost_isdispute),'",'
,'"','ofcprojectpost_isrefundrequested','":"',IF(ISNULL(a.ofcprojectpost_isrefundrequested),'-',a.ofcprojectpost_isrefundrequested),'",'
,'"','ofcprojectpost_isrefunded','":"',IF(ISNULL(a.ofcprojectpost_isrefunded),'-',a.ofcprojectpost_isrefunded),'",'
,'"','ofcprojectpost_isdisputeresolved','":"',IF(ISNULL(a.ofcprojectpost_isdisputeresolved),'-',a.ofcprojectpost_isdisputeresolved),'",'
,'"','createdate','":"',IF(ISNULL(a.createdate),'-',a.createdate),'",'
,'"','modifieddate','":"',IF(ISNULL(a.modifieddate),'-',a.modifieddate),'",'
,'"','status','":"',IF(ISNULL(a.status),'-',a.status),'"'
,',"filearr":'
)
 ,(SELECT CONCAT('[',GROUP_CONCAT( json_object('skill_id',x2.skill_id,'skill_name',x2.skill_name)) ,']}')
FROM tbl_ofcprojectpost_skill x1, tbl_skill_master x2 WHERE x1.ofcprojectpost_id=a.ofcprojectpost_id AND x1.skill_id = x2.skill_id))
  FROM tbl_ofcprojectpost_details a, tbl_ofcmembers_master c,tbl_experience_master d WHERE a.ofcmembers_id_fkprojectpost=c.ofcmembers_id AND a.experience_id_fkprojectpost = d.experience_id ORDER BY a.createdate DESC)
  ,']')
  );
			
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
     -- SET Error = 'Saved Successfully';
     -- SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
        --  'Error', Error,
         -- 'Validation', Validation,
       -- 'Controlid', Controlid));
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_member_getall_latestprojectpostedById` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_member_getall_latestprojectpostedById` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_member_getall_latestprojectpostedById`(
    IN membersessionid VARCHAR(100),   
    IN projectpostid VARCHAR(100),
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
			SET Error = 'In correct current password entered..!';
			SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
			'Error', Error,
			'Validation', Validation,
			'Controlid', Controlid));
			LEAVE label1;
		 ELSE
		 
			SET outparam=(SELECT CONCAT('[', (SELECT GROUP_CONCAT(CONCAT('{"ofcprojectpost_id"',':"',IF(ISNULL(a.ofcprojectpost_id),'-',a.ofcprojectpost_id),'","','subcat_id_fkprojectpost','":"',IF(ISNULL(a.subcat_id_fkprojectpost),'-',a.subcat_id_fkprojectpost),'","'
,'experience_id_fkprojectpost','":"',IF(ISNULL(a.experience_id_fkprojectpost),'-',a.experience_id_fkprojectpost),'",'
,'"','ofcprojectpost_budget','":"',IF(ISNULL(a.ofcprojectpost_budget),'-',a.ofcprojectpost_budget),'",'
,'"','ofcprojectpost_negotiable','":"',IF(ISNULL(a.ofcprojectpost_negotiable),'-',a.ofcprojectpost_negotiable),'",'
,'"','ofcprojectpost_title','":"',IF(ISNULL(a.ofcprojectpost_title),'-',a.ofcprojectpost_title),'",'
,'"','ofcprojectpost_description','":"',IF(ISNULL(a.ofcprojectpost_description),'-',a.ofcprojectpost_description),'",'
,'"','ofcprojectpost_timeframe','":"',IF(ISNULL(a.ofcprojectpost_timeframe),'-',a.ofcprojectpost_timeframe),'",'
,'"','ofcprojectpost_typepreference','":"',IF(ISNULL(a.ofcprojectpost_typepreference),'-',a.ofcprojectpost_typepreference),'",'
,'"','ofcprojectpost_kind','":"',IF(ISNULL(a.ofcprojectpost_kind),'-',a.ofcprojectpost_kind),'",'
,'"','ofcprojectpost_budgetamount','":"',IF(ISNULL(a.ofcprojectpost_budgetamount),'-',a.ofcprojectpost_budgetamount),'",'
,'"','ofcprojectpost_commissionpercentage','":"',IF(ISNULL(a.ofcprojectpost_commissionpercentage),'-',a.ofcprojectpost_commissionpercentage),'",'
,'"','ofcprojectpost_ofccommission','":"',IF(ISNULL(a.ofcprojectpost_ofccommission),'-',a.ofcprojectpost_ofccommission),'",'
,'"','ofcprojectpost_estimatestartdate','":"',IF(ISNULL(a.ofcprojectpost_estimatestartdate),'-',a.ofcprojectpost_estimatestartdate),'",'
,'"','ofcprojectpost_startdate','":"',IF(ISNULL(a.ofcprojectpost_startdate),'-',a.ofcprojectpost_startdate),'",'
,'"','ofcprojectpost_enddate','":"',IF(ISNULL(a.ofcprojectpost_enddate),'-',a.ofcprojectpost_enddate),'",'
,'"','ofcprojectpost_invitefreelancers','":"',IF(ISNULL(a.ofcprojectpost_invitefreelancers),'-',a.ofcprojectpost_invitefreelancers),'",'
,'"','ofcprojectpost_public','":"',IF(ISNULL(a.ofcprojectpost_public),'-',a.ofcprojectpost_public),'",'
,'"','country_id_fkprojectpost','":"',IF(ISNULL(a.country_id_fkprojectpost),'-',a.country_id_fkprojectpost),'",'
,'"','language_id_fkprojectpost','":"',IF(ISNULL(a.language_id_fkprojectpost),'-',a.language_id_fkprojectpost),'",'
,'"','ofcprojectpost_projectamount','":"',IF(ISNULL(a.ofcprojectpost_projectamount),'-',a.ofcprojectpost_projectamount),'",'
,'"','ofcprojectpost_advanceamount','":"',IF(ISNULL(a.ofcprojectpost_advanceamount),'-',a.ofcprojectpost_advanceamount),'",'
,'"','ofcprojectpost_finalpaidamount','":"',IF(ISNULL(a.ofcprojectpost_finalpaidamount),'-',a.ofcprojectpost_finalpaidamount),'",'
,'"','ofcprojectpost_ispaymenttermsagreed','":"',IF(ISNULL(a.ofcprojectpost_ispaymenttermsagreed),'-',a.ofcprojectpost_ispaymenttermsagreed),'",'
,'"','ofcprojectpost_ispaid','":"',IF(ISNULL(a.ofcprojectpost_ispaid),'-',a.ofcprojectpost_ispaid),'",'
,'"','ofcprojectpost_iscompleted','":"',IF(ISNULL(a.ofcprojectpost_iscompleted),'-',a.ofcprojectpost_iscompleted),'",'
,'"','ofcprojectpost_delayed','":"',IF(ISNULL(a.ofcprojectpost_delayed),'-',a.ofcprojectpost_delayed),'",'
,'"','ofcprojectpost_istermsaggreedbyme','":"',IF(ISNULL(a.ofcprojectpost_istermsaggreedbyme),'-',a.ofcprojectpost_istermsaggreedbyme),'",'
,'"','ofcprojectpost_istermsaggreedbyfreelancer','":"',IF(ISNULL(a.ofcprojectpost_istermsaggreedbyfreelancer),'-',a.ofcprojectpost_istermsaggreedbyfreelancer),'",'
,'"','ofcprojectpost_isdispute','":"',IF(ISNULL(a.ofcprojectpost_isdispute),'-',a.ofcprojectpost_isdispute),'",'
,'"','ofcprojectpost_isrefundrequested','":"',IF(ISNULL(a.ofcprojectpost_isrefundrequested),'-',a.ofcprojectpost_isrefundrequested),'",'
,'"','ofcprojectpost_isrefunded','":"',IF(ISNULL(a.ofcprojectpost_isrefunded),'-',a.ofcprojectpost_isrefunded),'",'
,'"','ofcprojectpost_isdisputeresolved','":"',IF(ISNULL(a.ofcprojectpost_isdisputeresolved),'-',a.ofcprojectpost_isdisputeresolved),'",'
,'"','createdate','":"',IF(ISNULL(a.createdate),'-',a.createdate),'",'
,'"','modifieddate','":"',IF(ISNULL(a.modifieddate),'-',a.modifieddate),'",'
,'"','status','":"',IF(ISNULL(a.status),'-',a.status),'"'
,',"filearr":'
)
 ,(SELECT CONCAT('[',GROUP_CONCAT( json_object('skill_id',x2.skill_id,'skill_name',x2.skill_name)) ,']}')
FROM tbl_ofcprojectpost_skill x1, tbl_skill_master x2 WHERE x1.ofcprojectpost_id=a.ofcprojectpost_id AND x1.skill_id = x2.skill_id))
  FROM tbl_ofcprojectpost_details a, tbl_ofcmembers_master c,tbl_experience_master d WHERE a.ofcmembers_id_fkprojectpost=c.ofcmembers_id AND a.experience_id_fkprojectpost = d.experience_id AND a.ofcprojectpost_id=projectpostid ORDER BY a.createdate DESC)
  ,']')
  );
			
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
     -- SET Error = 'Saved Successfully';
     -- SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
        --  'Error', Error,
         -- 'Validation', Validation,
       -- 'Controlid', Controlid));
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_member_getall_latestprojectpostedbysessionid` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_member_getall_latestprojectpostedbysessionid` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_member_getall_latestprojectpostedbysessionid`(
    IN membersessionid VARCHAR(100),   
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
			SET Error = 'In correct current password entered..!';
			SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
			'Error', Error,
			'Validation', Validation,
			'Controlid', Controlid));
			LEAVE label1;
		 ELSE
		 
			set outparam=(SELECT CONCAT('[', (SELECT GROUP_CONCAT(CONCAT('{"ofcprojectpost_id"',':"',IF(ISNULL(a.ofcprojectpost_id),'-',a.ofcprojectpost_id),'","','subcat_id_fkprojectpost','":"',IF(ISNULL(a.subcat_id_fkprojectpost),'-',a.subcat_id_fkprojectpost),'","'
,'experience_id_fkprojectpost','":"',IF(ISNULL(a.experience_id_fkprojectpost),'-',a.experience_id_fkprojectpost),'",'
,'"','ofcprojectpost_budget','":"',IF(ISNULL(a.ofcprojectpost_budget),'-',a.ofcprojectpost_budget),'",'
,'"','ofcprojectpost_negotiable','":"',IF(ISNULL(a.ofcprojectpost_negotiable),'-',a.ofcprojectpost_negotiable),'",'
,'"','ofcprojectpost_title','":"',IF(ISNULL(a.ofcprojectpost_title),'-',a.ofcprojectpost_title),'",'
,'"','ofcprojectpost_description','":"',IF(ISNULL(a.ofcprojectpost_description),'-',a.ofcprojectpost_description),'",'
,'"','ofcprojectpost_timeframe','":"',IF(ISNULL(a.ofcprojectpost_timeframe),'-',a.ofcprojectpost_timeframe),'",'
,'"','ofcprojectpost_typepreference','":"',IF(ISNULL(a.ofcprojectpost_typepreference),'-',a.ofcprojectpost_typepreference),'",'
,'"','ofcprojectpost_kind','":"',IF(ISNULL(a.ofcprojectpost_kind),'-',a.ofcprojectpost_kind),'",'
,'"','ofcprojectpost_budgetamount','":"',IF(ISNULL(a.ofcprojectpost_budgetamount),'-',a.ofcprojectpost_budgetamount),'",'
,'"','ofcprojectpost_commissionpercentage','":"',IF(ISNULL(a.ofcprojectpost_commissionpercentage),'-',a.ofcprojectpost_commissionpercentage),'",'
,'"','ofcprojectpost_ofccommission','":"',IF(ISNULL(a.ofcprojectpost_ofccommission),'-',a.ofcprojectpost_ofccommission),'",'
,'"','ofcprojectpost_estimatestartdate','":"',IF(ISNULL(a.ofcprojectpost_estimatestartdate),'-',a.ofcprojectpost_estimatestartdate),'",'
,'"','ofcprojectpost_startdate','":"',IF(ISNULL(a.ofcprojectpost_startdate),'-',a.ofcprojectpost_startdate),'",'
,'"','ofcprojectpost_enddate','":"',IF(ISNULL(a.ofcprojectpost_enddate),'-',a.ofcprojectpost_enddate),'",'
,'"','ofcprojectpost_invitefreelancers','":"',IF(ISNULL(a.ofcprojectpost_invitefreelancers),'-',a.ofcprojectpost_invitefreelancers),'",'
,'"','ofcprojectpost_public','":"',IF(ISNULL(a.ofcprojectpost_public),'-',a.ofcprojectpost_public),'",'
,'"','country_id_fkprojectpost','":"',IF(ISNULL(a.country_id_fkprojectpost),'-',a.country_id_fkprojectpost),'",'
,'"','language_id_fkprojectpost','":"',IF(ISNULL(a.language_id_fkprojectpost),'-',a.language_id_fkprojectpost),'",'
,'"','ofcprojectpost_projectamount','":"',IF(ISNULL(a.ofcprojectpost_projectamount),'-',a.ofcprojectpost_projectamount),'",'
,'"','ofcprojectpost_advanceamount','":"',IF(ISNULL(a.ofcprojectpost_advanceamount),'-',a.ofcprojectpost_advanceamount),'",'
,'"','ofcprojectpost_finalpaidamount','":"',IF(ISNULL(a.ofcprojectpost_finalpaidamount),'-',a.ofcprojectpost_finalpaidamount),'",'
,'"','ofcprojectpost_ispaymenttermsagreed','":"',IF(ISNULL(a.ofcprojectpost_ispaymenttermsagreed),'-',a.ofcprojectpost_ispaymenttermsagreed),'",'
,'"','ofcprojectpost_ispaid','":"',IF(ISNULL(a.ofcprojectpost_ispaid),'-',a.ofcprojectpost_ispaid),'",'
,'"','ofcprojectpost_iscompleted','":"',IF(ISNULL(a.ofcprojectpost_iscompleted),'-',a.ofcprojectpost_iscompleted),'",'
,'"','ofcprojectpost_delayed','":"',IF(ISNULL(a.ofcprojectpost_delayed),'-',a.ofcprojectpost_delayed),'",'
,'"','ofcprojectpost_istermsaggreedbyme','":"',IF(ISNULL(a.ofcprojectpost_istermsaggreedbyme),'-',a.ofcprojectpost_istermsaggreedbyme),'",'
,'"','ofcprojectpost_istermsaggreedbyfreelancer','":"',IF(ISNULL(a.ofcprojectpost_istermsaggreedbyfreelancer),'-',a.ofcprojectpost_istermsaggreedbyfreelancer),'",'
,'"','ofcprojectpost_isdispute','":"',IF(ISNULL(a.ofcprojectpost_isdispute),'-',a.ofcprojectpost_isdispute),'",'
,'"','ofcprojectpost_isrefundrequested','":"',IF(ISNULL(a.ofcprojectpost_isrefundrequested),'-',a.ofcprojectpost_isrefundrequested),'",'
,'"','ofcprojectpost_isrefunded','":"',IF(ISNULL(a.ofcprojectpost_isrefunded),'-',a.ofcprojectpost_isrefunded),'",'
,'"','ofcprojectpost_isdisputeresolved','":"',IF(ISNULL(a.ofcprojectpost_isdisputeresolved),'-',a.ofcprojectpost_isdisputeresolved),'",'
,'"','createdate','":"',IF(ISNULL(a.createdate),'-',a.createdate),'",'
,'"','modifieddate','":"',IF(ISNULL(a.modifieddate),'-',a.modifieddate),'",'
,'"','status','":"',IF(ISNULL(a.status),'-',a.status),'"'
,',"filearr":'
)
 ,(SELECT CONCAT('[',GROUP_CONCAT( json_object('skill_id',x2.skill_id,'skill_name',x2.skill_name)) ,']}')
FROM tbl_ofcprojectpost_skill x1, tbl_skill_master x2 WHERE x1.ofcprojectpost_id=a.ofcprojectpost_id AND x1.skill_id = x2.skill_id))
  FROM tbl_ofcprojectpost_details a, tbl_ofcmembers_master c,tbl_experience_master d WHERE a.ofcmembers_id_fkprojectpost=c.ofcmembers_id AND a.experience_id_fkprojectpost = d.experience_id and a.ofcmembers_id_fkprojectpost=@memid ORDER BY a.createdate DESC)
  ,']')
  );
			
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
     -- SET Error = 'Saved Successfully';
     -- SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
        --  'Error', Error,
         -- 'Validation', Validation,
       -- 'Controlid', Controlid));
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_member_get_projectposted_byprojectpostid` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_member_get_projectposted_byprojectpostid` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_member_get_projectposted_byprojectpostid`(
    IN membersessionid VARCHAR(100),   
    in ofcprojectpostid varchar(100),
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
			SET Error = 'In correct current password entered..!';
			SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
			'Error', Error,
			'Validation', Validation,
			'Controlid', Controlid));
			LEAVE label1;
		 ELSE
		 
			set outparam=(SELECT CONCAT('[', (SELECT GROUP_CONCAT(CONCAT('{','"ofcsubmitproposal_id":"',IF(ISNULL(maina.ofcsubmitproposal_id),'-',maina.ofcsubmitproposal_id),'",','"ofcprojectpost_id_fksubmitproposal":"',IF(ISNULL(maina.ofcprojectpost_id_fksubmitproposal),'-',maina.ofcprojectpost_id_fksubmitproposal),'",','"ofcmembers_id_fksubmitproposal":"',IF(ISNULL(maina.ofcmembers_id_fksubmitproposal),'-',maina.ofcmembers_id_fksubmitproposal),'",','"ofcsubmitproposal_coverletter":"',IF(ISNULL(maina.ofcsubmitproposal_coverletter),'-',maina.ofcsubmitproposal_coverletter),'",','"ofcsubmitproposal_budget":"',IF(ISNULL(maina.ofcsubmitproposal_budget),'-',maina.ofcsubmitproposal_budget),'",','"ofcsubmitproposal_negotiable":"',IF(ISNULL(maina.ofcsubmitproposal_negotiable),'-',maina.ofcsubmitproposal_negotiable),'",','"ofcsubmitproposal_commissionpercentage":"',IF(ISNULL(maina.ofcsubmitproposal_commissionpercentage),'-',maina.ofcsubmitproposal_commissionpercentage),'",','"ofcsubmitproposal_commissionamount":"',IF(ISNULL(maina.ofcsubmitproposal_commissionamount),'-',maina.ofcsubmitproposal_commissionamount),'",','"ofcsubmitproposal_finalamount":"',IF(ISNULL(maina.ofcsubmitproposal_finalamount),'-',maina.ofcsubmitproposal_finalamount),'",','"ofcsubmitproposal_timeframe":"',IF(ISNULL(maina.ofcsubmitproposal_timeframe),'-',maina.ofcsubmitproposal_timeframe),'",','"ofcsubmitproposal_availability":"',IF(ISNULL(maina.ofcsubmitproposal_availability),'-',maina.ofcsubmitproposal_availability),'",','"ofcsubmitproposal_status":"',IF(ISNULL(maina.ofcsubmitproposal_status),'-',maina.ofcsubmitproposal_status),'",','"ofcsubmitproposal_remarks":"',IF(ISNULL(maina.ofcsubmitproposal_remarks),'-',maina.ofcsubmitproposal_remarks),'",','"ofcsubmitproposal_terms":"',IF(ISNULL(maina.ofcsubmitproposal_terms),'-',maina.ofcsubmitproposal_terms),'",','"ofcsubmitproposal_estimatestartdate":"',IF(ISNULL(maina.ofcsubmitproposal_estimatestartdate),'-',UNIX_TIMESTAMP(maina.ofcsubmitproposal_estimatestartdate)*1000),'",','"ofcsubmitproposal_startdate":"',IF(ISNULL(maina.ofcsubmitproposal_startdate),'-',UNIX_TIMESTAMP(maina.ofcsubmitproposal_startdate)*1000),'",','"ofcsubmitproposal_enddate":"',IF(ISNULL(maina.ofcsubmitproposal_enddate),'-',UNIX_TIMESTAMP(maina.ofcsubmitproposal_enddate)*1000),'",','"ofcsubmitproposal_estimatedays":"',IF(ISNULL(maina.ofcsubmitproposal_estimatedays),'-',maina.ofcsubmitproposal_estimatedays),'",','"ofcsubmitproposal_estimatedhoursindays":"',IF(ISNULL(maina.ofcsubmitproposal_estimatedhoursindays),'-',maina.ofcsubmitproposal_estimatedhoursindays),'",','"ofcsubmitproposal_reportabusebyemployeer":"',IF(ISNULL(maina.ofcsubmitproposal_reportabusebyemployeer),'-',maina.ofcsubmitproposal_reportabusebyemployeer),'",','"ofcsubmitproposal_reportabusebyfreelancer":"',IF(ISNULL(maina.ofcsubmitproposal_reportabusebyfreelancer),'-',maina.ofcsubmitproposal_reportabusebyfreelancer),'",','"ofcsubmitproposal_proposalacceptdate":"',IF(ISNULL(maina.ofcsubmitproposal_proposalacceptdate),'-',UNIX_TIMESTAMP(maina.ofcsubmitproposal_proposalacceptdate)*1000),'",','"ofcsubmitproposal_proposalrejectdate":"',IF(ISNULL(maina.ofcsubmitproposal_proposalrejectdate),'-',UNIX_TIMESTAMP(maina.ofcsubmitproposal_proposalrejectdate)*1000),'",','"ofcsubmitproposal_completeddate":"',IF(ISNULL(maina.ofcsubmitproposal_completeddate),'-',UNIX_TIMESTAMP(maina.ofcsubmitproposal_completeddate)*1000),'",','"ofcsubmitproposal_iscompletedbyemployeer":"',IF(ISNULL(maina.ofcsubmitproposal_iscompletedbyemployeer),'-',maina.ofcsubmitproposal_iscompletedbyemployeer),'",','"ofcsubmitproposal_iscompletedbyfreelancer":"',IF(ISNULL(maina.ofcsubmitproposal_iscompletedbyfreelancer),'-',maina.ofcsubmitproposal_iscompletedbyfreelancer),'",','"ofcsubmitproposal_workstatus":"',IF(ISNULL(maina.ofcsubmitproposal_workstatus),'-',maina.ofcsubmitproposal_workstatus),'",','"createdate":"',IF(ISNULL(maina.createdate),'-',UNIX_TIMESTAMP(maina.createdate)*1000),'",','"modifieddate":"',IF(ISNULL(maina.modifieddate),'-',UNIX_TIMESTAMP(maina.modifieddate)*1000),'",','"status":"',IF(ISNULL(maina.status),'-',maina.status),'",','"questansarr":',(SELECT CONCAT('[',GROUP_CONCAT( json_object('ofcsubmitproposalquest_id',sub0.ofcsubmitproposalquest_id,'ofcsubmitproposal_id_ofcsubmitproposalquest',sub0.ofcsubmitproposal_id_ofcsubmitproposalquest,'ofcsubmitproposalquest_question',sub0.ofcsubmitproposalquest_question,'ofcsubmitproposalquest_answer',sub0.ofcsubmitproposalquest_answer)) ,'],')FROM tbl_ofcsubmitproposal_details main0, tbl_ofcsubmitproposal_questionanswers sub0 WHERE main0.ofcsubmitproposal_id=sub0.ofcsubmitproposal_id_ofcsubmitproposalquest AND sub0.ofcsubmitproposalquest_id = sub0.ofcsubmitproposalquest_id),'"termsarr":',(SELECT CONCAT('[',GROUP_CONCAT( json_object('ofcsubmitproposalterms_id',sub1.ofcsubmitproposalterms_id,'ofcsubmitproposal_id_fkterms',sub1.ofcsubmitproposal_id_fkterms,'ofcsubmitproposalterms_terms',sub1.ofcsubmitproposalterms_terms,'ofcsubmitproposalterms_agreedbyemployer',sub1.ofcsubmitproposalterms_agreedbyemployer,'ofcsubmitproposalterms_agreedbyemployee',sub1.ofcsubmitproposalterms_agreedbyemployee,'createdate',UNIX_TIMESTAMP(sub1.createdate)*1000,'modifieddate',UNIX_TIMESTAMP(sub1.modifieddate)*1000,'status',sub1.status)) ,'],')FROM tbl_ofcsubmitproposal_details main1, tbl_ofcsubmitproposal_terms sub1 WHERE main1.ofcsubmitproposal_id=sub1.ofcsubmitproposal_id_fkterms AND sub1.ofcsubmitproposalterms_id = sub1.ofcsubmitproposalterms_id)),'"skillsarr":',(SELECT CONCAT('[',GROUP_CONCAT( json_object('ofcmemberskill_id',sub2.ofcmemberskill_id,'skill_id',sub2.skill_id,'ofcmembers_id',sub2.ofcmembers_id,'createdate',UNIX_TIMESTAMP(sub2.createdate)*1000,'modifieddate',UNIX_TIMESTAMP(sub2.modifieddate)*1000,'status',sub2.status)) ,']}')FROM tbl_ofcsubmitproposal_details main2, tbl_ofcmemberskill_details sub2 WHERE main2.ofcsubmitproposal_id=sub2.ofcmembers_id AND sub2.ofcmemberskill_id = sub2.ofcmemberskill_id))FROM tbl_ofcsubmitproposal_details maina WHERE maina.ofcsubmitproposal_id=maina.ofcsubmitproposal_id and maina.ofcprojectpost_id_fksubmitproposal=ofcprojectpostid ),']')
  );
			
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
     -- SET Error = 'Saved Successfully';
     -- SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
        --  'Error', Error,
         -- 'Validation', Validation,
       -- 'Controlid', Controlid));
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_member_login` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_member_login` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_member_login`(in username varchar(50), in passwordin varchar(50) , out outparam json)
BEGIN
	CALL proc_common_selectjson('tbl_member_master',concat(' username=\'',username,'\' AND PASSWORD=\'',passwordin,'\''),@a);
	-- SELECT @a;
	if @a is null then
		set @a = '[]';
	end if; 
	set outparam =  @a;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_member_myprofile` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_member_myprofile` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_member_myprofile`(
    IN membersessionid VARCHAR(100),
    IN inparam json, -- tbl_ofcmembers_master
    IN inparam2 json, -- tbl_skill_master
    IN fileuploadjson json,  
    OUT outparam json,
    out outfileupload json -- delete uncessary file returned from this parameter
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
	set @outparam1 = '';
	
	CALL proc_membersession_validate(membersessionid,@truesession);
	
	IF @truesession THEN
		-- SET istrue=TRUE;
		 
		 SET @memid = (SELECT ofcmembers_id FROM tbl_ofcmemsession_details WHERE ofcmemsession_id=membersessionid);
		 -- SET @memid = (SELECT ofcmembers_id FROM tbl_ofcmembers_master WHERE ofcmembers_id=@memid AND ofcmembers_password=oldpassword); 
		 IF @memid IS NULL AND @memid = '' THEN
			SET Error = 'In correct current password entered..!';
			SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
			'Error', Error,
			'Validation', Validation,
			'Controlid', Controlid));
			LEAVE label1;
		 ELSE
		 
		 	-- call proc_common_update(inparam,'tbl_ofcmembers_master','ofcmembers_id',@memid,@outparam1);
		 	update tbl_ofcmembers_master
		 	set
		 	ofcmembers_displayname=JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcmembers_displayname')),
		 	ofcmembers_description=JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcmembers_description')),
		 	ofcmembers_experiencelevel=JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcmembers_experiencelevel'))
		 	where ofcmembers_id = @memid;
		 	-- JSON_UNQUOTE(JSON_EXTRACT(outparam , '$[0].Idupdated'))
			-- call proc_common_sub_insert(inparam2,'tbl_ofcmemberskill_details','ofcmembers_id',@memid,@output2);
			-- JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].task_id'))
			set @outparam2 = '';
			
			insert into tbl_ofcmemberskill_details
			(skill_id,ofcmembers_id,createdate,status)
			values(JSON_UNQUOTE(JSON_EXTRACT(inparam2 , '$[0].skill_id')),@memid,now(),'active');
			
			CALL proc_uploadfile_master_updatejson('tbl_ofcmembers_master',@memid,fileuploadjson,@outparam2);
			
			SET outfileupload = @outparam2;
			
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
     set Error = 'Saved Successfully';
     SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
         'Error', Error,
         'Validation', Validation,
       'Controlid', Controlid));
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_member_myproject` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_member_myproject` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_member_myproject`(
    IN membersessionid VARCHAR(100),
    IN inparam json, -- tbl_ofcmembermyproject_details
    IN inparam2 json, -- tbl_skill_master
    IN fileuploadjson json,  
    OUT outparam json,
    OUT outfileupload json -- delete uncessary file returned from this parameter
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
			SET Error = 'In correct current password entered..!';
			SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
			'Error', Error,
			'Validation', Validation,
			'Controlid', Controlid));
			LEAVE label1;
		 ELSE
			CALL proc_runningid('MMYPR',@p);
		 	insert into tbl_ofcmembermyproject_details 
		 	(ofcmemmyproject_id,maincat_id,ofcmembers_id,ofcmemmyproject_title,ofcmemmyproject_url,ofcmemmyproject_description,
		 	createdate,status)
		 	values(@p,
		 	JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].maincat_id')),
		 	@memid,
		 	JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcmemmyproject_title')),
		 	JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcmemmyproject_url')),
		 	JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcmemmyproject_description')),now(),'active');
		 	
		 	-- JSON_UNQUOTE(JSON_EXTRACT(outparam , '$[0].Idupdated'))
			-- CALL proc_common_sub_insert(inparam2,'tbl_ofcmemberprojectskill_details','ofcmemmyproject_id',@p,@output2);
			-- JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].task_id'))
			SET @outparam2 = '';
			insert into tbl_ofcmemberprojectskill_details
			(ofcmemmyproject_id,skill_id)
			values(@p,JSON_UNQUOTE(JSON_EXTRACT(inparam2 , '$[0].skill_id')));
			CALL proc_uploadfile_master_updatejson('tbl_ofcmembermyproject_details',@p,fileuploadjson,@outparam2);
			SET outfileupload = @outparam2;
			
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
     SET Error = 'Saved Successfully';
     SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
         'Error', Error,
         'Validation', Validation,
       'Controlid', Controlid));
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_member_myproject_get` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_member_myproject_get` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_member_myproject_get`(
    IN membersessionid VARCHAR(100),
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
			SET Error = 'In correct current password entered..!';
			SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
			'Error', Error,
			'Validation', Validation,
			'Controlid', Controlid));
			LEAVE label1;
		 ELSE
			
			
			call proc_common_selectjson('tbl_ofcprojectpost_details','',outparam);
			
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
     SET Error = 'Saved Successfully';
     SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
         'Error', Error,
         'Validation', Validation,
       'Controlid', Controlid));
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_member_ofcprojectpost` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_member_ofcprojectpost` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_member_ofcprojectpost`(
    IN membersessionid VARCHAR(100),
    IN inparam json, -- tbl_ofcmembereducation_details
    IN inkeywords json,
    IN inquestions json,
    IN inskill json,
    IN fileuploadjson json, 
    OUT outparam json,
    OUT outfileupload json
   
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
            CALL proc_runningid('PPOST',@p);
             INSERT INTO tbl_ofcprojectpost_details
             (ofcprojectpost_id,ofcmembers_id_fkprojectpost,subcat_id_fkprojectpost,experience_id_fkprojectpost,ofcprojectpost_budget,ofcprojectpost_title,
             ofcprojectpost_description,ofcprojectpost_timeframe,ofcprojectpost_typepreference
             ,ofcprojectpost_kind,ofcprojectpost_budgetamount,ofcprojectpost_estimatestartdate,country_id_fkprojectpost,language_id_fkprojectpost,
             createdate,STATUS)
             VALUES(@p,
             @memid,
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].subcat_id_fkprojectpost')),
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].experience_id_fkprojectpost')),
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcprojectpost_budget')),
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcprojectpost_title')),
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcprojectpost_description')),
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcprojectpost_timeframe')),
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcprojectpost_typepreference')),
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcprojectpost_kind')),
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcprojectpost_budgetamount')),
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcprojectpost_estimatestartdate')),
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].country_id_fkprojectpost')),
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].language_id_fkprojectpost')),            
             NOW(),'active');
            SET @countpk = JSON_LENGTH(JSON_EXTRACT(inkeywords , CONCAT('$[*].value')));
            SET @x1=0;
        
            WHILE @x1  < @countpk DO
                INSERT INTO tbl_ofcprojectpost_keywords(ofcprojectpost_id,keywords_id)
             VALUES(@p,JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(inkeywords , '$[*].value'),CONCAT('$[',@x1,']'))));
               set @x1 = @x1 + 1;
             END WHILE;
            
            SET @countpk = JSON_LENGTH(JSON_EXTRACT(inskill , CONCAT('$[*].value')));
            SET @x1=0;
        
            WHILE @x1  < @countpk DO
                INSERT INTO tbl_ofcprojectpost_skill(ofcprojectpost_id,skill_id)
             VALUES(@p,JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(inskill , '$[*].value'),CONCAT('$[',@x1,']'))));
               SET @x1 = @x1 + 1;
             END WHILE;
            
             -- JSON_UNQUOTE(JSON_EXTRACT(outparam , '$[0].Idupdated'))
            
            -- CALL proc_common_sub_insert(inkeywords,'tbl_ofcprojectpost_keywords','ofcprojectpost_id',@p,@output2);
            CALL proc_common_sub_insert(inquestions,'tbl_ofcprojectpost_questions','ofcprojectpost_id',@p,@output2);
            -- CALL proc_common_sub_insert(inskill,'tbl_ofcprojectpost_skill','ofcprojectpost_id',@p,@output2);
            -- JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].task_id'))
            CALL proc_uploadfile_master_createjson('tbl_ofcprojectpost_details',@p,fileuploadjson,@outparam2);
           
            SET outfileupload = @outparam2;
           
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
     SET Error = 'Project Posted Successfully';
     SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
         'Error', Error,
         'Validation', Validation,
       'Controlid', Controlid));
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_member_ofcprojectsubmitproposal` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_member_ofcprojectsubmitproposal` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_member_ofcprojectsubmitproposal`(
    IN membersessionid VARCHAR(100),
    IN inparam json, -- tbl_ofcsubmitproposal_details
    IN inquestions json,
    IN fileuploadjson json, 
    OUT outparam json,
    OUT outfileupload json
   
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
            CALL proc_runningid('PSUB',@p);
             INSERT INTO tbl_ofcsubmitproposal_details
             (ofcsubmitproposal_id,ofcprojectpost_id_fksubmitproposal,ofcmembers_id_fksubmitproposal,ofcsubmitproposal_coverletter,ofcsubmitproposal_budget,
             ofcsubmitproposal_commissionpercentage,ofcsubmitproposal_commissionamount,ofcsubmitproposal_finalamount,
             ofcsubmitproposal_timeframe,ofcsubmitproposal_availability,ofcsubmitproposal_status,ofcsubmitproposal_terms,
             ofcsubmitproposal_estimatestartdate,ofcsubmitproposal_estimatedays,ofcsubmitproposal_estimatedhoursindays,
             ofcsubmitproposal_workstatus,createdate,status)
             VALUES(@p,
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcprojectpost_id_fksubmitproposal')),
             @memid,
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcsubmitproposal_coverletter')),
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcsubmitproposal_budget')),
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcsubmitproposal_commissionpercentage')),
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcsubmitproposal_commissionamount')),
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcsubmitproposal_finalamount')),
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcsubmitproposal_timeframe')),
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcsubmitproposal_availability')),
             'bidding',
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcsubmitproposal_terms')),
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcsubmitproposal_estimatestartdate')),
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcsubmitproposal_estimatedays')),
             JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].ofcsubmitproposal_estimatedhoursindays')), 
             'bidding',           
             NOW(),'active');
            SET @countpk = JSON_LENGTH(JSON_EXTRACT(inquestions , CONCAT('$[*].value')));
            SET @x1=0;
        
            WHILE @x1  < @countpk DO
                INSERT INTO tbl_ofcsubmitproposal_questionanswers(ofcsubmitproposal_id_ofcsubmitproposalquest,
                ofcsubmitproposalquest_question,ofcsubmitproposalquest_answer)
             VALUES(@p,
             JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(inquestions , '$[*].ofcsubmitproposalquest_question'),CONCAT('$[',@x1,']'))),
             JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(inquestions , '$[*].ofcsubmitproposalquest_answer'),CONCAT('$[',@x1,']')))                      
             
             );
               set @x1 = @x1 + 1;
             END WHILE;
            
            
            
             -- JSON_UNQUOTE(JSON_EXTRACT(outparam , '$[0].Idupdated'))
            
            -- CALL proc_common_sub_insert(inkeywords,'tbl_ofcprojectpost_keywords','ofcprojectpost_id',@p,@output2);
      --      CALL proc_common_sub_insert(inquestions,'tbl_ofcprojectpost_questions','ofcprojectpost_id',@p,@output2);
            -- CALL proc_common_sub_insert(inskill,'tbl_ofcprojectpost_skill','ofcprojectpost_id',@p,@output2);
            -- JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].task_id'))
            CALL proc_uploadfile_master_createjson('tbl_ofcsubmitproposal_details',@p,fileuploadjson,@outparam2);
           
           SET outfileupload = @outparam2;
           
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
     SET Error = 'Project Posted Successfully';
     SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
         'Error', Error,
         'Validation', Validation,
       'Controlid', Controlid));
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_ofcmember_freelancerslist` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_ofcmember_freelancerslist` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_ofcmember_freelancerslist`(
    IN membersessionid VARCHAR(100),   
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
			SET Error = 'In correct current password entered..!';
			SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
			'Error', Error,
			'Validation', Validation,
			'Controlid', Controlid));
			LEAVE label1;
		 ELSE
		 
			--  &&& fun_encrypt(maina.ofcmembers_id) - nned to integrate this
			SET outparam=(SELECT CONCAT('[', (SELECT GROUP_CONCAT(CONCAT('{','"ofcmembers_id":"',IF(ISNULL(maina.ofcmembers_id),'-',maina.ofcmembers_id),'",','"ofcmembers_fname":"',IF(ISNULL(maina.ofcmembers_fname),'-',maina.ofcmembers_fname),'",','"ofcmembers_mname":"',IF(ISNULL(maina.ofcmembers_mname),'-',maina.ofcmembers_mname),'",','"ofcmembers_lname":"',IF(ISNULL(maina.ofcmembers_lname),'-',maina.ofcmembers_lname),'",','"ofcmembers_name":"',IF(ISNULL(maina.ofcmembers_name),'-',maina.ofcmembers_name),'",','"ofcmember_type":"',IF(ISNULL(maina.ofcmember_type),'-',maina.ofcmember_type),'",','"city_id":"',IF(ISNULL(maina.city_id),'-',maina.city_id),'",','"ofcmembers_emailid":"',IF(ISNULL(maina.ofcmembers_emailid),'-',maina.ofcmembers_emailid),'",','"ofcmembers_password":"',IF(ISNULL(maina.ofcmembers_password),'-',maina.ofcmembers_password),'",','"ofcmembers_address1":"',IF(ISNULL(maina.ofcmembers_address1),'-',maina.ofcmembers_address1),'",','"ofcmembers_address2":"',IF(ISNULL(maina.ofcmembers_address2),'-',maina.ofcmembers_address2),'",','"ofcmembers_pincode":"',IF(ISNULL(maina.ofcmembers_pincode),'-',maina.ofcmembers_pincode),'",','"ofcmembers_contactnos":"',IF(ISNULL(maina.ofcmembers_contactnos),'-',maina.ofcmembers_contactnos),'",','"ofcmembers_availability":"',IF(ISNULL(maina.ofcmembers_availability),'-',maina.ofcmembers_availability),'",','"ofcmembers_displayname":"',IF(ISNULL(maina.ofcmembers_displayname),'-',maina.ofcmembers_displayname),'",','"ofcmembers_description":"',IF(ISNULL(maina.ofcmembers_description),'-',maina.ofcmembers_description),'",','"ofcmembers_selfrating":"',IF(ISNULL(maina.ofcmembers_selfrating),'-',maina.ofcmembers_selfrating),'",','"ofcmembers_experiencelevel":"',IF(ISNULL(maina.ofcmembers_experiencelevel),'-',maina.ofcmembers_experiencelevel),'",','"ofcmembers_gender":"',IF(ISNULL(maina.ofcmembers_gender),'-',maina.ofcmembers_gender),'",','"ofcmembers_dob":"',IF(ISNULL(maina.ofcmembers_dob),'-',UNIX_TIMESTAMP(maina.ofcmembers_dob)*1000),'",','"ofcmembers_nosofteammembers":"',IF(ISNULL(maina.ofcmembers_nosofteammembers),'-',maina.ofcmembers_nosofteammembers),'",','"status":"',IF(ISNULL(maina.status),'-',maina.status),'",','"country_id":"',IF(ISNULL(maina.country_id),'-',maina.country_id),'",','"country_name":"',IF(ISNULL(maina.country_name),'-',maina.country_name),'",','"state_id":"',IF(ISNULL(maina.state_id),'-',maina.state_id),'",','"state_name":"',IF(ISNULL(maina.state_name),'-',maina.state_name),'",','"city_name":"',IF(ISNULL(maina.city_name),'-',maina.city_name),'",'),'"skillsarr":',(SELECT CONCAT('[',GROUP_CONCAT( json_object('ofcmemberskill_id',sub0.ofcmemberskill_id,'skill_id',sub0.skill_id,'skill_name',sub0.skill_name)) ,']}')FROM vw_ofcmember_city_state_country main0, vw_ofcmember_skill sub0 WHERE main0.ofcmembers_id=sub0.ofcmembers_id AND sub0.ofcmemberskill_id = sub0.ofcmemberskill_id))FROM vw_ofcmember_city_state_country maina WHERE maina.ofcmembers_id=maina.ofcmembers_id  ),']')
					);
			
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
     -- SET Error = 'Saved Successfully';
     -- SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
        --  'Error', Error,
         -- 'Validation', Validation,
       -- 'Controlid', Controlid));
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_ofcmember_freelancerslist_byofcmemberId` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_ofcmember_freelancerslist_byofcmemberId` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_ofcmember_freelancerslist_byofcmemberId`(
    IN membersessionid VARCHAR(100),   
    in ofcmembersid varchar(500),
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
			SET Error = 'In correct current password entered..!';
			SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
			'Error', Error,
			'Validation', Validation,
			'Controlid', Controlid));
			LEAVE label1;
		 ELSE
		 
			--  &&& fun_encrypt(maina.ofcmembers_id) - nned to integrate this
			SET outparam=(SELECT CONCAT('[', (SELECT GROUP_CONCAT(CONCAT('{','"ofcmembers_id":"',IF(ISNULL(maina.ofcmembers_id),'-',maina.ofcmembers_id),'",','"ofcmembers_fname":"',IF(ISNULL(maina.ofcmembers_fname),'-',maina.ofcmembers_fname),'",','"ofcmembers_mname":"',IF(ISNULL(maina.ofcmembers_mname),'-',maina.ofcmembers_mname),'",','"ofcmembers_lname":"',IF(ISNULL(maina.ofcmembers_lname),'-',maina.ofcmembers_lname),'",','"ofcmembers_name":"',IF(ISNULL(maina.ofcmembers_name),'-',maina.ofcmembers_name),'",','"ofcmember_type":"',IF(ISNULL(maina.ofcmember_type),'-',maina.ofcmember_type),'",','"city_id":"',IF(ISNULL(maina.city_id),'-',maina.city_id),'",','"ofcmembers_emailid":"',IF(ISNULL(maina.ofcmembers_emailid),'-',maina.ofcmembers_emailid),'",','"ofcmembers_password":"',IF(ISNULL(maina.ofcmembers_password),'-',maina.ofcmembers_password),'",','"ofcmembers_address1":"',IF(ISNULL(maina.ofcmembers_address1),'-',maina.ofcmembers_address1),'",','"ofcmembers_address2":"',IF(ISNULL(maina.ofcmembers_address2),'-',maina.ofcmembers_address2),'",','"ofcmembers_pincode":"',IF(ISNULL(maina.ofcmembers_pincode),'-',maina.ofcmembers_pincode),'",','"ofcmembers_contactnos":"',IF(ISNULL(maina.ofcmembers_contactnos),'-',maina.ofcmembers_contactnos),'",','"ofcmembers_availability":"',IF(ISNULL(maina.ofcmembers_availability),'-',maina.ofcmembers_availability),'",','"ofcmembers_displayname":"',IF(ISNULL(maina.ofcmembers_displayname),'-',maina.ofcmembers_displayname),'",','"ofcmembers_description":"',IF(ISNULL(maina.ofcmembers_description),'-',maina.ofcmembers_description),'",','"ofcmembers_selfrating":"',IF(ISNULL(maina.ofcmembers_selfrating),'-',maina.ofcmembers_selfrating),'",','"ofcmembers_experiencelevel":"',IF(ISNULL(maina.ofcmembers_experiencelevel),'-',maina.ofcmembers_experiencelevel),'",','"ofcmembers_gender":"',IF(ISNULL(maina.ofcmembers_gender),'-',maina.ofcmembers_gender),'",','"ofcmembers_dob":"',IF(ISNULL(maina.ofcmembers_dob),'-',UNIX_TIMESTAMP(maina.ofcmembers_dob)*1000),'",','"ofcmembers_nosofteammembers":"',IF(ISNULL(maina.ofcmembers_nosofteammembers),'-',maina.ofcmembers_nosofteammembers),'",','"status":"',IF(ISNULL(maina.status),'-',maina.status),'",','"country_id":"',IF(ISNULL(maina.country_id),'-',maina.country_id),'",','"country_name":"',IF(ISNULL(maina.country_name),'-',maina.country_name),'",','"state_id":"',IF(ISNULL(maina.state_id),'-',maina.state_id),'",','"state_name":"',IF(ISNULL(maina.state_name),'-',maina.state_name),'",','"city_name":"',IF(ISNULL(maina.city_name),'-',maina.city_name),'",'),'"skillsarr":',(SELECT CONCAT('[',GROUP_CONCAT( json_object('ofcmemberskill_id',sub0.ofcmemberskill_id,'skill_id',sub0.skill_id,'skill_name',sub0.skill_name)) ,']}')FROM vw_ofcmember_city_state_country main0, vw_ofcmember_skill sub0 WHERE main0.ofcmembers_id=sub0.ofcmembers_id AND sub0.ofcmemberskill_id = sub0.ofcmemberskill_id))FROM vw_ofcmember_city_state_country maina WHERE maina.ofcmembers_id=maina.ofcmembers_id and maina.ofcmembers_id=ofcmembersid ),']')
					);
			
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
     -- SET Error = 'Saved Successfully';
     -- SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
        --  'Error', Error,
         -- 'Validation', Validation,
       -- 'Controlid', Controlid));
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_ofcmember_login` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_ofcmember_login` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_ofcmember_login`(in username varchar(50), in passwordin varchar(50) ,out result json, out outparam json)
BEGIN
	CALL proc_common_select_single_json('tbl_ofcmembers_master',concat(' ofcmembers_emailid=\'',username,'\' AND ofcmembers_password=\'',passwordin,'\''),@a);
	-- SELECT @a;
	if @a is null then
		set @a = '[]';
		SET outparam =  @a;
		set result=@a;
	else
	     call proc_tbl_ofcmemsession_details_create(JSON_UNQUOTE(JSON_EXTRACT(@a , '$[0].ofcmembers_id')),result,outparam);
	end if; 
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_ofcmember_logout` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_ofcmember_logout` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_ofcmember_logout`(IN ofcmemessionid VARCHAR(100) ,out result json, out outparam json)
BEGIN
	
	update tbl_ofcmemsession_details set status='logout' where ofcmemsession_id=ofcmemessionid;
	SET @a = '[]';
		SET outparam =  @a;
		SET result=@a;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_ofcsubmitproposal_terms_questionanswers` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_ofcsubmitproposal_terms_questionanswers` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_ofcsubmitproposal_terms_questionanswers`(
     IN membersessionid VARCHAR(100),   
     in ofcsubmitproposalid varchar(500),
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
			SET Error = 'In correct current password entered..!';
			SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
			'Error', Error,
			'Validation', Validation,
			'Controlid', Controlid));
			LEAVE label1;
		 ELSE
		 
			SET outparam=(SELECT CONCAT('[', (SELECT GROUP_CONCAT(CONCAT('{','"ofcsubmitproposal_id":"',IF(ISNULL(maina.ofcsubmitproposal_id),'-',maina.ofcsubmitproposal_id),'",','"ofcprojectpost_id_fksubmitproposal":"',IF(ISNULL(maina.ofcprojectpost_id_fksubmitproposal),'-',maina.ofcprojectpost_id_fksubmitproposal),'",','"ofcmembers_id_fksubmitproposal":"',IF(ISNULL(maina.ofcmembers_id_fksubmitproposal),'-',maina.ofcmembers_id_fksubmitproposal),'",','"ofcsubmitproposal_coverletter":"',IF(ISNULL(maina.ofcsubmitproposal_coverletter),'-',maina.ofcsubmitproposal_coverletter),'",','"ofcsubmitproposal_budget":"',IF(ISNULL(maina.ofcsubmitproposal_budget),'-',maina.ofcsubmitproposal_budget),'",','"ofcsubmitproposal_negotiable":"',IF(ISNULL(maina.ofcsubmitproposal_negotiable),'-',maina.ofcsubmitproposal_negotiable),'",','"ofcsubmitproposal_commissionpercentage":"',IF(ISNULL(maina.ofcsubmitproposal_commissionpercentage),'-',maina.ofcsubmitproposal_commissionpercentage),'",','"ofcsubmitproposal_commissionamount":"',IF(ISNULL(maina.ofcsubmitproposal_commissionamount),'-',maina.ofcsubmitproposal_commissionamount),'",','"ofcsubmitproposal_finalamount":"',IF(ISNULL(maina.ofcsubmitproposal_finalamount),'-',maina.ofcsubmitproposal_finalamount),'",','"ofcsubmitproposal_timeframe":"',IF(ISNULL(maina.ofcsubmitproposal_timeframe),'-',maina.ofcsubmitproposal_timeframe),'",','"ofcsubmitproposal_availability":"',IF(ISNULL(maina.ofcsubmitproposal_availability),'-',maina.ofcsubmitproposal_availability),'",','"ofcsubmitproposal_status":"',IF(ISNULL(maina.ofcsubmitproposal_status),'-',maina.ofcsubmitproposal_status),'",','"ofcsubmitproposal_remarks":"',IF(ISNULL(maina.ofcsubmitproposal_remarks),'-',maina.ofcsubmitproposal_remarks),'",','"ofcsubmitproposal_terms":"',IF(ISNULL(maina.ofcsubmitproposal_terms),'-',maina.ofcsubmitproposal_terms),'",','"ofcsubmitproposal_estimatestartdate":"',IF(ISNULL(maina.ofcsubmitproposal_estimatestartdate),'-',UNIX_TIMESTAMP(maina.ofcsubmitproposal_estimatestartdate)*1000),'",','"ofcsubmitproposal_startdate":"',IF(ISNULL(maina.ofcsubmitproposal_startdate),'-',UNIX_TIMESTAMP(maina.ofcsubmitproposal_startdate)*1000),'",','"ofcsubmitproposal_enddate":"',IF(ISNULL(maina.ofcsubmitproposal_enddate),'-',UNIX_TIMESTAMP(maina.ofcsubmitproposal_enddate)*1000),'",','"ofcsubmitproposal_estimatedays":"',IF(ISNULL(maina.ofcsubmitproposal_estimatedays),'-',maina.ofcsubmitproposal_estimatedays),'",','"ofcsubmitproposal_estimatedhoursindays":"',IF(ISNULL(maina.ofcsubmitproposal_estimatedhoursindays),'-',maina.ofcsubmitproposal_estimatedhoursindays),'",','"ofcsubmitproposal_reportabusebyemployeer":"',IF(ISNULL(maina.ofcsubmitproposal_reportabusebyemployeer),'-',maina.ofcsubmitproposal_reportabusebyemployeer),'",','"ofcsubmitproposal_reportabusebyfreelancer":"',IF(ISNULL(maina.ofcsubmitproposal_reportabusebyfreelancer),'-',maina.ofcsubmitproposal_reportabusebyfreelancer),'",','"ofcsubmitproposal_proposalacceptdate":"',IF(ISNULL(maina.ofcsubmitproposal_proposalacceptdate),'-',UNIX_TIMESTAMP(maina.ofcsubmitproposal_proposalacceptdate)*1000),'",','"ofcsubmitproposal_proposalrejectdate":"',IF(ISNULL(maina.ofcsubmitproposal_proposalrejectdate),'-',UNIX_TIMESTAMP(maina.ofcsubmitproposal_proposalrejectdate)*1000),'",','"ofcsubmitproposal_completeddate":"',IF(ISNULL(maina.ofcsubmitproposal_completeddate),'-',UNIX_TIMESTAMP(maina.ofcsubmitproposal_completeddate)*1000),'",','"ofcsubmitproposal_iscompletedbyemployeer":"',IF(ISNULL(maina.ofcsubmitproposal_iscompletedbyemployeer),'-',maina.ofcsubmitproposal_iscompletedbyemployeer),'",','"ofcsubmitproposal_iscompletedbyfreelancer":"',IF(ISNULL(maina.ofcsubmitproposal_iscompletedbyfreelancer),'-',maina.ofcsubmitproposal_iscompletedbyfreelancer),'",','"ofcsubmitproposal_workstatus":"',IF(ISNULL(maina.ofcsubmitproposal_workstatus),'-',maina.ofcsubmitproposal_workstatus),'",','"createdate":"',IF(ISNULL(maina.createdate),'-',UNIX_TIMESTAMP(maina.createdate)*1000),'",','"modifieddate":"',IF(ISNULL(maina.modifieddate),'-',UNIX_TIMESTAMP(maina.modifieddate)*1000),'",','"status":"',IF(ISNULL(maina.status),'-',maina.status),'",','"questanswersarr":',(SELECT CONCAT('[',GROUP_CONCAT( json_object('ofcsubmitproposalquest_id',sub0.ofcsubmitproposalquest_id,'ofcsubmitproposal_id_ofcsubmitproposalquest',sub0.ofcsubmitproposal_id_ofcsubmitproposalquest,'ofcsubmitproposalquest_question',sub0.ofcsubmitproposalquest_question,'ofcsubmitproposalquest_answer',sub0.ofcsubmitproposalquest_answer)) ,'],')FROM tbl_ofcsubmitproposal_details main0, tbl_ofcsubmitproposal_questionanswers sub0 WHERE main0.ofcsubmitproposal_id=sub0.ofcsubmitproposal_id_ofcsubmitproposalquest AND sub0.ofcsubmitproposalquest_id = sub0.ofcsubmitproposalquest_id)),'"termsarr":',(SELECT CONCAT('[',GROUP_CONCAT( json_object('ofcsubmitproposalterms_id',sub1.ofcsubmitproposalterms_id,'ofcsubmitproposal_id_fkterms',sub1.ofcsubmitproposal_id_fkterms,'ofcsubmitproposalterms_terms',sub1.ofcsubmitproposalterms_terms,'ofcsubmitproposalterms_agreedbyemployer',sub1.ofcsubmitproposalterms_agreedbyemployer,'ofcsubmitproposalterms_agreedbyemployee',sub1.ofcsubmitproposalterms_agreedbyemployee,'status',sub1.status)) ,']}')FROM tbl_ofcsubmitproposal_details main1, tbl_ofcsubmitproposal_terms sub1 WHERE main1.ofcsubmitproposal_id=sub1.ofcsubmitproposal_id_fkterms AND sub1.ofcsubmitproposalterms_id = sub1.ofcsubmitproposalterms_id))FROM tbl_ofcsubmitproposal_details maina WHERE maina.ofcsubmitproposal_id=maina.ofcsubmitproposal_id and maina.ofcsubmitproposal_id =ofcsubmitproposalid  ),']')
  );
			
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
     -- SET Error = 'Saved Successfully';
     -- SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
        --  'Error', Error,
         -- 'Validation', Validation,
       -- 'Controlid', Controlid));
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_runningid` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_runningid` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_runningid`(IN runname VARCHAR(50), OUT runid VARCHAR(50))
BEGIN
    
      START TRANSACTION;
      SET @runprefix = (SELECT running_prefix FROM tbl_running_master WHERE running_id=runname);
      
      SET @runint = (SELECT running_number FROM tbl_running_master WHERE running_id=runname);
      if @runint is null or @runint = '' then
        insert into tbl_running_master(running_id,running_name,running_prefix,running_number)values
        (runname,runname,runname,0);
	set @runint = 0;
	set @runprefix = runname;
      end if;
      SET @runint = @runint + 1;
      UPDATE tbl_running_master SET running_number=@runint WHERE running_id=runname;
      COMMIT;
      SET runid = CONCAT(@runprefix , @runint);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_select_fileuploads` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_select_fileuploads` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_select_fileuploads`(in tblname varchar(100),in pkid varchar(100),out outparam json)
BEGIN
	SET outparam=(SELECT CONCAT ('[',GROUP_CONCAT( json_object('fileName',uploadfile_actulalfilename,'uploadfile_filename',uploadfile_filename,'fileType',uploadfile_type,'filePath',uploadfile_path,'fileStatus', 'No'  ) ),']')
	 FROM tbl_uploadedfile_master WHERE uploadfile_tblname=tblname AND uploadfile_tblpkid=pkid );
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_certification_master_create` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_certification_master_create` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_certification_master_create`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_insert(inparam,'tbl_certification_master','certification_id','CERF',outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_certification_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_certification_master_selectedit` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_certification_master_selectedit` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_certification_master_selectedit`(IN pkid varchar(1000),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_select_single_json('tbl_certification_master',CONCAT('certification_id=','''',pkid,''''),result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_certification_master_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_certification_master_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_certification_master_selectjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('tbl_certification_master','',result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_certification_master_update` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_certification_master_update` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_certification_master_update`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_update(inparam,'tbl_certification_master','certification_id',JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].certification_id')),outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_certification_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_city_master_create` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_city_master_create` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_city_master_create`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_insert(inparam,'tbl_city_master','city_id','CIT',outparam);COMMIT;SET Isuccess = TRUE;CALL proc_vw_city_state_country_details_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_city_master_selectedit` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_city_master_selectedit` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_city_master_selectedit`(IN pkid varchar(1000),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_select_single_json('tbl_city_master',CONCAT('city_id=','''',pkid,''''),result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_city_master_state_id_drpjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_city_master_state_id_drpjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_city_master_state_id_drpjson`(IN state_id_param varchar(100),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_drpjson('city_id','city_name','tbl_city_master',concat( ' state_id=','''',state_id_param,''''),result);COMMIT;SET Isuccess = TRUE;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_city_master_update` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_city_master_update` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_city_master_update`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_update(inparam,'tbl_city_master','city_id',JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].city_id')),outparam);COMMIT;SET Isuccess = TRUE;CALL proc_vw_city_state_country_details_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_comment_tasks_fileupload_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_comment_tasks_fileupload_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `proc_tbl_comment_tasks_fileupload_selectjson`(IN taskid VARCHAR(100),OUT outparam json)
BEGIN
CALL proc_runningid('LOG2-',@p);
INSERT logrecord_details2 (logrecord_result,logrecord_result2,logrecord_id2)
SELECT CONCAT('"taskcom_name"',':"',a.taskcom_name,'","','member_name','":"',c.member_name,'","','taskcom_date','":"',a.taskcom_date,'"'
)
 ,(SELECT CONCAT('[',GROUP_CONCAT( json_object('fileName',file_name,'uploadfile_filename',file_name,'fileStatus','No','fileType',file_type,
'filePath',file_path)) ,']')
FROM tbl_fileuploads_comment_tasks x1  WHERE x1.taskcom_id=a.taskcom_id),@p
  FROM tbl_comments_tasks a, tbl_member_master c WHERE a.member_id=c.member_id and a.task_id =taskid  ORDER BY a.taskcom_date DESC;
  
  
  set outparam = (SELECT CONCAT('[',GROUP_CONCAT('{',logrecord_result,',"filearr":',IF(logrecord_result2 IS NULL,'[]',logrecord_result2),'}'),']') FROM logrecord_details2);
  delete from logrecord_details2 where logrecord_id2=@p;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_company_master_create` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_company_master_create` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_company_master_create`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_insert(inparam,'tbl_company_master','company_id','COMP',outparam);COMMIT;SET Isuccess = TRUE;CALL proc_vw_company_city_state_country_details_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_company_master_selectedit` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_company_master_selectedit` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_company_master_selectedit`(IN pkid varchar(1000),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_select_single_json('tbl_company_master',CONCAT('company_id=','''',pkid,''''),result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_company_master_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_company_master_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_company_master_selectjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('tbl_company_master','',result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_company_master_update` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_company_master_update` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_company_master_update`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_update(inparam,'tbl_company_master','company_id',JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].company_id')),outparam);COMMIT;SET Isuccess = TRUE;CALL proc_vw_company_city_state_country_details_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_country_master_create` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_country_master_create` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_country_master_create`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_insert(inparam,'tbl_country_master','country_id','COU',outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_country_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_country_master_drpjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_country_master_drpjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_country_master_drpjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_drpjson('country_id','country_name','tbl_country_master','',result);COMMIT;SET Isuccess = TRUE;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_country_master_selectedit` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_country_master_selectedit` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_country_master_selectedit`(IN pkid varchar(1000),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_select_single_json('tbl_country_master',CONCAT('country_id=','''',pkid,''''),result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_country_master_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_country_master_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_country_master_selectjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('tbl_country_master','',result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_country_master_update` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_country_master_update` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_country_master_update`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_update(inparam,'tbl_country_master','country_id',JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].country_id')),outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_country_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_country_master__drpjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_country_master__drpjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_country_master__drpjson`(IN _param varchar(100),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_drpjson('country_id','country_name','tbl_country_master',concat( 'where =',_param),result);COMMIT;SET Isuccess = TRUE;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_currencyconversion_master_create` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_currencyconversion_master_create` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_currencyconversion_master_create`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_insert(inparam,'tbl_currencyconversion_master','currconversion_id','CUCR',outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_currencyconversion_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_currencyconversion_master_selectedit` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_currencyconversion_master_selectedit` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_currencyconversion_master_selectedit`(IN pkid VARCHAR(1000),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_select_single_json('tbl_currencyconversion_master',CONCAT('currconversion_id=','''',pkid,''''),result);COMMIT;SET Isuccess = TRUE;SET outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_currencyconversion_master_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_currencyconversion_master_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_currencyconversion_master_selectjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('tbl_currencyconversion_master','',result);COMMIT;SET Isuccess = TRUE;SET outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_currencyconversion_master_update` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_currencyconversion_master_update` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_currencyconversion_master_update`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_update(inparam,'tbl_currencyconversion_master','currconversion_id',JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].currconversion_id')),outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_currencyconversion_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_currency_master_create` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_currency_master_create` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_currency_master_create`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_insert(inparam,'tbl_currency_master','currency_id','CURR',outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_currency_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_currency_master_drpjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_currency_master_drpjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_currency_master_drpjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_drpjson('currency_id','currency_name','tbl_currency_master','',result);COMMIT;SET Isuccess = TRUE;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_currency_master_selectedit` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_currency_master_selectedit` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_currency_master_selectedit`(IN pkid VARCHAR(1000),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_select_single_json('tbl_currency_master',CONCAT('currency_id=','''',pkid,''''),result);COMMIT;SET Isuccess = TRUE;SET outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_currency_master_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_currency_master_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_currency_master_selectjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('tbl_currency_master','',result);COMMIT;SET Isuccess = TRUE;SET outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_currency_master_update` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_currency_master_update` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_currency_master_update`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_update(inparam,'tbl_currency_master','currency_id',JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].currency_id')),outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_currency_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_education_master_create` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_education_master_create` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_education_master_create`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_insert(inparam,'tbl_education_master','education_id','EDU',outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_education_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_education_master_drpjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_education_master_drpjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_education_master_drpjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_drpjson('education_id','education_name','tbl_education_master','',result);COMMIT;SET Isuccess = TRUE;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_education_master_selectedit` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_education_master_selectedit` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_education_master_selectedit`(IN pkid varchar(1000),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_select_single_json('tbl_education_master',CONCAT('education_id=','''',pkid,''''),result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_education_master_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_education_master_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_education_master_selectjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('tbl_education_master','',result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_education_master_update` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_education_master_update` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_education_master_update`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_update(inparam,'tbl_education_master','education_id',JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].education_id')),outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_education_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_language_master_create` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_language_master_create` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_language_master_create`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_insert(inparam,'tbl_language_master','language_id','LANG',outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_language_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_language_master_drpjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_language_master_drpjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_language_master_drpjson`(out outparam json)
BEGIN
	CALL proc_common_drpjson('language_id','language_name','tbl_language_master','',outparam);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_language_master_selectedit` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_language_master_selectedit` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_language_master_selectedit`(IN pkid VARCHAR(1000),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_select_single_json('tbl_language_master',CONCAT('language_id=','''',pkid,''''),result);COMMIT;SET Isuccess = TRUE;SET outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_language_master_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_language_master_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_language_master_selectjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('tbl_language_master','',result);COMMIT;SET Isuccess = TRUE;SET outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_language_master_update` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_language_master_update` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_language_master_update`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_update(inparam,'tbl_language_master','language_id',JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].language_id')),outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_language_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_maincat_master_create` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_maincat_master_create` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_maincat_master_create`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_insert(inparam,'tbl_maincat_master','maincat_id','MCAT',outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_maincat_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_maincat_master_drpjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_maincat_master_drpjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_maincat_master_drpjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_drpjson('maincat_id','maincat_name','tbl_maincat_master','',result);COMMIT;SET Isuccess = TRUE;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_maincat_master_selectedit` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_maincat_master_selectedit` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_maincat_master_selectedit`(IN pkid varchar(1000),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_select_single_json('tbl_maincat_master',CONCAT('maincat_id=','''',pkid,''''),result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_maincat_master_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_maincat_master_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_maincat_master_selectjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('tbl_maincat_master','',result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_maincat_master_update` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_maincat_master_update` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_maincat_master_update`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_update(inparam,'tbl_maincat_master','maincat_id',JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].maincat_id')),outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_maincat_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_membershiptype_master_create` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_membershiptype_master_create` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_membershiptype_master_create`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_insert(inparam,'tbl_membershiptype_master','membershiptype_id','MEMT',outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_membershiptype_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_membershiptype_master_selectedit` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_membershiptype_master_selectedit` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_membershiptype_master_selectedit`(IN pkid varchar(1000),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_select_single_json('tbl_membershiptype_master',CONCAT('membershiptype_id=','''',pkid,''''),result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_membershiptype_master_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_membershiptype_master_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_membershiptype_master_selectjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('tbl_membershiptype_master','',result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_membershiptype_master_update` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_membershiptype_master_update` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_membershiptype_master_update`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_update(inparam,'tbl_membershiptype_master','membershiptype_id',JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].membershiptype_id')),outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_membershiptype_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_ofcmembers_master_create` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_ofcmembers_master_create` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_ofcmembers_master_create`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_insert(inparam,'tbl_ofcmembers_master','ofcmembers_id','OFCM',outparam);COMMIT;SET Isuccess = TRUE;
-- CALL proc_tbl_ofcmembers_master_selectjson(@result1,outparam);
SET result =@result1;
set Isuccess = true;
SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
         'Error', Error,
         'Validation', Validation,
       'Controlid', Controlid));
END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_ofcmembers_master_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_ofcmembers_master_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_ofcmembers_master_selectjson`(in ofcmemessionid varchar(100), OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);
SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';
CALL proc_common_select_single_json('vw_ofcsession_ofcmembers_details',concat('ofcmemsession_id=\'',ofcmemessionid,'\''),result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_ofcmemsession_details_create` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_ofcmemsession_details_create` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_ofcmemsession_details_create`(IN ofcmemberid varchar(50),  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';
-- CALL proc_common_insert(inparam,'tbl_ofcmemsession_details','ofcmemsession_id','OFCS',outparam);
CALL proc_runningid('OFCS',@p);
insert into 
tbl_ofcmemsession_details
(ofcmemsession_id,ofcmemsession_deviceid,ofcmemsession_devicetype,ofcmembers_id,createdate,status)
values(@p,'-','web',ofcmemberid,now(),'active');
call proc_common_select_single_json('tbl_ofcmemsession_details',concat(' ofcmemsession_id=\'',@p,'\''),result);
COMMIT;SET Isuccess = TRUE;
SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess,
         'Error', Error,
         'Validation', Validation,
       'Controlid', Controlid,'Idupdated',@p));
END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_ofcprojectpost_questions_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_ofcprojectpost_questions_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_ofcprojectpost_questions_selectjson`(IN ofcprojectpost_id_param varchar(100),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('tbl_ofcprojectpost_questions',concat('ofcprojectpost_id=','\'',ofcprojectpost_id_param,'\''),result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_plan_master_create` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_plan_master_create` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_plan_master_create`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_insert(inparam,'tbl_plan_master','plan_id','PLAN',outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_plan_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_plan_master_selectedit` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_plan_master_selectedit` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_plan_master_selectedit`(IN pkid varchar(1000),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_select_single_json('tbl_plan_master',CONCAT('plan_id=','''',pkid,''''),result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_plan_master_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_plan_master_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_plan_master_selectjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('tbl_plan_master','',result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_plan_master_update` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_plan_master_update` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_plan_master_update`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_update(inparam,'tbl_plan_master','plan_id',JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].plan_id')),outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_plan_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_popularsearch_fileuploads` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_popularsearch_fileuploads` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_popularsearch_fileuploads`(in pkid varchar(100), out fileuploadjson json)
BEGIN
	CALL proc_select_fileuploads('tbl_popularsearch_homepage',pkid,fileuploadjson);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_popularsearch_homepage_create` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_popularsearch_homepage_create` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_popularsearch_homepage_create`(IN inparam json, in fileuploadjson json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;
GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
SET Error = CONCAT("ERROR ", errno, " : ", msg);
SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;
SET  Validation ='';SET Error ='';SET Controlid ='';
CALL proc_common_insert(inparam,'tbl_popularsearch_homepage','popularsearch_id','POPS',outparam);
CALL proc_uploadfile_master_createjson('tbl_popularsearch_homepage',JSON_UNQUOTE(JSON_EXTRACT(outparam , '$[0].Idupdated')),fileuploadjson,outparam);
COMMIT;SET Isuccess = TRUE;
set @outparam1='';
CALL proc_tbl_popularsearch_homepage_selectjson(@result1,@outparam1);
SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_popularsearch_homepage_selectedit` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_popularsearch_homepage_selectedit` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_popularsearch_homepage_selectedit`(IN pkid varchar(1000),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_select_single_json('tbl_popularsearch_homepage',CONCAT('popularsearch_id=','''',pkid,''''),result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_popularsearch_homepage_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_popularsearch_homepage_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_popularsearch_homepage_selectjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('tbl_popularsearch_homepage','',result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_popularsearch_homepage_update` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_popularsearch_homepage_update` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_popularsearch_homepage_update`(IN inparam json, in fileuploadjson json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';
CALL proc_common_update(inparam,'tbl_popularsearch_homepage','popularsearch_id',JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].popularsearch_id')),outparam);
CALL proc_uploadfile_master_updatejson('tbl_popularsearch_homepage',JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].popularsearch_id')),fileuploadjson,outparam);
COMMIT;SET Isuccess = TRUE;
set @outparam1='';
CALL proc_tbl_popularsearch_homepage_selectjson(@result1,@outparam1);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_pricerange_master_create` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_pricerange_master_create` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_pricerange_master_create`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_insert(inparam,'tbl_pricerange_master','pricerange_id','PRIR',outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_pricerange_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_pricerange_master_selectedit` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_pricerange_master_selectedit` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_pricerange_master_selectedit`(IN pkid VARCHAR(1000),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_select_single_json('tbl_pricerange_master',CONCAT('pricerange_id=','''',pkid,''''),result);COMMIT;SET Isuccess = TRUE;SET outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_pricerange_master_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_pricerange_master_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_pricerange_master_selectjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('tbl_pricerange_master','',result);COMMIT;SET Isuccess = TRUE;SET outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_pricerange_master_update` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_pricerange_master_update` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_pricerange_master_update`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_update(inparam,'tbl_pricerange_master','pricerange_id',JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].pricerange_id')),outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_pricerange_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_securityquestion_master_create` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_securityquestion_master_create` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_securityquestion_master_create`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_insert(inparam,'tbl_securityquestion_master','securityquest_id','SECQ',outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_securityquestion_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_securityquestion_master_drpjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_securityquestion_master_drpjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_securityquestion_master_drpjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_drpjson('securityquest_id','securityquest_name','tbl_securityquestion_master','',result);COMMIT;SET Isuccess = TRUE;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_securityquestion_master_selectedit` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_securityquestion_master_selectedit` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_securityquestion_master_selectedit`(IN pkid VARCHAR(1000),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_select_single_json('tbl_securityquestion_master',CONCAT('securityquest_id=','''',pkid,''''),result);COMMIT;SET Isuccess = TRUE;SET outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_securityquestion_master_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_securityquestion_master_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_securityquestion_master_selectjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('tbl_securityquestion_master','',result);COMMIT;SET Isuccess = TRUE;SET outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_securityquestion_master_update` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_securityquestion_master_update` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_securityquestion_master_update`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_update(inparam,'tbl_securityquestion_master','securityquest_id',JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].securityquest_id')),outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_securityquestion_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_skill_master_create` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_skill_master_create` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_skill_master_create`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_insert(inparam,'tbl_skill_master','skill_id','SKIL',outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_skill_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_skill_master_drpjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_skill_master_drpjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_skill_master_drpjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_drpjson('skill_id','skill_name','tbl_skill_master','',result);COMMIT;SET Isuccess = TRUE;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_skill_master_selectedit` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_skill_master_selectedit` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_skill_master_selectedit`(IN pkid VARCHAR(1000),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_select_single_json('tbl_skill_master',CONCAT('skill_id=','''',pkid,''''),result);COMMIT;SET Isuccess = TRUE;SET outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_skill_master_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_skill_master_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_skill_master_selectjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('tbl_skill_master','',result);COMMIT;SET Isuccess = TRUE;SET outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_skill_master_update` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_skill_master_update` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_skill_master_update`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_update(inparam,'tbl_skill_master','skill_id',JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].skill_id')),outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_skill_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_state_master_country_id_drpjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_state_master_country_id_drpjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_state_master_country_id_drpjson`(IN country_id_param varchar(100),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_drpjson('state_id','state_name','tbl_state_master',concat( ' country_id=','''',country_id_param,''''),result);COMMIT;SET Isuccess = TRUE;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_state_master_create` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_state_master_create` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_state_master_create`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_insert(inparam,'tbl_state_master','state_id','STA',outparam);COMMIT;SET Isuccess = TRUE;CALL proc_vw_state_country_details_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_state_master_selectedit` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_state_master_selectedit` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_state_master_selectedit`(IN pkid varchar(1000),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_select_single_json('tbl_state_master',CONCAT('state_id=','''',pkid,''''),result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_state_master_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_state_master_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_state_master_selectjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('tbl_state_master','',result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_state_master_update` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_state_master_update` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_state_master_update`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_update(inparam,'tbl_state_master','state_id',JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].state_id')),outparam);COMMIT;SET Isuccess = TRUE;CALL proc_vw_state_country_details_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_subcat_master_create` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_subcat_master_create` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_subcat_master_create`(IN inparam json,   IN subinput0 json,OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';
CALL proc_common_insert(inparam,'tbl_subcat_master','subcat_id','SCAT',outparam);
call proc_common_sub_insert(subinput0,'tbl_keyword_subcat','subcat_id',JSON_UNQUOTE(JSON_EXTRACT(outparam , '$[0].Idupdated')),outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_subcat_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_subcat_master_maincat_id_drpjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_subcat_master_maincat_id_drpjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_subcat_master_maincat_id_drpjson`(IN maincat_id_param varchar(100),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_drpjson('subcat_id','subcat_name','tbl_subcat_master',concat( ' maincat_id=','''',maincat_id_param,''''),result);COMMIT;SET Isuccess = TRUE;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_subcat_master_selectedit` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_subcat_master_selectedit` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_subcat_master_selectedit`(IN pkid varchar(1000),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_select_single_json('tbl_subcat_master',CONCAT('subcat_id=','''',pkid,''''),result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_subcat_master_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_subcat_master_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_subcat_master_selectjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('tbl_subcat_master','',result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_subcat_master_update` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_subcat_master_update` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_subcat_master_update`(IN inparam json, IN subinput0 json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_update(inparam,'tbl_subcat_master','subcat_id',JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].subcat_id')),outparam);
CALL proc_common_sub_delete('tbl_keyword_subcat','subcat_id',JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].subcat_id')),@delvar);
call proc_common_sub_insert(subinput0,'tbl_keyword_subcat','subcat_id',JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].subcat_id')),outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_subcat_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_testimonial_master_create` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_testimonial_master_create` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_testimonial_master_create`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_insert(inparam,'tbl_testimonial_master','testimonial_id','TEST',outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_testimonial_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_testimonial_master_selectedit` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_testimonial_master_selectedit` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_testimonial_master_selectedit`(IN pkid varchar(1000),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_select_single_json('tbl_testimonial_master',CONCAT('testimonial_id=','''',pkid,''''),result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_testimonial_master_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_testimonial_master_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_testimonial_master_selectjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('tbl_testimonial_master','',result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_tbl_testimonial_master_update` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_tbl_testimonial_master_update` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tbl_testimonial_master_update`(IN inparam json,  OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_update(inparam,'tbl_testimonial_master','testimonial_id',JSON_UNQUOTE(JSON_EXTRACT(inparam , '$[0].testimonial_id')),outparam);COMMIT;SET Isuccess = TRUE;CALL proc_tbl_testimonial_master_selectjson(@result1,outparam);SET result =@result1;END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_uploadfile_master_createjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_uploadfile_master_createjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_uploadfile_master_createjson`(
    IN tblname VARCHAR(500),
    IN pkid VARCHAR(100),
    IN fileuploadjson json,
    OUT outparam json
    )
BEGIN
    SET @countpk = JSON_LENGTH(JSON_EXTRACT(fileuploadjson , '$[*].fileName'));
    SET @x1=0;
    START TRANSACTION;
    WHILE @x1  < @countpk DO
         
          CALL proc_createuploadfilename(JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(fileuploadjson , '$[*].fileName'),CONCAT('$[',@x1,']'))),tblname,@tempfileid);
                  
          INSERT INTO tbl_uploadedfile_master (uploadfile_tblname,
          uploadfile_actulalfilename,
          uploadfile_filename,
          uploadfile_type,
          uploadfile_path,
          uploadfile_tblpkid,
          uploadfile_status)
          SELECT tblname,
          JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(fileuploadjson , '$[*].fileName'),CONCAT('$[',@x1,']'))),
          @tempfileid,
          JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(fileuploadjson , '$[*].fileType'),CONCAT('$[',@x1,']'))),
          JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(fileuploadjson , '$[*].filePath'),CONCAT('$[',@x1,']'))),
          pkid,
          'Yes';
                   
          SET  @x1 = @x1 + 1;
         
    END WHILE ;
    UPDATE tbl_uploadedfile_master SET uploadfile_status='No' WHERE uploadfile_tblname=tblname AND uploadfile_tblpkid=pkid;
    COMMIT;
    SET SESSION group_concat_max_len=10000000000000;
       
    SET outparam=(SELECT CONCAT ('[',GROUP_CONCAT( json_object('uploadfile_actulalfilename',uploadfile_actulalfilename,'uploadfile_filename',uploadfile_filename,'uploadfile_type',uploadfile_type,'uploadfile_path',uploadfile_path,'uploadfile_status','Yes'  ) ),']')
     FROM tbl_uploadedfile_master WHERE uploadfile_tblname=tblname AND uploadfile_tblpkid=pkid);
   
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_uploadfile_master_updatejson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_uploadfile_master_updatejson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_uploadfile_master_updatejson`(
    IN tblname VARCHAR(500),
    IN pkid VARCHAR(100),
    IN fileuploadjson json,
    OUT outparam json
    )
BEGIN
    SET @countpk = JSON_LENGTH(JSON_EXTRACT(fileuploadjson , '$[*].fileName'));
    SET @x1=0;
    START TRANSACTION;
    WHILE @x1  < @countpk DO
         
         
         
        IF JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(fileuploadjson , '$[*].fileStatus'),CONCAT('$[',@x1,']'))) = 'Yes' THEN
               
          SELECT 'Yes',      JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(fileuploadjson , '$[*].fileName'),CONCAT('$[',@x1,']')));
          CALL proc_createuploadfilename(JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(fileuploadjson , '$[*].fileName'),CONCAT('$[',@x1,']'))),tblname,@tempfileid);
          
          INSERT INTO tbl_uploadedfile_master (uploadfile_tblname,
          uploadfile_actulalfilename,
          uploadfile_filename,
          uploadfile_type,
          uploadfile_path,
          uploadfile_tblpkid,
          uploadfile_status)
          SELECT tblname,
          JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(fileuploadjson , '$[*].fileName'),CONCAT('$[',@x1,']'))),
          @tempfileid,
          JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(fileuploadjson , '$[*].fileType'),CONCAT('$[',@x1,']'))),
          JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(fileuploadjson , '$[*].filePath'),CONCAT('$[',@x1,']'))),
          pkid,
          'Yes';
        END IF;
        IF JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(fileuploadjson , '$[*].fileStatus'),CONCAT('$[',@x1,']'))) = 'Delete' THEN
           
            SELECT 'Delete',      JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(fileuploadjson , '$[*].fileStatus'),CONCAT('$[',@x1,']')));
          -- select JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(fileuploadjson , '$[*].fileStatus'),CONCAT('$[',@x1,']'))), JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(fileuploadjson , '$[*].uploadfile_filename'),CONCAT('$[',@x1,']')));
          UPDATE tbl_uploadedfile_master SET uploadfile_status='Delete'
          WHERE uploadfile_tblname=tblname AND uploadfile_tblpkid=pkid
          AND uploadfile_filename=
          JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(fileuploadjson , '$[*].uploadfile_filename'),CONCAT('$[',@x1,']')));
       
         
        END IF;
        IF JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(fileuploadjson , '$[*].fileStatus'),CONCAT('$[',@x1,']'))) = 'No' THEN
           
         SELECT 'No',      JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(fileuploadjson , '$[*].uploadfile_filename'),CONCAT('$[',@x1,']')));
          -- select JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(fileuploadjson , '$[*].fileStatus'),CONCAT('$[',@x1,']'))), JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(fileuploadjson , '$[*].uploadfile_filename'),CONCAT('$[',@x1,']')));
          UPDATE tbl_uploadedfile_master SET uploadfile_status='Keep'
          WHERE uploadfile_tblname=tblname AND uploadfile_tblpkid=pkid
          AND uploadfile_filename=
          JSON_UNQUOTE(JSON_EXTRACT(JSON_EXTRACT(fileuploadjson , '$[*].uploadfile_filename'),CONCAT('$[',@x1,']')));
       
         
        END IF;
          SET  @x1 = @x1 + 1;
         
    END WHILE ;
   
    SET SESSION group_concat_max_len=10000000000000;
    UPDATE tbl_uploadedfile_master SET uploadfile_status='Delete'
          WHERE uploadfile_tblname=tblname AND uploadfile_tblpkid=pkid AND uploadfile_status='No';
   
    SET outparam=(SELECT CONCAT ('[',GROUP_CONCAT( json_object('uploadfile_actulalfilename',uploadfile_actulalfilename,'uploadfile_filename',uploadfile_filename,'uploadfile_type',uploadfile_type,'uploadfile_path',uploadfile_path,'uploadfile_status', IF (uploadfile_status='Keep','No',uploadfile_status)  ) ),']')
     FROM tbl_uploadedfile_master WHERE uploadfile_tblname=tblname AND uploadfile_tblpkid=pkid );
     
    DELETE FROM tbl_uploadedfile_master WHERE uploadfile_tblname=tblname AND uploadfile_tblpkid=pkid AND uploadfile_status = 'Delete';
   
    UPDATE tbl_uploadedfile_master SET uploadfile_status='No' WHERE uploadfile_tblname=tblname AND uploadfile_tblpkid=pkid;
   
    COMMIT;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_vw_city_state_country_details_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_vw_city_state_country_details_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_vw_city_state_country_details_selectjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('vw_city_state_country_details','',result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_vw_company_city_state_country_details_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_vw_company_city_state_country_details_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_vw_company_city_state_country_details_selectjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('vw_company_city_state_country_details','',result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_vw_membereducation_education_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_vw_membereducation_education_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_vw_membereducation_education_selectjson`(in ofcmembersessionid varchar(100), out outparam json)
BEGIN
	call proc_common_selectjson('vw_membereducation_education',concat('ofcmemsession_id=\'',ofcmembersessionid,'\''),outparam);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_vw_memberemployment_maincat_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_vw_memberemployment_maincat_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_vw_memberemployment_maincat_selectjson`(IN ofcmembersessionid VARCHAR(100), OUT outparam json)
BEGIN
	CALL proc_common_selectjson('vw_memberemployment_maincat',CONCAT('ofcmemsession_id=\'',ofcmembersessionid,'\''),outparam);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_vw_memberexperience_maincat_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_vw_memberexperience_maincat_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_vw_memberexperience_maincat_selectjson`(in ofcmembersessionid varchar(100), out outparam json)
BEGIN
	call proc_common_selectjson('vw_memberexperience_maincat',concat('ofcmemsession_id=\'',ofcmembersessionid,'\''),outparam);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_vw_membermyproject_maincat_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_vw_membermyproject_maincat_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_vw_membermyproject_maincat_selectjson`(in ofcmembersessionid varchar(100), out outparam json)
BEGIN
	call proc_common_selectjson('vw_membermyproject_maincat',concat('ofcmemsession_id=\'',ofcmembersessionid,'\''),outparam);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_vw_ofcmember_certificate_byofcmember_id_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_vw_ofcmember_certificate_byofcmember_id_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_vw_ofcmember_certificate_byofcmember_id_selectjson`(IN ofcmembers_id_param VARCHAR(100),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';
-- fun_decrypt nned to integrate this %%$$$
CALL proc_common_selectjson('vw_ofcmember_certificate_byofcmember_id',CONCAT('ofcmembers_id=','\'',  ofcmembers_id_param,'\''),result);COMMIT;SET Isuccess = TRUE;SET outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_vw_ofcmember_employment_byofcmember_id_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_vw_ofcmember_employment_byofcmember_id_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_vw_ofcmember_employment_byofcmember_id_selectjson`(IN ofcmembers_id_param VARCHAR(100),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';
-- fun_decrypt nned to integrate this %%$$$
CALL proc_common_selectjson('vw_ofcmember_employment_byofcmember_id',CONCAT('ofcmembers_id=','\'', ofcmembers_id_param,'\''),result);COMMIT;SET Isuccess = TRUE;SET outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_vw_ofcmember_experience_byofcmember_id_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_vw_ofcmember_experience_byofcmember_id_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_vw_ofcmember_experience_byofcmember_id_selectjson`(IN ofcmembers_id_param VARCHAR(100),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';
-- fun_decrypt nned to integrate this %%$$$
CALL proc_common_selectjson('vw_ofcmember_experience_byofcmember_id',CONCAT('ofcmembers_id=','\'', ofcmembers_id_param,'\''),result);COMMIT;SET Isuccess = TRUE;SET outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_vw_popuplarsearch_homepage_filesimages_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_vw_popuplarsearch_homepage_filesimages_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_vw_popuplarsearch_homepage_filesimages_selectjson`(in imgpath longtext, OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('vw_popuplarsearch_homepage_filesimages','',result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_vw_state_country_details` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_vw_state_country_details` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_vw_state_country_details`(IN country_id_param varchar(100),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('vw_state_country_details',concat('country_id=','\'',country_id_param,'\''),result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_vw_state_country_details_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_vw_state_country_details_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_vw_state_country_details_selectjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('vw_state_country_details','',result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_vw_subcat_keyword_details_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_vw_subcat_keyword_details_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_vw_subcat_keyword_details_selectjson`(IN subcat_id_param varchar(100),OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('vw_subcat_keyword_details',concat('subcat_id=','\'',subcat_id_param,'\''),result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

/* Procedure structure for procedure `proc_vw_subcat_maincat_details_selectjson` */

/*!50003 DROP PROCEDURE IF EXISTS  `proc_vw_subcat_maincat_details_selectjson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_vw_subcat_maincat_details_selectjson`(OUT result json,OUT outparam json)
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
SET Controlid ='';SET Error = 'SQL Exception';
 GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
GET CURRENT DIAGNOSTICS errcount = NUMBER;
IF errcount = 0  THEN SELECT '1mapped insert succeeded, current DA is empty' AS op;
SET Error = 'mapped insert succeeded, current DA is empty' ;
ELSE GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;END IF ;GET STACKED DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;SET Error = CONCAT("ERROR ", errno, " : ", msg);SET outparam =  (SELECT JSON_OBJECT('Isuccess', Isuccess, 'Error', Error,'Validation', Validation,'Controlid', Controlid));ROLLBACK;END;START TRANSACTION;SET Isuccess =FALSE;SET  Validation ='';SET Error ='';SET Controlid ='';CALL proc_common_selectjson('vw_subcat_maincat_details','',result);COMMIT;SET Isuccess = TRUE;set outparam='[]';END */$$
DELIMITER ;

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
 `ofcmembereducation_title` varchar(500) ,
 `ofcmembereducation_specilization` longtext ,
 `ofcmembereducation_startdate` datetime ,
 `ofcmembereducation_enddate` datetime ,
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

/*Table structure for table `vw_ofcmember_certificate_byofcmember_id` */

DROP TABLE IF EXISTS `vw_ofcmember_certificate_byofcmember_id`;

/*!50001 DROP VIEW IF EXISTS `vw_ofcmember_certificate_byofcmember_id` */;
/*!50001 DROP TABLE IF EXISTS `vw_ofcmember_certificate_byofcmember_id` */;

/*!50001 CREATE TABLE  `vw_ofcmember_certificate_byofcmember_id`(
 `ofcmembercertificate_id` varchar(50) ,
 `certificate_id` varchar(50) ,
 `ofcmembers_id` varchar(50) ,
 `certification_name` varchar(500) 
)*/;

/*Table structure for table `vw_ofcmember_city_state_country` */

DROP TABLE IF EXISTS `vw_ofcmember_city_state_country`;

/*!50001 DROP VIEW IF EXISTS `vw_ofcmember_city_state_country` */;
/*!50001 DROP TABLE IF EXISTS `vw_ofcmember_city_state_country` */;

/*!50001 CREATE TABLE  `vw_ofcmember_city_state_country`(
 `ofcmembers_id` varchar(50) ,
 `ofcmembers_fname` varchar(500) ,
 `ofcmembers_mname` varchar(500) ,
 `ofcmembers_lname` varchar(500) ,
 `ofcmembers_name` varchar(1000) ,
 `ofcmember_type` varchar(50) ,
 `city_id` varchar(50) ,
 `ofcmembers_emailid` varchar(500) ,
 `ofcmembers_password` varchar(500) ,
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
 `ofcmembers_nosofteammembers` int(11) ,
 `status` varchar(10) ,
 `country_id` varchar(50) ,
 `country_name` varchar(1000) ,
 `state_id` varchar(50) ,
 `state_name` varchar(1000) ,
 `city_name` varchar(1000) 
)*/;

/*Table structure for table `vw_ofcmember_employment_byofcmember_id` */

DROP TABLE IF EXISTS `vw_ofcmember_employment_byofcmember_id`;

/*!50001 DROP VIEW IF EXISTS `vw_ofcmember_employment_byofcmember_id` */;
/*!50001 DROP TABLE IF EXISTS `vw_ofcmember_employment_byofcmember_id` */;

/*!50001 CREATE TABLE  `vw_ofcmember_employment_byofcmember_id`(
 `ofcmememployment_id` varchar(50) ,
 `maincat_id` varchar(50) ,
 `ofcmememployment_name` varchar(500) ,
 `ofcmememployment_description` longtext ,
 `ofcmememployment_role` varchar(500) ,
 `ofcmememployment_startdate` datetime ,
 `ofcmememployment_enddate` datetime ,
 `ofcmembers_id` varchar(50) ,
 `maincat_name` varchar(500) 
)*/;

/*Table structure for table `vw_ofcmember_experience_byofcmember_id` */

DROP TABLE IF EXISTS `vw_ofcmember_experience_byofcmember_id`;

/*!50001 DROP VIEW IF EXISTS `vw_ofcmember_experience_byofcmember_id` */;
/*!50001 DROP TABLE IF EXISTS `vw_ofcmember_experience_byofcmember_id` */;

/*!50001 CREATE TABLE  `vw_ofcmember_experience_byofcmember_id`(
 `ofcmemexperience_id` varchar(50) ,
 `maincat_id` varchar(50) ,
 `ofcmemexperience_name` varchar(500) ,
 `ofcmemexperience_description` longtext ,
 `ofcmemexperience_role` varchar(500) ,
 `ofcmemexperience_startdate` datetime ,
 `ofcmemexperience_enddate` datetime ,
 `ofcmembers_id` varchar(50) 
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

/*Table structure for table `vw_ofcmember_skill` */

DROP TABLE IF EXISTS `vw_ofcmember_skill`;

/*!50001 DROP VIEW IF EXISTS `vw_ofcmember_skill` */;
/*!50001 DROP TABLE IF EXISTS `vw_ofcmember_skill` */;

/*!50001 CREATE TABLE  `vw_ofcmember_skill`(
 `ofcmemberskill_id` bigint(50) ,
 `skill_id` varchar(50) ,
 `ofcmembers_id` varchar(50) ,
 `skill_name` varchar(500) 
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

/*Table structure for table `vw_vwofcmember_city_state_country_submitproposal_details` */

DROP TABLE IF EXISTS `vw_vwofcmember_city_state_country_submitproposal_details`;

/*!50001 DROP VIEW IF EXISTS `vw_vwofcmember_city_state_country_submitproposal_details` */;
/*!50001 DROP TABLE IF EXISTS `vw_vwofcmember_city_state_country_submitproposal_details` */;

/*!50001 CREATE TABLE  `vw_vwofcmember_city_state_country_submitproposal_details`(
 `ofcmembers_fname` varchar(500) ,
 `ofcmembers_mname` varchar(500) ,
 `ofcmembers_lname` varchar(500) ,
 `ofcmembers_name` varchar(1000) ,
 `ofcmember_type` varchar(50) ,
 `city_id` varchar(50) ,
 `ofcmembers_emailid` varchar(500) ,
 `ofcmembers_password` varchar(500) ,
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
 `ofcmembers_nosofteammembers` int(11) ,
 `city_name` varchar(1000) ,
 `country_name` varchar(1000) ,
 `state_name` varchar(1000) ,
 `ofcsubmitproposal_id` varchar(50) ,
 `ofcprojectpost_id_fksubmitproposal` varchar(50) ,
 `ofcmembers_id_fksubmitproposal` varchar(50) ,
 `ofcsubmitproposal_coverletter` longtext ,
 `ofcsubmitproposal_budget` decimal(10,0) ,
 `ofcsubmitproposal_negotiable` varchar(50) ,
 `ofcsubmitproposal_commissionpercentage` decimal(10,0) ,
 `ofcsubmitproposal_commissionamount` decimal(10,0) ,
 `ofcsubmitproposal_finalamount` decimal(10,0) ,
 `ofcsubmitproposal_timeframe` varchar(50) ,
 `ofcsubmitproposal_availability` varchar(100) ,
 `ofcsubmitproposal_status` varchar(100) ,
 `ofcsubmitproposal_remarks` longtext ,
 `ofcsubmitproposal_terms` longtext ,
 `ofcsubmitproposal_estimatestartdate` datetime ,
 `ofcsubmitproposal_startdate` datetime ,
 `ofcsubmitproposal_enddate` datetime ,
 `ofcsubmitproposal_estimatedays` int(11) ,
 `ofcsubmitproposal_estimatedhoursindays` decimal(10,0) ,
 `ofcsubmitproposal_reportabusebyemployeer` varchar(50) ,
 `ofcsubmitproposal_reportabusebyfreelancer` varchar(50) ,
 `ofcsubmitproposal_proposalacceptdate` datetime ,
 `ofcsubmitproposal_proposalrejectdate` datetime ,
 `ofcsubmitproposal_completeddate` datetime ,
 `ofcsubmitproposal_iscompletedbyemployeer` varchar(50) ,
 `ofcsubmitproposal_iscompletedbyfreelancer` varchar(50) ,
 `ofcsubmitproposal_workstatus` varchar(500) ,
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

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_membereducation_education` AS (select `a`.`ofcmembereducation_id` AS `ofcmembereducation_id`,`a`.`ofcmembers_id` AS `ofcmembers_id`,`a`.`education_id` AS `education_id`,`a`.`ofcmembereducation_title` AS `ofcmembereducation_title`,`a`.`ofcmembereducation_specilization` AS `ofcmembereducation_specilization`,`a`.`ofcmembereducation_startdate` AS `ofcmembereducation_startdate`,`a`.`ofcmembereducation_enddate` AS `ofcmembereducation_enddate`,`a`.`createdate` AS `createdate`,`a`.`modifieddate` AS `modifieddate`,`a`.`status` AS `status`,`b`.`education_name` AS `education_name`,`c`.`ofcmemsession_id` AS `ofcmemsession_id`,`c`.`ofcmemsession_deviceid` AS `ofcmemsession_deviceid`,`c`.`ofcmemsession_devicetype` AS `ofcmemsession_devicetype` from ((`tbl_ofcmembereducation_details` `a` join `tbl_education_master` `b`) join `tbl_ofcmemsession_details` `c`) where ((`a`.`education_id` = `b`.`education_id`) and (`a`.`ofcmembers_id` = `c`.`ofcmembers_id`) and (`c`.`status` = 'active'))) */;

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

/*View structure for view vw_ofcmember_certificate_byofcmember_id */

/*!50001 DROP TABLE IF EXISTS `vw_ofcmember_certificate_byofcmember_id` */;
/*!50001 DROP VIEW IF EXISTS `vw_ofcmember_certificate_byofcmember_id` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_ofcmember_certificate_byofcmember_id` AS (select `a`.`ofcmembercertificate_id` AS `ofcmembercertificate_id`,`a`.`certificate_id` AS `certificate_id`,`a`.`ofcmembers_id` AS `ofcmembers_id`,`b`.`certification_name` AS `certification_name` from (`tbl_ofcmembercertificate_details` `a` join `tbl_certification_master` `b`) where (`a`.`certificate_id` = `b`.`certification_id`)) */;

/*View structure for view vw_ofcmember_city_state_country */

/*!50001 DROP TABLE IF EXISTS `vw_ofcmember_city_state_country` */;
/*!50001 DROP VIEW IF EXISTS `vw_ofcmember_city_state_country` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_ofcmember_city_state_country` AS (select `a`.`ofcmembers_id` AS `ofcmembers_id`,`a`.`ofcmembers_fname` AS `ofcmembers_fname`,`a`.`ofcmembers_mname` AS `ofcmembers_mname`,`a`.`ofcmembers_lname` AS `ofcmembers_lname`,`a`.`ofcmembers_name` AS `ofcmembers_name`,`a`.`ofcmember_type` AS `ofcmember_type`,`a`.`city_id` AS `city_id`,`a`.`ofcmembers_emailid` AS `ofcmembers_emailid`,`a`.`ofcmembers_password` AS `ofcmembers_password`,`a`.`ofcmembers_address1` AS `ofcmembers_address1`,`a`.`ofcmembers_address2` AS `ofcmembers_address2`,`a`.`ofcmembers_pincode` AS `ofcmembers_pincode`,`a`.`ofcmembers_contactnos` AS `ofcmembers_contactnos`,`a`.`ofcmembers_availability` AS `ofcmembers_availability`,`a`.`ofcmembers_displayname` AS `ofcmembers_displayname`,`a`.`ofcmembers_description` AS `ofcmembers_description`,`a`.`ofcmembers_selfrating` AS `ofcmembers_selfrating`,`a`.`ofcmembers_experiencelevel` AS `ofcmembers_experiencelevel`,`a`.`ofcmembers_gender` AS `ofcmembers_gender`,`a`.`ofcmembers_dob` AS `ofcmembers_dob`,`a`.`ofcmembers_nosofteammembers` AS `ofcmembers_nosofteammembers`,`a`.`status` AS `status`,`b`.`country_id` AS `country_id`,`b`.`country_name` AS `country_name`,`c`.`state_id` AS `state_id`,`c`.`state_name` AS `state_name`,`d`.`city_name` AS `city_name` from (((`tbl_ofcmembers_master` `a` join `tbl_country_master` `b`) join `tbl_state_master` `c`) join `tbl_city_master` `d`) where ((`a`.`city_id` = `d`.`city_id`) and (`d`.`state_id` = `c`.`state_id`) and (`c`.`country_id` = `b`.`country_id`))) */;

/*View structure for view vw_ofcmember_employment_byofcmember_id */

/*!50001 DROP TABLE IF EXISTS `vw_ofcmember_employment_byofcmember_id` */;
/*!50001 DROP VIEW IF EXISTS `vw_ofcmember_employment_byofcmember_id` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_ofcmember_employment_byofcmember_id` AS (select `a`.`ofcmememployment_id` AS `ofcmememployment_id`,`a`.`maincat_id` AS `maincat_id`,`a`.`ofcmememployment_name` AS `ofcmememployment_name`,`a`.`ofcmememployment_description` AS `ofcmememployment_description`,`a`.`ofcmememployment_role` AS `ofcmememployment_role`,`a`.`ofcmememployment_startdate` AS `ofcmememployment_startdate`,`a`.`ofcmememployment_enddate` AS `ofcmememployment_enddate`,`a`.`ofcmembers_id` AS `ofcmembers_id`,`b`.`maincat_name` AS `maincat_name` from (`tbl_ofcmemberemployment_details` `a` join `tbl_maincat_master` `b`) where (`a`.`maincat_id` = `b`.`maincat_id`)) */;

/*View structure for view vw_ofcmember_experience_byofcmember_id */

/*!50001 DROP TABLE IF EXISTS `vw_ofcmember_experience_byofcmember_id` */;
/*!50001 DROP VIEW IF EXISTS `vw_ofcmember_experience_byofcmember_id` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_ofcmember_experience_byofcmember_id` AS (select `a`.`ofcmemexperience_id` AS `ofcmemexperience_id`,`a`.`maincat_id` AS `maincat_id`,`a`.`ofcmemexperience_name` AS `ofcmemexperience_name`,`a`.`ofcmemexperience_description` AS `ofcmemexperience_description`,`a`.`ofcmemexperience_role` AS `ofcmemexperience_role`,`a`.`ofcmemexperience_startdate` AS `ofcmemexperience_startdate`,`a`.`ofcmemexperience_enddate` AS `ofcmemexperience_enddate`,`b`.`ofcmembers_id` AS `ofcmembers_id` from (`tbl_ofcmemberexperience_details` `a` join `tbl_ofcmembers_master` `b`) where (`a`.`ofcmembers_id` = `b`.`ofcmembers_id`)) */;

/*View structure for view vw_ofcmember_myproject */

/*!50001 DROP TABLE IF EXISTS `vw_ofcmember_myproject` */;
/*!50001 DROP VIEW IF EXISTS `vw_ofcmember_myproject` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_ofcmember_myproject` AS (select '-' AS `ofcmembers_id`,`a`.`ofcmemmyproject_title` AS `ofcmemmyproject_title`,`a`.`ofcmemmyproject_url` AS `ofcmemmyproject_url`,`a`.`ofcmemmyproject_description` AS `ofcmemmyproject_description`,`a`.`createdate` AS `createdate`,`a`.`modifieddate` AS `modifieddate`,`a`.`status` AS `status`,`a`.`maincat_id` AS `maincat_id`,`a`.`ofcmemmyproject_id` AS `ofcmemmyproject_id` from `tbl_ofcmembermyproject_details` `a`) */;

/*View structure for view vw_ofcmember_skill */

/*!50001 DROP TABLE IF EXISTS `vw_ofcmember_skill` */;
/*!50001 DROP VIEW IF EXISTS `vw_ofcmember_skill` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_ofcmember_skill` AS (select `a`.`ofcmemberskill_id` AS `ofcmemberskill_id`,`a`.`skill_id` AS `skill_id`,`a`.`ofcmembers_id` AS `ofcmembers_id`,`b`.`skill_name` AS `skill_name` from (`tbl_ofcmemberskill_details` `a` join `tbl_skill_master` `b`) where (`a`.`skill_id` = `b`.`skill_id`)) */;

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

/*View structure for view vw_vwofcmember_city_state_country_submitproposal_details */

/*!50001 DROP TABLE IF EXISTS `vw_vwofcmember_city_state_country_submitproposal_details` */;
/*!50001 DROP VIEW IF EXISTS `vw_vwofcmember_city_state_country_submitproposal_details` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_vwofcmember_city_state_country_submitproposal_details` AS (select `a`.`ofcmembers_fname` AS `ofcmembers_fname`,`a`.`ofcmembers_mname` AS `ofcmembers_mname`,`a`.`ofcmembers_lname` AS `ofcmembers_lname`,`a`.`ofcmembers_name` AS `ofcmembers_name`,`a`.`ofcmember_type` AS `ofcmember_type`,`a`.`city_id` AS `city_id`,`a`.`ofcmembers_emailid` AS `ofcmembers_emailid`,`a`.`ofcmembers_password` AS `ofcmembers_password`,`a`.`ofcmembers_address1` AS `ofcmembers_address1`,`a`.`ofcmembers_address2` AS `ofcmembers_address2`,`a`.`ofcmembers_pincode` AS `ofcmembers_pincode`,`a`.`ofcmembers_contactnos` AS `ofcmembers_contactnos`,`a`.`ofcmembers_availability` AS `ofcmembers_availability`,`a`.`ofcmembers_displayname` AS `ofcmembers_displayname`,`a`.`ofcmembers_description` AS `ofcmembers_description`,`a`.`ofcmembers_selfrating` AS `ofcmembers_selfrating`,`a`.`ofcmembers_experiencelevel` AS `ofcmembers_experiencelevel`,`a`.`ofcmembers_gender` AS `ofcmembers_gender`,`a`.`ofcmembers_dob` AS `ofcmembers_dob`,`a`.`ofcmembers_nosofteammembers` AS `ofcmembers_nosofteammembers`,`a`.`city_name` AS `city_name`,`a`.`country_name` AS `country_name`,`a`.`state_name` AS `state_name`,`b`.`ofcsubmitproposal_id` AS `ofcsubmitproposal_id`,`b`.`ofcprojectpost_id_fksubmitproposal` AS `ofcprojectpost_id_fksubmitproposal`,`b`.`ofcmembers_id_fksubmitproposal` AS `ofcmembers_id_fksubmitproposal`,`b`.`ofcsubmitproposal_coverletter` AS `ofcsubmitproposal_coverletter`,`b`.`ofcsubmitproposal_budget` AS `ofcsubmitproposal_budget`,`b`.`ofcsubmitproposal_negotiable` AS `ofcsubmitproposal_negotiable`,`b`.`ofcsubmitproposal_commissionpercentage` AS `ofcsubmitproposal_commissionpercentage`,`b`.`ofcsubmitproposal_commissionamount` AS `ofcsubmitproposal_commissionamount`,`b`.`ofcsubmitproposal_finalamount` AS `ofcsubmitproposal_finalamount`,`b`.`ofcsubmitproposal_timeframe` AS `ofcsubmitproposal_timeframe`,`b`.`ofcsubmitproposal_availability` AS `ofcsubmitproposal_availability`,`b`.`ofcsubmitproposal_status` AS `ofcsubmitproposal_status`,`b`.`ofcsubmitproposal_remarks` AS `ofcsubmitproposal_remarks`,`b`.`ofcsubmitproposal_terms` AS `ofcsubmitproposal_terms`,`b`.`ofcsubmitproposal_estimatestartdate` AS `ofcsubmitproposal_estimatestartdate`,`b`.`ofcsubmitproposal_startdate` AS `ofcsubmitproposal_startdate`,`b`.`ofcsubmitproposal_enddate` AS `ofcsubmitproposal_enddate`,`b`.`ofcsubmitproposal_estimatedays` AS `ofcsubmitproposal_estimatedays`,`b`.`ofcsubmitproposal_estimatedhoursindays` AS `ofcsubmitproposal_estimatedhoursindays`,`b`.`ofcsubmitproposal_reportabusebyemployeer` AS `ofcsubmitproposal_reportabusebyemployeer`,`b`.`ofcsubmitproposal_reportabusebyfreelancer` AS `ofcsubmitproposal_reportabusebyfreelancer`,`b`.`ofcsubmitproposal_proposalacceptdate` AS `ofcsubmitproposal_proposalacceptdate`,`b`.`ofcsubmitproposal_proposalrejectdate` AS `ofcsubmitproposal_proposalrejectdate`,`b`.`ofcsubmitproposal_completeddate` AS `ofcsubmitproposal_completeddate`,`b`.`ofcsubmitproposal_iscompletedbyemployeer` AS `ofcsubmitproposal_iscompletedbyemployeer`,`b`.`ofcsubmitproposal_iscompletedbyfreelancer` AS `ofcsubmitproposal_iscompletedbyfreelancer`,`b`.`ofcsubmitproposal_workstatus` AS `ofcsubmitproposal_workstatus`,`b`.`createdate` AS `createdate`,`b`.`modifieddate` AS `modifieddate`,`b`.`status` AS `status` from (`vw_ofcmember_city_state_country` `a` join `tbl_ofcsubmitproposal_details` `b`) where (`a`.`ofcmembers_id` = `b`.`ofcmembers_id_fksubmitproposal`)) */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
