#!/bin/bash
for folder in * ; do
  if [ -d "$folder" ]; then
    cd $folder
    individual_logset_normalize.sh
    cd ..
  fi
done
