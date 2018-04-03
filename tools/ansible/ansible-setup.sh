#!/bin/bash

if [ ! -f /etc/ansible/ansible.cfg ]; then

  # Install ansible

  /usr/bin/apt-add-repository ppa:ansible/ansible -y

  /usr/bin/apt-get update

  /usr/bin/apt-get install ansible -y

fi
