#/bin/bash
gzip -dc evm.log.gz | grep -i $1 - > $1.txt
