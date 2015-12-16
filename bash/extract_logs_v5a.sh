#!/bin/bash
find Archive*.zip Current*.zip | xargs -n 1 -P 1 -t unzip 
mv config log
mv -t log GUID BUILD VERSION
mv ROOT/opt/rh/postgresql92/root/var/lib/pgsql/data/*.conf  log
mv ROOT/opt/rh/postgresql92/root/var/lib/pgsql/data/pg_log/*.*   log
rm -r ROOT
zip -r rename_me log/
rm -r log
ruby  -v  ../ruby/Prepare_archive_logs_for_processing/main.rb *.log 1>prepare_archive_logs_stdout.lst 2>prepare_archive_logs_stderr.lst
