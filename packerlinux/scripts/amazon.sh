#!/bin/bash

sleep 5

sudo yum install -y httpd php php-mysql
sudo chkconfig httpd on
