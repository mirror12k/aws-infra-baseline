#!/bin/sh

set -e

AWS_USERNAME=$(aws sts get-caller-identity | jq -r '.Arn | split("/")[1]')
AWS_MFA_DEVICE_ARN=$(aws iam list-mfa-devices --user-name "$AWS_USERNAME" | jq -r '.MFADevices[0].SerialNumber')
echo -n "please enter your mfa token for device $AWS_MFA_DEVICE_ARN: "
read MFA_TOKEN
AWS_CREDS=$(aws sts get-session-token --serial-number "$AWS_MFA_DEVICE_ARN" --token-code "$MFA_TOKEN" --duration-seconds 7200)
# echo "creds: $AWS_CREDS"
AWS_ACCESS_ID=$(echo "$AWS_CREDS" | jq -r ".Credentials.AccessKeyId")
AWS_ACCESS_KEY=$(echo "$AWS_CREDS" | jq -r ".Credentials.SecretAccessKey")
AWS_SESSION_TOKEN=$(echo "$AWS_CREDS" | jq -r ".Credentials.SessionToken")
echo "got id and key: $AWS_ACCESS_ID"
aws configure set aws_access_key_id "${AWS_ACCESS_ID}"
aws configure set aws_secret_access_key "${AWS_ACCESS_KEY}"
aws configure set aws_session_token "${AWS_SESSION_TOKEN}"


