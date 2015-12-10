echo on > zip_stdout.log
rem
rem   Modified extract_logs_v5 to use only linux commands normalize CFME UI collected archive and current log bundles
rem   to normalized zip file format with normalized name in preparation for bundle analysis
rem      Tom Hennessy 2015-04-01
rem
rem "C:\Program Files\7-Zip\7z" e current_*.zip -o.\log log\*.log log\*.txt VERSION GUID BUILD ROOT\opt\rh\postgresql92\root\var\lib\pgsql\data\*  ROOT\opt\rh\postgresql92\root\var\lib\pgsql\data\pg_log\* -r  >> zip_stdout.log 2>&1
rem "for %%i in (archive*.zip) do call unzip  %%i"  >> zip_stdout.log 2>&1
echo "for %%i in (archive*.zip) do call unzip  %%i"  >> zip_stdout.log 2>&1
echo "c:\cygwin64\bin\find Archive*.zip Current*.zip | xargs -n 1 -P 1 -t unzip " >>zip_stdout.log 2>&1  
c:\cygwin64\bin\find Archive*.zip Current*.zip | xargs -n 1 -P 1 -t unzip 
rem Iterate thru archive set to decompress all logrorate files into log directory
echo "Iterate thru archive set to decompress all logrorate files into log directory"   >>zip_stdout.log 2>&1

rem "for %%i in (Current*.zip) do call unzip %%i" >> zip_stdout.log 2>&1
echo  "for %%i in (Current*.zip) do call unzip %%i" >> zip_stdout.log 2>&1

rem for %%i in (Current*.zip) do call unzip %%i     >> zip_stdout.log 2>&1
echo "for %%i in (Current*.zip) do call unzip %%i"     >> zip_stdout.log 2>&1
rem move config directory under log directory
rem "mv config log" >> zip_stdout.log 2>&1
echo  "mv config log" >> zip_stdout.log 2>&1
mv config log             >> zip_stdout.log 2>&1
rem "mv -t log GUID BUILD VERSION " >> zip_stdout.log 2>&1
echo "mv -t log GUID BUILD VERSION " >> zip_stdout.log 2>&1
mv -t log GUID BUILD VERSION     >> zip_stdout.log 2>&1
rem move postgresql files (*.conf, postgresql.log and logrotates of that file) directly into log directory
rem "mv ROOT/opt/rh/postgresql92/root/var/lib/pgsql/data/*.conf  log " >> zip_stdout.log 2>&1
echo "mv ROOT/opt/rh/postgresql92/root/var/lib/pgsql/data/*.conf  log " >> zip_stdout.log 2>&1
mv ROOT/opt/rh/postgresql92/root/var/lib/pgsql/data/*.conf  log      >> zip_stdout.log 2>&1
rem "mv ROOT/opt/rh/postgresql92/root/var/lib/pgsql/data/pg_log/*.*   log" >> zip_stdout.log 2>&1
echo "mv ROOT/opt/rh/postgresql92/root/var/lib/pgsql/data/pg_log/*.*   log" >> zip_stdout.log 2>&1
mv ROOT/opt/rh/postgresql92/root/var/lib/pgsql/data/pg_log/*.*   log    >> zip_stdout.log 2>&1

rem remove empty and unwanted directories
rem "rm -r ROOT" >> zip_stdout.log 2>&1
echo "rm -r ROOT" >> zip_stdout.log 2>&1
rm -r ROOT            >> zip_stdout.log 2>&1

rem zip up log directory into rename_me.zip
rem "zip -r rename_me log/ " >> zip_stdout.log 2>&1
echo "zip -r rename_me log/ " >> zip_stdout.log 2>&1
zip -r rename_me log/    >> zip_stdout.log 2>&1
 
rem after log directory is ziped into 'rename_me.zip' purge the log directory
rem "rm -r log   " >> zip_stdout.log 2>&1
echo "rm -r log   " >> zip_stdout.log 2>&1
rm -r log         >> zip_stdout.log 2>&1
ruby  -v  "C:\Documents and Settings\Administrator\My Documents\NetBeansProjects\Prepare_archive_logs_for_processing\lib\main.rb" *.log 1>prepare_archive_logs_stdout.lst 2>prepare_archive_logs_stderr.lst
rem exit
