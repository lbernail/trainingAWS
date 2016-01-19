#!/bin/bash
set -e

file=$1
group="admin"

while read -r line
do
    a=(${line//,/ }) ;
    export AWS_ACCESS_KEY_ID=${a[0]}
    export AWS_SECRET_ACCESS_KEY=${a[1]}
    user=${a[2]}
    password=$( date | md5 | base64 | head -c 8)

    aws iam create-account-alias --account-alias $user

    aws iam create-user --user-name $user > /dev/null
    aws iam create-login-profile --user-name $user --password $password > /dev/null
    aws iam create-group --group-name $group > /dev/null
    aws iam attach-group-policy --group-name $group --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
    aws iam add-user-to-group --group-name $group --user-name $user


    output=$(aws iam create-access-key --user-name $user --query 'AccessKey.[AccessKeyId,SecretAccessKey]' --output text)
    cred=($output)

    echo "https://$user.signin.aws.amazon.com/console $user $password ${cred[0]} ${cred[1]}"
done < $file
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
