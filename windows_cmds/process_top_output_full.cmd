echo on
time /T
rem %1
rem cd %2
ruby  -v  "C:\documents and settings\administrator\my documents\NetBeansProjects\Analyze_last_startup\lib\Analyze_last_startup.rb"  ..\last_startup.txt 1>last_startup_stdout.lst 2>last_startup_stderr.lst
time /T
ruby  "C:\documents and settings\administrator\my documents\netbeansprojects\process_top_output\lib\process_top_output.rb" ..\top_output.log 1>top_output_sstdout.lst 2>top_output_stderr.lst
rem ruby  "C:\documents and settings\administrator\my documents\netbeansprojects\process_top_output\lib\process_top_output_revised_0.rb" top_output.log 1>top_output_sstdout.lst 2>top_output_stderr.lst
time /T
rem top_summary_stats.csv
rem rename_top_pdf
echo off
exit
