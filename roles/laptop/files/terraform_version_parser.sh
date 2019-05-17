#!/usr/bin/env bash

read -r result < <(curl -s https://releases.hashicorp.com/terraform/ | while read line; do if [[ ${line##*terraform/} =~ ^[[:digit:].]+/ ]]; then echo "${BASH_REMATCH//\/}"; fi; done;) && echo $result;

