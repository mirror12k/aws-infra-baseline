#!/bin/bash

set -e

export $(cat .env | xargs)


aws configure set aws_access_key_id ${AWS_ACCESS_ID}
aws configure set aws_secret_access_key ${AWS_ACCESS_KEY}
echo "[+] initial configure done"

./scripts/aws-authenticate-mfa.sh
echo "[+] mfa login done"
./scripts/aws-assumerole-organizational.sh
echo "[+] assume role done"

echo "[+] now run './scripts/deploy -deploy' to put baseline resources into the account"
bash


