#/bin/bash
#$1 #what is this doing, currently it looks like it is launching the first parameter as a command accessable in the $PATH
#cd $2
pg84_serverlog_analyze_v2.awk serverlog
process_production_log.sh
ruby -v ../ruby/EVMServer-log-to-db/main.rb evm.log production.log 1>stdout.lst 2>stderr.lst
gzip -9 evm.log top_output.log serverlog
cd pid_files
gzip -9 *.log
