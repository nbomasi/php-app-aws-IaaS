
## This file is a virtual hosting file that will enable me host 2 web site on a single apache server

#!/bin/bash
sudo yum update -y
sudo yum install httpd git -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo mkdir /var/www/tooling.com
sudo mkdir /var/www/tooling1.com
# Clone source code
git clone https://github.com/nbomasi/tooling-1.git
git clone https://github.com/darey-devops/tooling.git
sudo cp -rf tooling-1/html /var/www/tooling.com
sudo cp -rf tooling/html /var/www/tooling1.com
# Change ownership to any current user 
sudo chown -R $USER:$USER /var/www/tooling.com/html
sudo chown -R $USER:$USER /var/www/tooling1.com/html
sudo chmod -R 755 /var/www
# Create New Virtual Host Files
sudo mkdir /etc/httpd/sites-available
sudo mkdir /etc/httpd/sites-enabled
sudo echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf
sudo touch /etc/httpd/sites-available/tooling.com.conf
sudo cat <<EOT>> /etc/httpd/sites-available/tooling.com.conf
<VirtualHost *:80>
    ServerName www.tooling.com
    ServerAlias tooling.com
    DocumentRoot /var/www/tooling.com/html
    ErrorLog /var/www/tooling.com/error.log
    CustomLog /var/www/tooling.com/requests.log combined
</VirtualHost>
EOT
sudo touch /etc/httpd/sites-available/tooling1.com.conf
sudo cat <<EOT>> /etc/httpd/sites-available/tooling1.com.conf
<VirtualHost *:8084>
    ServerName www.tooling1.com
    ServerAlias tooling1.com
    DocumentRoot /var/www/tooling1.com/html
    ErrorLog /var/www/tooling1.com/error.log
    CustomLog /var/www/tooling1.com/requests.log combined
</VirtualHost>
EOT
sudo echo "Listen 8084" >> /etc/httpd/conf/httpd.conf
# Enable the new virtual host
#sudo unlink /etc/httpd/sites-enabled/tooling2.com.conf
sudo ln -s /etc/httpd/sites-available/tooling.com.conf /etc/httpd/sites-enabled/tooling.com.conf
sudo ln -s /etc/httpd/sites-available/tooling1.com.conf /etc/httpd/sites-enabled/tooling1.com.conf
# To disable SElinux
sudo setenforce 0 
sudo systemctl restart httpd
DATABASE_PASS='admin123'
#This script installs and configure apache webserver for tooling website
sudo yum update -y
# yum install epel-release -y
# sudo dnf module reset php
# sudo dnf install -y php php-opcache php-gd php-curl php-mysqlnd git
# sudo systemctl start php-fpm
# sudo systemctl enable php-fpm
# sudo setsebool -P httpd_execmem 1
# sudo setenforce 0 
# yum install mysql -y
# Setting up database credential for tooling.com
mysql -h 172.31.42.211 -u webaccess -p"$DATABASE_PASS" tooling < tooling-1/tooling-db.sql
sudo sed -i 's/mysql.tooling.svc.cluster.local/172.31.42.211/1' /var/www/tooling.com/html/functions.php
sudo sed -i 's/admin/webaccess/; s/admin/admin123/' /var/www/tooling.com/html/functions.php 
# Setting up database credential for tooling1.com
mysql -h 172.31.42.211 -u boma -p"$DATABASE_PASS" toolingdb < tooling/html/tooling_db_schema.sql
sudo sed -i 's/mysqlserverhost/172.31.42.211/1' /var/www/tooling1.com/html/.env
sudo sed -i 's/Admin/boma/1' /var/www/tooling1.com/html/.env
sudo sed -i 's/Admin.com/admin123/1' /var/www/tooling1.com/html/.env
#sudo sed -i 's/Admin.com/$DATABASE_PASS/1' /var/www/tooling1.com/html/.env
sudo sed -i 's/boma.com/admin123/1' /var/www/tooling1.com/html/.env
sudo echo "ServerName localhost" >> /etc/httpd/conf/httpd.conf
#sudo echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf
#sudo echo "Listen 8070" >> /etc/httpd/conf/httpd.conf
sudo systemctl restart httpd




#http://<public-IP-of-Web-server:80> to view the tooling.com
#http://<public-IP-of-Web-server:8084> to view the tooling1.com

# No need for the following if selinux had been disabled
# chcon -u system_u -t httpd_log_t /var/www/example1.com/error.log
# chcon -u system_u -t httpd_log_t /var/www/example1.com/requests.log

