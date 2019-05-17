#!/usr/bin/env bash

user="$1"
repo="$2"
label="$3"

num_assets="$(($(jq '.assets | length' ~/.install/$1/$2/latest_release_metadata.json)-1))"

for num in $(seq 0 $num_assets); \
do \
  eval jq \'.assets[$num]\' ~/.install/$1/$2/latest_release_metadata.json \
  | while read line; \
    do \
       if [[ $line =~ $3 ]]; then \
	echo "$(eval jq -r \'.assets[$num].browser_download_url\' ~/.install/$1/$2/latest_release_metadata.json)";
      fi;
    done;

done
