#!/usr/bin/env bash

read -r result < <(curl -s https://releases.hashicorp.com/vagrant/ | while read line; do if [[ ${line##*vagrant/} =~ ^[[:digit:].]+/ ]]; then echo "${BASH_REMATCH//\/}"; fi; done;) && echo $result;
