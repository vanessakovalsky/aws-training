#!/bin/bash

yum update -y
amazon-linux-extras enable php7.4
yum install -y httpd
yum install -y mariadb-server
yum install -y php-cli php-pdo php-fpm php-json php-mysqlnd
sudo service mariadb start
sudo service httpd start
mysqladmin -u root create blog

cd /var/www/html
sudo wget http://wordpress.org/latest.tar.gz
sudo tar -xzvf latest.tar.gz
sudo mv wordpress/* .
sudo rm -rf wordpress

exit
