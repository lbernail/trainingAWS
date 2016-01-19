#!/bin/bash
set -e

file=$1
group="admin"

while read -r line
do
    a=($line)
    export AWS_ACCESS_KEY_ID=${a[3]}
    export AWS_SECRET_ACCESS_KEY=${a[4]}

    echo "Testing account ${a[1]}"
    aws ec2 describe-instances
done < $file
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
