echo on
time /T
%1
cd %2
ruby  -v  "C:\documents and settings\administrator\my documents\NetBeansProjects\process_appliance_log_bundle\lib\process_appliance_log_bundle.rb"  1>stdout.lst 2>stderr.lst
time /T
for /d %%i in (*_analyzd) do start /d "%%i" start v4_hourly_healthcheck.cmd
call launch_analysis.cmd
echo off
exit