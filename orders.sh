#!/bin/sh

D=`date --date="yesterday" +%Y-%m-%d`
#D=2013-07-26

sqoop import \
--connect jdbc:mysql://ms.itversity.com:3306/retail_db \
--username retail_user \
--password itversity \
--fields-terminated-by ',' \
--target-dir /user/tbhangale/sqoop_import/retail_db/orders/${D} \
-e "select * from orders where DATE(order_date)='${D}' AND \$CONDITIONS" \
--split-by order_id

//to hive prompt
hive -S -e 'use 'tbhangale'; MSCK REPAIR TABLE tbhangale.orders;'
