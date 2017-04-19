#!/bin/bash

# set variables from parameters
csv_credentials=$1
export AWS_DEFAULT_REGION=${3:-eu-west-1}

# policies
managed_policies="AdministratorAccess"


log () {
    echo "$@" >&2
}

while read -r line || [ -n "$line" ]
#while read -r line
do
    # set variables from line
    line=${line//[[:space:]]/,}
    read login passwd AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY trash <<< ${line//,/ }
    user=$(echo "$login" |sed 's/\([^-]\+\)-[^-]\+-\([^-]\+\)@.*/\1\2/')

    export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY

    log "Clean account alias $user"
    # clean account alias
    aws iam list-account-aliases --query 'AccountAliases' --output text | grep -q "$user" &&
        aws iam delete-account-alias --account-alias "$user"

    aws iam list-users | grep -q "$user" || continue
    log "Clean $user"
    aws iam delete-login-profile --user-name "$user"

    access_key_ids=$(aws iam list-access-keys --user-name "$user" --query 'AccessKeyMetadata[*][AccessKeyId]' --output text)
    for aki in $access_key_ids; do
        aws iam delete-access-key --user-name $user --access-key-id "$aki"
    done

    inline_policies=$(aws iam list-user-policies --user-name $user --query 'PolicyNames[*]' --output text)
    for policy in $inline_policies; do
        aws iam delete-user-policy --user-name $user --policy-name "$policy"
    done

    for policy in $managed_policies; do
        aws iam detach-user-policy --user-name $user --policy-arn arn:aws:iam::aws:policy/$policy
    done

    aws iam delete-user --user-name $user

done < "$csv_credentials"