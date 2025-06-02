#!/bin/bash
# run_ansible on the vagrant box
ansible-playbook -i inventory/vagrant.ini playbook/playbook.yml
