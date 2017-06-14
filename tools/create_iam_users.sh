#!/bin/bash

log () {
    echo "$@" >&2
}

[ $# -ne 2 ] && [ $# -ne 3 ] && {
    log "$0 <credentials file> <desired> [<region>]"
    exit 1
}

# set variables from parameters
csv_credentials=$1
desired=${2:-1}

export AWS_DEFAULT_REGION=${3:-eu-west-1}

# policies
managed_policies="AdministratorAccess"

count=1
while read -r line || [ -n "$line" ]
do
    # set variables from line
    line=${line//[[:space:]]/,}
    read login passwd AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY trash <<< ${line//,/ }

    export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY

    # set credentials for labs
    alias=$(echo "$login" |sed 's/\([^-]\+\)-[^-]\+-\([^-]\+\)@.*/\1\2/')
    user='trainee'
    password=$( date | md5sum | base64 | head -c 8)
    log "$alias $user $password"

    # create user
    aws iam create-account-alias --account-alias $alias

    aws iam create-user --user-name $user > /dev/null
    aws iam create-login-profile --user-name $user --password $password > /dev/null
    output=$(aws iam create-access-key --user-name $user --query 'AccessKey.[AccessKeyId,SecretAccessKey]' --output text)
    cred=($output)

    # set user rights
    for policy in $managed_policies; do
        aws iam attach-user-policy --user-name $user --policy-arn arn:aws:iam::aws:policy/$policy
    done
 
    # display configuration
    echo "https://$alias.signin.aws.amazon.com/console;$user;$password;${cred[0]};${cred[1]}"


    # finish if desired users have been created
    [ $count -ge $desired ] && break
 
    count=$((count+1))


    sleep 1

done < $csv_credentials
