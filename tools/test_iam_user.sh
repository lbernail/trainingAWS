#!/bin/bash
set -e


csv_credentials=$1

# set region
export AWS_DEFAULT_REGION=${2:-eu-west-1}

group="admin"

while read -r line || [ -n "$line" ]
#while read -r line
do
    # delete end of line
    line=${line//[[:space:]]/,}
    # set variables
    read url login passwd AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY trash <<< ${line//,/ }
    echo "Testing account $login"

    # export credentials
    export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY

    # test account
    aws ec2 describe-instances

done < $csv_credentials
