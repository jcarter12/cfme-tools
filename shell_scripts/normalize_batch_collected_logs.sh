#/bin/bash
find . -mindepth 1 -maxdepth 1 -type f -name 'evm_current*.tgz' -execdir normalize_current_tgz.sh {} \;
find . -mindepth 1 -maxdepth 1 -type f -name 'evm_full_archive*.tgz' -execdir normalize_archive_tgz.sh {} \;
