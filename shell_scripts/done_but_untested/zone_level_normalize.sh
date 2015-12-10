#!/bin/bash
for subdir in * ; do
    cd $subdir
    appliance_level_normalize.sh
done
