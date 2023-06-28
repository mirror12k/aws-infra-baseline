#!/bin/sh

set -e

echo -n "please enter your organizational account id: "
read ACCOUNT_ID
AWS_CREDS=$( aws sts assume-role --role-arn "arn:aws:iam::$ACCOUNT_ID:role/OrganizationAccountAccessRole" --role-session-name adminlogin --duration-seconds 3600)
# echo "creds: $AWS_CREDS"
AWS_ACCESS_ID=$(echo "$AWS_CREDS" | jq -r ".Credentials.AccessKeyId")
AWS_ACCESS_KEY=$(echo "$AWS_CREDS" | jq -r ".Credentials.SecretAccessKey")
AWS_SESSION_TOKEN=$(echo "$AWS_CREDS" | jq -r ".Credentials.SessionToken")
echo "got id and key: $AWS_ACCESS_ID"
aws configure set aws_access_key_id "${AWS_ACCESS_ID}"
aws configure set aws_secret_access_key "${AWS_ACCESS_KEY}"
aws configure set aws_session_token "${AWS_SESSION_TOKEN}"


