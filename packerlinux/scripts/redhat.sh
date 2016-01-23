#!/bin/bash

sleep 5

sudo sed -i 's/SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
sudo yum install -y httpd php php-mysql
sudo chkconfig httpd on
