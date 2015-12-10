#/bin/bash
ruby  -v  ~/documents/thennessy/archive/ruby\ source\ materials/Analyze_last_startup/lib/Analyze_last_startup.rb  last_startup.txt 1>last_startup_stdout.lst 2>last_startup_stderr.lst
grep -iE "^(miqtop|top|swap|mem|cpu\(s\)|  PID|tasks|KiB|.cpu)" top_output.log >top_summary_output.log
ruby  ~/documents/thennessy/archive/ruby\ source\ materials/process_top_output/lib/process_top_output.rb top_summary_output.log 1>top_output_sstdout.lst 2>top_output_stderr.lst
gzip -9 top_output.log
