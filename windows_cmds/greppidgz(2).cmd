gzip -dc evm.log.gz |grep -iE "(\#|\[)%1(\:|\])" - > pid_%1_evm.txt
grep -iE "(\#|\[)%1(\:|\])" production.log > pid_%1_production.txt
exit