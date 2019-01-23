#!/bin/sh

D=`date --date="yesterday" +%Y-%m-%d`
#D=2013-07-26

sqoop import \
--connect jdbc:mysql://******/retail_db \
--username ****** \
--password ****** \
--fields-terminated-by ',' \
--target-dir /user/tbhangale/sqoop_import/retail_db/orders/${D} \
-e "select * from orders where DATE(order_date)='${D}' AND \$CONDITIONS" \
--split-by order_id

hive -S -e 'use 'tbhangale'; MSCK REPAIR TABLE tbhangale.orders; select * from orders limit 5;'

OR
hive -S -e 'use 'tbhangale'; ALTER TABLE orders ADD PARTITION (order_date='${D}') location '/user/tbhangale/sqoop_import/retail_db/orders/${D}';'

