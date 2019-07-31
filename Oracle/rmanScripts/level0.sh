#!/bin/bash

echo "=========================================================" >> /dbbackup/level0-1.log
echo "===============fulldb "`(date +%F)`"=====================" >> /dbbackup/level0-1.log
echo "===============Full RMAN Backup Begin====================" >> /dbbackup/level0-1.log

export ORACLE_HOME=/u01/app/oracle/product/11.2.0/dbhome_1
export ORACLE_SID=orcdb
export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK
export NLS_DATE_FORMAT='YYYY-MON-DD HH24:MI:SS'

/u01/app/oracle/product/11.2.0/dbhome_1/bin/rman target / cmdfile /u01/exec/level0.rmn log /dbbackup/level0-1.log append

echo "===============fulldb "`(date +%F)`"======================" >> /dbbackup/level0-1.log
echo "===============Level0 RMAN Backup End=====================" >> /dbbackup/level0-1.log
