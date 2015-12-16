#!/bin/bash
find . -type d -maxdepth 1 -mindepth 1 -execdir normalize_manually_collected_logs.sh {} \;
