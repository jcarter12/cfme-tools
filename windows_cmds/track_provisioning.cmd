echo on
time /T
%1
cd %2

ruby  -v  "C:\Documents and Settings\Administrator\My Documents\NetBeansProjects\TrackProvision\lib\main.rb" *.log 1>TrackProvision_stdout.lst 2>TrackProvision_stderr.lst
time /T
echo off
exit