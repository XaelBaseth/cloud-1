#!/bin/bash
set -e

cd terraform/vagrant
terraform init -input=false
terraform apply -auto-approve
cd ../..

python3 ansible/generate_inventory.py vagrant

cd ansible
ansible-playbook -i inventory.ini playbook/playbook.yml
