echo on
time /T
rem %1
rem cd %2
ruby  "C:\documents and settings\administrator\my documents\netbeansprojects\process_vmstat_output\lib\main.rb" vmstat_output.log 1>vmstat_output_sstdout.lst 2>&1
time /T
echo off
exit
