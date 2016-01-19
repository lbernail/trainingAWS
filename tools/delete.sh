#!/bin/bash
set -x

file=$1
group="admin"

while read -r line
do
    a=(${line//,/ }) ;
    export AWS_ACCESS_KEY_ID=${a[0]}
    export AWS_SECRET_ACCESS_KEY=${a[1]}
    user=${a[2]}

    aws iam delete-account-alias --account-alias $user

    aws iam remove-user-from-group --group-name $group --user-name $user
    aws iam detach-group-policy --group-name $group --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
    aws iam delete-group --group-name $group
    aws iam delete-login-profile --user-name $user
    ak=$(aws iam list-access-keys --user-name $user --query 'AccessKeyMetadata[0].AccessKeyId' --output text)
    aws iam delete-access-key --user-name $user --access-key-id $ak
    aws iam delete-user --user-name $user

done < $file
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
