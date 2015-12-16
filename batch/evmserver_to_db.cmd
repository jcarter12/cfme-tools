echo on
time /T
%1
cd %2
rem echo log datetime,wait duration (seconds) >vm_perf_capture_dequeue_times.csv
rem egrep -i "vm\.perf_capture" evm.log | egrep -i "dequeued in\:" | cut -d' ' -f3,54 |sed 's/\ \[/,/g'|sed 's/\[//g' |sed 's/\]//g' | sed 's/T/ /g' >>vm_perf_capture_dequeue_times.csv
rem egrep -i "miqlicense" evm.log > miqlicense.txt
rem gawk -f c:\awk\pg84_serverlog_analyze_v1.awk.c serverlog
gawk -f c:/awk/pg84_serverlog_analyze_v1.awk.c serverlog
call process_production_log
rem evm_log_stats > evm_log_stats.stdout 2>&1
rem  rename evm.log evm_original.logrem 
rem  grep -v "\: HandSoap" evm_original.log | grep -v "\: MiqVimUpdate.monitorUpdates\:" > evm.log
ruby  -v  "C:\documents and settings\administrator\my documents\NetBeansProjects\EVMServer-log-to-db\lib\main.rb" evm.log production.log 1>stdout.lst 2>stderr.lst
gzip -9 evm.log top_output.log serverlog
rem no server log, bc none from awk script
cd pid_files
gzip -9 *.log
rem error none
time /T
echo off
exit
