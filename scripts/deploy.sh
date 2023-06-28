#!/bin/bash
set -e
cd "$(dirname "$0")" && cd ..

ACTION=$1
if [[ "$ACTION" == "-deploy" ]]; then
	cd infrastructure
	echo "[i] running init"
	terraform init
	echo "[i] running deployment!"
	terraform apply
elif [[ "$ACTION" == "-destroy" ]]; then
	cd infrastructure
	echo "[i] running init"
	terraform init
	echo "[i] running destroy!!!"
	terraform destroy
fi


echo "[i] done!"

