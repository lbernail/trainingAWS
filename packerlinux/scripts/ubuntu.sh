#!/bin/bash

sleep 5

export DEBIAN_FRONTEND=noninteractive

sudo -E apt-get update -q
sudo -E apt-get install -y apache2 php5 libapache2-mod-php5 php5-curl php5-mysql
