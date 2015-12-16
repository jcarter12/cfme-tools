#!/bin/bash
grep -iE "(\#|\[)$1(\:|\])" evm.log > pid_$1_evm.txt
grep -iE "(\#|\[)$1(\:|\])" production.log > pid_$1_production.txt
