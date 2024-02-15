#!/bin/bash

#Insfrastructure: EC2 instance
# OS: Redhat
DATABASE_PASS='admin123'
#This script installs and configure apache webserver for tooling website
sudo yum update -y

yum install epel-release -y

sudo dnf module reset php

sudo dnf install -y php php-opcache php-gd php-curl php-mysqlnd git

sudo systemctl start php-fpm

sudo systemctl enable php-fpm

sudo setsebool -P httpd_execmem 1

sudo setenforce 0 

yum install mysql -y

# Setting up database credential for tooling.com
mysql -h 172.31.38.219 -u webaccess -p"$DATABASE_PASS" tooling < tooling-1/tooling-db.sql

sudo sed -i 's/mysql.tooling.svc.cluster.local/172.31.38.219/1' /var/www/html/functions.php

sudo sed -i 's/admin/webaccess/; s/admin/admin123/' /var/www/html/functions.php 

# Setting up database credential for tooling1.com
mysql -h 172.31.38.219 -u boma -p"$DATABASE_PASS" toolingdb < tooling/html/tooling-db.sql
sudo sed -i 's/mysqlserverhost/172.31.38.219/1' /var/www/html/.env
sudo sed -i 's/Admin/boma/1' /var/www/html/.env
sudo sed -i 's/Admin.com/admin123/1' /var/www/html/.env

sudo systemctl restart httpd





