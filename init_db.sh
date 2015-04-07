#!/bin/bash
service mysql start
mysql -u root -e "SET wsrep_on=OFF; DELETE FROM mysql.user WHERE user='';"
mysql -u root -e "SET wsrep_on=OFF; GRANT ALL ON *.* TO 'wsrep_sst-user'@'%' IDENTIFIED BY 'password';"
service mysql stop
