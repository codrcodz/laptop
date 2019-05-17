#!/usr/bin/env bash

box_list=( $(vagrant box list | while read name type _; do echo $name::${type:1: -1}; done)  );
item="$1";
provider=$2;
if [[ "${box_list[@]}" =~ ${item}::${provider} ]]; then \
  update_attempt="$(vagrant box update --box ${item} --provider ${provider} --force)";
  update_rc="$(echo $?)";
  if [[ ${update_attempt} =~ latest ]]; then \
    echo "Box (${item}/${provider}) already up to date.";
    exit 0;
  elif [[ ${update_rc} != "0" ]]; then \
    echo "Box (${item}/${provider}) failed to update." 2>&1;
    exit 1;
  else
    echo "Box (${item}/${provider}) was updated."
    prune_attempt="$(vagrant box prune --name ${item} --provider ${provider})";
    prune_rc="$(echo $?)";
    if [[ "${prune_rc}" == "0" ]]; then
      echo "Box (${item}/${provider}) was pruned of old versions.";
    else
      echo "Box (${item}/${provider}) was unable to be pruned of old versions.";
    fi;
    exit 11;
  fi;
else
  add_attempt="$(vagrant box add --provider ${provider} ${item})";
  add_rc="$(echo $?)";
  if [[ "${add_rc}" != "0" ]]; then
    echo "Unable to add box (${item})." 2>&1
    exit 1;
  else
    echo "Added box (${item}) successfully."
    exit 11;
  fi;
fi;
