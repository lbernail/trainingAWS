#!/bin/bash

sed -i 's/##DBHOST##/${db_endpoint}/g' /var/www/html/application.properties
sed -i 's/##DATABASE##/${db_instance}/g' /var/www/html/application.properties
sed -i 's/##DBUSER##/${db_user}/g' /var/www/html/application.properties
sed -i 's/##DBPASSWORD##/${db_password}/g' /var/www/html/application.properties
