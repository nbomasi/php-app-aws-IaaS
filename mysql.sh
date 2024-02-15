#!/bin/bash

#Insfrastructure: EC2 instance
# OS: Ubuntu
DATABASE_PASS='admin123'
sudo yum update -y
sudo yum install mysql-server -y
sudo yum install git zip unzip -y


# starting & enabling mysql-server
sudo systemctl start mysqld
sudo systemctl enable mysqld
#cd /tmp/
#git clone -b main https://github.com/hkhcoder/vprofile-project.git
#restore the dump file for the application
sudo mysqladmin -u root password "$DATABASE_PASS"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"
sudo mysql -u root -p"$DATABASE_PASS" -e "create database tooling"
#sudo mysql -u root -p"$DATABASE_PASS" -e "create user'ehi'@'%' identified by 'admin123'"
sudo mysql -u root -p"$DATABASE_PASS" -e "CREATE USER 'webaccess'@'%' IDENTIFIED BY 'admin123'"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on tooling.* TO 'webaccess'@'%'"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"
sudo mysql -u root -p"$DATABASE_PASS" -e "create database toolingdb"
sudo mysql -u root -p"$DATABASE_PASS" -e "CREATE USER 'boma'@'%' IDENTIFIED BY 'admin123'"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on toolingdb.* TO 'boma'@'%'"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

# Restart mysql-server
sudo systemctl restart mysqld


#starting the firewall and allowing the mysql to access from port no. 3306
# sudo systemctl start firewalld
# sudo systemctl enable firewalld
# sudo firewall-cmd --get-active-zones
# sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
# sudo firewall-cmd --reload
#sudo systemctl restart mysql

# CREATE USER 'osas'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'admin123';
# create user'ehi'@'%' identified by 'admin123';