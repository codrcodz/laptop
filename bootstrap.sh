#!/usr/bin/env bash

# Ensure script is run as a root
if [[ "${EUID}" != "0" ]] || [[ "${#SUDO_USER}" != "0" ]]; then
  echo "Must 'su root' prior to running.";
  exit 1;
fi

apt-get update && apt-get install -y python3-pip && pip3 install ansible==2.7;

