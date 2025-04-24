#!/bin/bash
vagrant up
source ../../.venv/bin/activate
# run_ansible on the vagrant box
ansible-playbook -i inventory/vagrant.ini playbook/playbook.yml
