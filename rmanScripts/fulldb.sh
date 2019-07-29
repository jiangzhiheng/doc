#!/bin/bash

echo "=========================================================" >> /dbbackup/fulldb.log
echo "===============fulldb "`(date +%F)`"=====================" >> /dbbackup/fulldb.log
echo "===============Full RMAN Backup Begin====================" >> /dbbackup/fulldb.log

export ORACLE_HOME=/u01/app/oracle/product/11.2.0/dbhome_1
export ORACLE_SID=orcdb
export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK
export NLS_DATE_FORMAT='YYYY-MON-DD HH24:MI:SS'

/u01/app/oracle/product/11.2.0/dbhome_1/bin/rman target / cmdfile /u01/exec/full.rmn log /dbbackup/fulldb.log append

echo "===============fulldb "`(date +%F)`"=====================" >> /dbbackup/fulldb.log
echo "===============Full RMAN Backup End======================" >> /dbbackup/fulldb.log
