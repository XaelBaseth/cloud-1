#!/bin/bash

cd terraform
terraform init
terraform apply -auto-approve
cd ../ansible
python3 generate_inventory.py
source ../../../.venv/bin/activate
ansible-playbook -i inventory.ini playbook/playbook.yml