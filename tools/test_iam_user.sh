#!/bin/bash
set -e


csv_credentials=$1

# set region
export AWS_DEFAULT_REGION=${2:-eu-west-1}

while read -r line || [ -n "$line" ]
do
    # delete end of line
    line=${line//[[:space:]]/;}
    # set variables
    read url user passwd AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY trash <<< ${line//;/ }
    echo "Testing account $user"
    
    # export credentials
    export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY

    # test account
    aws ec2 describe-instances

done < $csv_credentials
