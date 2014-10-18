#!/bin/bash

function process {
  while IFS=, read id name boro building street zip date score grade ; do
    date=${date%' 00:00:00'}
    mkdir -p data/$boro/$zip
    echo "$id,$name,$boro,$building,$street,$zip,$date,$score,$grade" >> \
      data/$boro/$zip/$id
  done
}

./csvconvert.py | grep -v ,, | cut -d, -f1-6,9,12,13 | sed -n '2,$p' |
                  sort -u | process
